

process BEAVE_CALC {
    label 'process_medium'
    container  workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ?  params.beave.get('singularity')  :  params.beave.get('docker')

    input:
    tuple path(calc_profiles), val(cluster_name)

    output:
    tuple path("${cluster_name}.summary.tsv"), val(cluster_name), emit: numeric_summary

    script:
    """
    beave_calc.py $calc_profiles $cluster_name -o ${cluster_name}.summary.tsv
    """

}
