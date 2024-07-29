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
include { LOCIDEX_MERGE } from '../modules/local/locidex/merge/main'
include { MAP_TO_TSV } from '../modules/local/map_to_tsv.nf'
include { ARBORATOR } from '../modules/local/arborator/main'
include { ARBOR_VIEW } from '../modules/local/arborview'
include { BUILD_CONFIG } from '../modules/local/buildconfig/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow CLUSTER_SPLITTER {

    ID_COLUMN = "sample"
    ch_versions = Channel.empty()
    input = Channel.fromSamplesheet("input")

    // Metadata headers:
    metadata_headers = Channel.value(
        tuple(
            ID_COLUMN, params.metadata_partition_name,
            params.metadata_1_header, params.metadata_2_header,
            params.metadata_3_header, params.metadata_4_header,
            params.metadata_5_header, params.metadata_6_header,
            params.metadata_7_header, params.metadata_8_header)
        )

    // Metadata rows:
    metadata_rows = input.map{
        meta, mlst_files -> tuple(meta.id, meta.metadata_partition,
        meta.metadata_1, meta.metadata_2, meta.metadata_3, meta.metadata_4,
        meta.metadata_5, meta.metadata_6, meta.metadata_7, meta.metadata_8)
    }.toList()

    // Merging individual JSON-formatted genomic profile files
    // into one TSV-formatted file:
    profiles_merged = LOCIDEX_MERGE(input.map{
        meta, alleles -> alleles
    }.collect())
    ch_versions = ch_versions.mix(profiles_merged.versions)

    // Mapping metadata provided in the sample sheet
    // into a Arborator-compatible TSV-formatted file:
    merged_metadata_output = MAP_TO_TSV(metadata_headers, metadata_rows)
    merged_metadata_path = merged_metadata_output.tsv_path
    nonempty_column_headers = merged_metadata_output.nonempty_column_headers

    // Build an Arborator config file is none was provided:
    arborator_config = params.ar_config ? params.ar_config : BUILD_CONFIG(nonempty_column_headers).config

    // Arborator:
    arborator_output = ARBORATOR(
        merged_profiles=profiles_merged.combined_profiles,
        metadata=merged_metadata_path,
        configuration_file=arborator_config,
        id_column=ID_COLUMN,
        partition_col=params.metadata_partition_name,
        thresholds=params.ar_thresholds)

    ch_versions = ch_versions.mix(arborator_output.versions)

    // ArborView
    trees = arborator_output.trees.flatten().map {
        tuple(it.getParent().getBaseName(), it)
    }

    metadata_for_trees = arborator_output.metadata.flatten().map{
        tuple(it.getParent().getBaseName(), it)
    }

    trees_meta = trees.join(metadata_for_trees)
    tree_html = file("$projectDir/assets/ArborView.html")
    ARBOR_VIEW(trees_meta, tree_html)

    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )
}


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
