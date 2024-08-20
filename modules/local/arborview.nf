/*
Generates a visualization of a dendogram alongside metadata.
*/


process ARBOR_VIEW {
    label "process_low"
    tag "Inlining tree data for: $cluster_group"
    stageInMode 'copy' // Need to copy in arbor view html

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python%3A3.12' :
        'biocontainers/python:3.12' }"

    input:
    tuple val(cluster_group), path(tree), path(contextual_data)
    path(arbor_view) // need to make sure this is copied


    output:
    path(output_value), emit: html


    script:
    output_value = "${cluster_group}_arborview.html"
    """
    inline_arborview.py -d ${contextual_data} -n ${tree} -o ${output_value} -t ${arbor_view}
    """



}
