/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PRINT PARAMS SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { paramsSummaryLog; paramsSummaryMap; fromSamplesheet  } from 'plugin/nf-validation'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
include { WRITE_METADATA  } from '../modules/local/write/main'
include { LOCIDEX_MERGE   } from '../modules/local/locidex/merge/main'
include { LOCIDEX_CONCAT  } from '../modules/local/locidex/concat/main'
include { COPY_FILE       } from '../modules/local/copyFile/main'
include { MAP_TO_TSV      } from '../modules/local/maptotsv/main'
include { ARBORATOR       } from '../modules/local/arborator/main'
include { ARBOR_VIEW      } from '../modules/local/arborview/main'
include { BUILD_CONFIG    } from '../modules/local/buildconfig/main'
include { ZIP_OUTPUT      } from '../modules/local/zippy/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'
include { loadIridaSampleIds          } from 'plugin/nf-iridanext'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow CLUSTER_SPLITTER {

    ID_COLUMN = "sample_name"
    ID_COLUMN2 = "sample"
    ch_versions = Channel.empty()

    // Track processed IDs
    def processedIDs = [] as Set
    def processedMLST = [] as Set

    pre_input = Channel.fromSamplesheet("input")
    // and remove non-alphanumeric characters in sample_names (meta.id), whilst also correcting for duplicate sample_names (meta.id)
    .map { meta, mlst_file ->
            uniqueMLST = true
            if (!meta.id) {
                meta.id = meta.irida_id
            } else {
                // Non-alphanumeric characters (excluding _,-,.) will be replaced with "_"
                meta.id = meta.id.replaceAll(/[^A-Za-z0-9_.\-]/, '_')
            }
            // Ensure ID is unique by appending meta.irida_id if needed
            while (processedIDs.contains(meta.id)) {
                meta.id = "${meta.id}_${meta.irida_id}"
            }

            // Check if the MLST file is unique
            if (processedMLST.contains(mlst_file.baseName)) {
                uniqueMLST = false
            }
            // Add the ID to the set of processed IDs
            processedIDs << meta.id
            processedMLST << mlst_file.baseName

            tuple(meta, mlst_file, uniqueMLST)}.loadIridaSampleIds()


    // For the MLST files that are not unique, rename them
    pre_input
        .branch { meta, mlst_file, uniqueMLST ->
            keep: uniqueMLST == true // Keep the unique MLST files as is
            replace: uniqueMLST == false // Rename the non-unique MLST files to avoid collisions
        }.set {mlst_file_rename}
    renamed_input = COPY_FILE(mlst_file_rename.replace)
    unchanged_input = mlst_file_rename.keep
        .map { meta, mlst_file, uniqueMLST ->
            tuple(meta, mlst_file) }
    input = unchanged_input.mix(renamed_input)

    // Metadata headers:
    metadata_headers = Channel.value(
        tuple(
            ID_COLUMN, ID_COLUMN2, params.metadata_partition_name,
            params.metadata_1_header, params.metadata_2_header,
            params.metadata_3_header, params.metadata_4_header,
            params.metadata_5_header, params.metadata_6_header,
            params.metadata_7_header, params.metadata_8_header,
            params.metadata_9_header, params.metadata_10_header,
            params.metadata_11_header, params.metadata_12_header,
            params.metadata_13_header, params.metadata_14_header,
            params.metadata_15_header, params.metadata_16_header)
        )

    // Metadata rows:
    metadata_rows = input.map{
        meta, mlst_files -> tuple(meta.id, meta.irida_id, meta.metadata_partition,
        meta.metadata_1, meta.metadata_2, meta.metadata_3, meta.metadata_4,
        meta.metadata_5, meta.metadata_6, meta.metadata_7, meta.metadata_8,
        meta.metadata_9, meta.metadata_10, meta.metadata_11, meta.metadata_12,
        meta.metadata_13, meta.metadata_14, meta.metadata_15, meta.metadata_16)
    }.toList()
    // Prepare MLST files for LOCIDEX_MERGE

    merged_alleles = input
    .map { meta, mlst_file ->
        mlst_file
    }.collect()

    // Create channels to be used to create a MLST override file (below)
    SAMPLE_HEADER = "sample"
    MLST_HEADER   = "mlst_alleles"

    write_metadata_headers = Channel.of(
        tuple(
            SAMPLE_HEADER, MLST_HEADER)
        )
    write_metadata_rows = input.map{
        def meta = it[0]
        def mlst = it[1]
        tuple(meta.id,mlst)
    }.toList()

    merge_tsv = WRITE_METADATA (write_metadata_headers, write_metadata_rows).results.first() // MLST override file value channel

    // Merge MLST files into TSV

    // 1A) Divide up inputs into groups for LOCIDEX
    def batchCounter = 1
    grouped_ref_files = merged_alleles.flatten() //
        .buffer( size: params.batch_size, remainder: true )
                .map { batch ->
        def index = batchCounter++
        return tuple(index, batch)
    }
    // 1B) Run LOCIDEX

    // Merging individual JSON-formatted genomic profile files
    // into one TSV-formatted file:
    merged = LOCIDEX_MERGE(grouped_ref_files, merge_tsv)
    ch_versions = ch_versions.mix(merged.versions)

    // LOCIDEX Step 2:
    // Combine outputs

    // LOCIDEX Concatenate

    combined_merged = LOCIDEX_CONCAT(merged.combined_profiles.collect(),
    merged.combined_error_report.collect(),
    merged.combined_profiles.collect().flatten().count())

    // Mapping metadata provided in the sample sheet
    // into a Arborator-compatible TSV-formatted file:
    merged_metadata_output = MAP_TO_TSV(metadata_headers, metadata_rows)
    merged_metadata_path = merged_metadata_output.tsv_path
    nonempty_column_headers = merged_metadata_output.nonempty_column_headers

    // Build an Arborator config file is none was provided:
    arborator_config = params.ar_config ? params.ar_config : BUILD_CONFIG(nonempty_column_headers).config

    // Arborator:
    arborator_output = ARBORATOR(
        merged_profiles=combined_merged.combined_profiles,
        metadata=merged_metadata_path,
        configuration_file=arborator_config,
        id_column=ID_COLUMN,
        partition_col=params.metadata_partition_name,
        thresholds=params.ar_thresholds)

    ch_versions = ch_versions.mix(arborator_output.versions)

    // ArborView
    trees = arborator_output.trees.flatten().map {
        tuple(it.getParent().getName(), it)
    }

    metadata_for_trees = arborator_output.metadata.flatten().map{
        tuple(it.getParent().getName(), it)
    }

    trees_meta = trees.join(metadata_for_trees)
    tree_html = file("$projectDir/assets/ArborView.html")
    ARBOR_VIEW(trees_meta, tree_html)

    ch_versions = ch_versions.mix(ARBOR_VIEW.out.versions)

    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )
    all_arborator_files = arborator_output.trees
        .combine(arborator_output.metadata)
        .combine(arborator_output.clusters_tsv)
        .combine(arborator_output.loci_summary)
        .combine(arborator_output.matrix_tsv)
        .combine(arborator_output.outliers)
        .combine(arborator_output.profiles)
        .combine(arborator_output.cluster_summary)
        .combine(arborator_output.metadata_excluded)
        .combine(arborator_output.metadata_included)
        .combine(arborator_output.threshold_map)
        .combine(arborator_output.run_json)
    all_arborator_files.flatten().map {
        file ->
        def elements = file.toString().tokenize(File.separator)
        def cluster_name = elements[-2]
        def file_name = elements[-1]

        repeated_file_names = ["tree.nwk", "metadata.tsv","clusters.tsv", "loci.summary.tsv", "matrix.tsv", "profile.tsv","outliers.tsv"]
        def new_name
        if (repeated_file_names.contains(file_name)) {
            new_name = cluster_name + "_" + file_name
        } else {
            new_name = file_name
        }
        def renamedFile = file.copyTo("${file.parent}/${new_name}")
        return renamedFile
    }.collect().set{renamed_arborator_files}
    !(params.zip_cluster_results) ?: ZIP_OUTPUT(ARBOR_VIEW.out.html.collect(),
        renamed_arborator_files,
        CUSTOM_DUMPSOFTWAREVERSIONS.out[0])


}


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
