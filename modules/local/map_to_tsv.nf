/*
    Convert a list of lazyMaps into a tsv for later passing into arborator
*/

process MAP_TO_TSV {
    tag "aggregate_tsv"
    label 'process_single'

    input:
    val metadata_headers
    val metadata_rows

    output:
    path(output_place),          emit: tsv_path
    val nonempty_column_headers, emit: nonempty_column_headers

    exec:
    def output_file = "aggregated_data.tsv"
    if (metadata_headers.size() <= 0 || metadata_rows.size() <= 0){
        log.error "Metadata fields are empty"
        exit 1, "Metadata fields are empty"
    }

    def delimiter = '\t'
    output_place = task.workDir.resolve(output_file)

    metadata = [metadata_headers] + metadata_rows
    metadata = metadata.transpose()
    
    for (int i in (metadata.size()-1)..0) {
        // Working in reverse order, remove all columns that contain no entries,
        // excluding the header itself.
        if (metadata[i][1..-1].every {it == "" || it == null}) {
            metadata.removeAt(i)
        }
        // If the column is not removed, replace any null headers to prevent issues:
        // https://github.com/askimed/nf-test/issues/226
        else if(metadata[i][0] == null) {
            metadata[i][0] = ""
        }
    }

    metadata = metadata.transpose()
    nonempty_column_headers = metadata[0]

    output_place.withWriter{ writer ->

        metadata.each{ row ->
            writer.writeLine "${row.join(delimiter)}"
        }
    }
}
