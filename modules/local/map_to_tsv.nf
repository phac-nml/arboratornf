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
    
    for (int i in (metadata.size()-1)..0) { // Reverse order
        if (metadata[i][1..-1].every {it == ""}) { // Every except for header
            metadata.removeAt(i)
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
