process WRITE_METADATA {
    tag "write metadata"
    label 'process_single'

    input:
    val metadata_headers
    val metadata_rows

    output:
    path("results.csv"), emit: results

    exec:
    def replaceInvalidSeparatorCharacters = { value ->
        value.toString()
            .replace('\t', '_')
            .replace('\n', '_')
            .replace('\r', '_')
    }

    task.workDir.resolve("results.csv").withWriter { writer ->
        // Header:
        writer.writeLine(metadata_headers.collect(replaceInvalidSeparatorCharacters).join(","))

        // Contents:
        metadata_rows.each {
            writer.writeLine(it.collect(replaceInvalidSeparatorCharacters).join(","))
        }
    }
}
