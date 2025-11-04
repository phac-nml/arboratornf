process ZIP_OUTPUT {
    tag 'Zip output files'
    label "process_single"

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/p7zip:16.02' :
        'biocontainers/p7zip:16.02' }"
    input:
    path arborview_files
    path arborator_files
    path software_version_file

    output:
    path "*.zip"

    script:
    """
    # -l : Don't store symlinks, store the files they point to
    7za a -l "arboratornf.zip" $arborview_files $arborator_files $software_version_file
    """
}
