/*
Merges multiple genomic profiles provided in the sample sheet into one TSV-formatted file.
*/

process LOCIDEX_MERGE {
    tag 'Merge Profiles'
    label 'process_single'
    fair true

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/locidex%3A0.4.0--pyhdfd78af_0' :
        'biocontainers/locidex:0.4.0--pyhdfd78af_0' }"

    containerOptions "${task.ext.containerOptions ?: ''}"

    input:
    tuple val(id), val(irida_id), val(cluster_name), path(mlst_files) // [file(sample1), file(sample2), file(sample3), etc...]

    output:
    tuple path("profile_${cluster_name}.tsv"), val(cluster_name), emit: combined_profiles
    //path("MLST_error_report_${cluster_name}.csv"), emit: combined_error_report
    path "versions.yml", emit: versions

    script:
    combined_dir = "merged"
    """
    locidex merge -i ${mlst_files.join(' ')} -o ${combined_dir}
    #mv ${combined_dir}/MLST_error_report.csv MLST_error_report_${cluster_name}.csv
    mv ${combined_dir}/profile.tsv profile_${cluster_name}.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        locidex: \$(echo \$(locidex search -V 2>&1) | sed 's/^.*locidex search //' )
    END_VERSIONS
    """
}
