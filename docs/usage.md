# phac-nml/arboratornf: Usage

## Introduction

This [Nextflow](https://www.nextflow.io/) pipeline implements [Arborator](https://github.com/phac-nml/arborator). Arborator takes as input JSON-formatted genomic profiles and corresponding metadata, groups genomic profiles according to specified metadata criteria, and then summarizes each group and its corresponding metadata.

## Samplesheet Input

You will need to create a samplesheet with information about the samples you would like to analyse before running the pipeline. Use this parameter to specify its location. It has to be a comma-separated file with 3 columns, and a header row as shown in the examples below.

```bash
--input '[path to samplesheet file]'
```

### Full Standard Samplesheet

The input samplesheet must contain the following columns: `sample`, `mlst_alleles`, `metadata_partition`, and `metadata_1` through `metadata_50`. The IDs (sample column) within a samplesheet should be unique and contain no spaces. Any other additionally specified trailing columns will be ignored.

An input sample sheet compatible with this workflow would look as follows:

```console
sample,mlst_alleles,metadata_partition,metadata_1,metadata_2,metadata_3,metadata_4,metadata_5,metadata_6,metadata_7,metadata_8,metadata_9,metadata_10,metadata_11,metadata_12,metadata_13,metadata_14,metadata_15,metadata_16,metadata_16,metadata_17,metadata_18,metadata_19,metadata_20,metadata_21,metadata_22,metadata_23,metadata_24,metadata_25,metadata_26,metadata_27,metadata_28,metadata_29,metadata_30,metadata_31,metadata_32,metadata_33,metadata_34,metadata_35,metadata_36,metadata_37,metadata_38,metadata_39,metadata_40,metadata_41,metadata_42,metadata_43,metadata_44,metadata_45,metadata_46,metadata_47,metadata_48,metadata_49,metadata_50
S1,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S1.mlst.json,1,"Escherichia coli","EHEC/STEC","Canada","O157:H7",21,"2024/05/30","beef",true,s1-meta9,s1-meta10,s1-meta11,s1-meta12,s1-meta13,s1-meta14,s1-meta15,s1-meta16,s1-meta16,s1-meta17,s1-meta18,s1-meta19,s1-meta20,s1-meta21,s1-meta22,s1-meta23,s1-meta24,s1-meta25,s1-meta26,s1-meta27,s1-meta28,s1-meta29,s1-meta30,s1-meta31,s1-meta32,s1-meta33,s1-meta34,s1-meta35,s1-meta36,s1-meta37,s1-meta38,s1-meta39,s1-meta40,s1-meta41,s1-meta42,s1-meta43,s1-meta44,s1-meta45,s1-meta46,s1-meta47,s1-meta48,s1-meta49,s1-meta50
S2,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S2.mlst.json,1,"Escherichia coli","EHEC/STEC","The United States","O157:H7",55,"2024/05/21","milk",false,s2-meta9,s2-meta10,s2-meta11,s2-meta12,s2-meta13,s2-meta14,s2-meta15,s2-meta16,s2-meta16,s2-meta17,s2-meta18,s2-meta19,s2-meta20,s2-meta21,s2-meta22,s2-meta23,s2-meta24,s2-meta25,s2-meta26,s2-meta27,s2-meta28,s2-meta29,s2-meta30,s2-meta31,s2-meta32,s2-meta33,s2-meta34,s2-meta35,s2-meta36,s2-meta37,s2-meta38,s2-meta39,s2-meta40,s2-meta41,s2-meta42,s2-meta43,s2-meta44,s2-meta45,s2-meta46,s2-meta47,s2-meta48,s2-meta49,s2-meta50
S3,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S3.mlst.json,2,"Escherichia coli","EPEC","France","O125",14,"2024/04/30","cheese",true,s3-meta9,s3-meta10,s3-meta11,s3-meta12,s3-meta13,s3-meta14,s3-meta15,s3-meta16,s3-meta16,s3-meta17,s3-meta18,s3-meta19,s3-meta20,s3-meta21,s3-meta22,s3-meta23,s3-meta24,s3-meta25,s3-meta26,s3-meta27,s3-meta28,s3-meta29,s3-meta30,s3-meta31,s3-meta32,s3-meta33,s3-meta34,s3-meta35,s3-meta36,s3-meta37,s3-meta38,s3-meta39,s3-meta40,s3-meta41,s3-meta42,s3-meta43,s3-meta44,s3-meta45,s3-meta46,s3-meta47,s3-meta48,s3-meta49,s3-meta50
S4,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S4.mlst.json,2,"Escherichia coli","EPEC","France","O125",35,"2024/04/22","cheese",true,s4-meta9,s4-meta10,s4-meta11,s4-meta12,s4-meta13,s4-meta14,s4-meta15,s4-meta16,s4-meta16,s4-meta17,s4-meta18,s4-meta19,s4-meta20,s4-meta21,s4-meta22,s4-meta23,s4-meta24,s4-meta25,s4-meta26,s4-meta27,s4-meta28,s4-meta29,s4-meta30,s4-meta31,s4-meta32,s4-meta33,s4-meta34,s4-meta35,s4-meta36,s4-meta37,s4-meta38,s4-meta39,s4-meta40,s4-meta41,s4-meta42,s4-meta43,s4-meta44,s4-meta45,s4-meta46,s4-meta47,s4-meta48,s4-meta49,s4-meta50
S5,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S5.mlst.json,3,"Escherichia coli","EAEC","Canada","O126:H27",61,"2012/09/01","milk",false,s5-meta9,s5-meta10,s5-meta11,s5-meta12,s5-meta13,s5-meta14,s5-meta15,s5-meta16,s5-meta16,s5-meta17,s5-meta18,s5-meta19,s5-meta20,s5-meta21,s5-meta22,s5-meta23,s5-meta24,s5-meta25,s5-meta26,s5-meta27,s5-meta28,s5-meta29,s5-meta30,s5-meta31,s5-meta32,s5-meta33,s5-meta34,s5-meta35,s5-meta36,s5-meta37,s5-meta38,s5-meta39,s5-meta40,s5-meta41,s5-meta42,s5-meta43,s5-meta44,s5-meta45,s5-meta46,s5-meta47,s5-meta48,s5-meta49,s5-meta50
S6,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S6.mlst.json,unassociated,"Escherichia coli","EAEC","Canada","O111:H21",43,"2011/12/25","fruit",false,s6-meta9,s6-meta10,s6-meta11,s6-meta12,s6-meta13,s6-meta14,s6-meta15,s6-meta16,s6-meta16,s6-meta17,s6-meta18,s6-meta19,s6-meta20,s6-meta21,s6-meta22,s6-meta23,s6-meta24,s6-meta25,s6-meta26,s6-meta27,s6-meta28,s6-meta29,s6-meta30,s6-meta31,s6-meta32,s6-meta33,s6-meta34,s6-meta35,s6-meta36,s6-meta37,s6-meta38,s6-meta39,s6-meta40,s6-meta41,s6-meta42,s6-meta43,s6-meta44,s6-meta45,s6-meta46,s6-meta47,s6-meta48,s6-meta49,s6-meta50
```

| Column                    | Description                                                                                                                                                                     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sample`                  | Custom sample name. Samples should be unique within a samplesheet and contain no spaces.                                                                                        |
| `mlst_alleles`            | A URI path to a JSON-formatted genomic profile. An example of this file is provided in [tests/data/profiles/S1.mlst.json](../tests/data/profiles/S1.mlst.json).                 |
| `metadata_partition`      | The specific metadata column used to partition the genomic profiles. For example, this column might refer to the outbreak number and the contain such entries as "1", "2", etc. |
| `metadata_1..metadata_50` | Metadata that will be associated with each genomic profile. These metadata will be summarized in the Arborator outputs.                                                         |

An [example samplesheet](../assets/samplesheet.csv) has been provided with the pipeline.

### IRIDA-Next Optional Samplesheet Configuration

`arboratornf` accepts the [IRIDA-Next](https://github.com/phac-nml/irida-next) format for samplesheets which contain the following columns: `sample`, `sample_name`, `mlst_alleles`, `metadata_partition`, and `metadata_1` through `metadata_50`. The IDs (sample column) within a samplesheet should be unique and contain no spaces. Any other additionally specified trailing columns will be ignored.

```console
sample,mlst_alleles,metadata_partition,metadata_1,metadata_2,metadata_3,metadata_4,metadata_5,metadata_6,metadata_7,metadata_8,metadata_9,metadata_10,metadata_11,metadata_12,metadata_13,metadata_14,metadata_15,metadata_16,metadata_16,metadata_17,metadata_18,metadata_19,metadata_20,metadata_21,metadata_22,metadata_23,metadata_24,metadata_25,metadata_26,metadata_27,metadata_28,metadata_29,metadata_30,metadata_31,metadata_32,metadata_33,metadata_34,metadata_35,metadata_36,metadata_37,metadata_38,metadata_39,metadata_40,metadata_41,metadata_42,metadata_43,metadata_44,metadata_45,metadata_46,metadata_47,metadata_48,metadata_49,metadata_50
S1,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S1.mlst.json,1,"Escherichia coli","EHEC/STEC","Canada","O157:H7",21,"2024/05/30","beef",true,s1-meta9,s1-meta10,s1-meta11,s1-meta12,s1-meta13,s1-meta14,s1-meta15,s1-meta16,s1-meta16,s1-meta17,s1-meta18,s1-meta19,s1-meta20,s1-meta21,s1-meta22,s1-meta23,s1-meta24,s1-meta25,s1-meta26,s1-meta27,s1-meta28,s1-meta29,s1-meta30,s1-meta31,s1-meta32,s1-meta33,s1-meta34,s1-meta35,s1-meta36,s1-meta37,s1-meta38,s1-meta39,s1-meta40,s1-meta41,s1-meta42,s1-meta43,s1-meta44,s1-meta45,s1-meta46,s1-meta47,s1-meta48,s1-meta49,s1-meta50
S2,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S2.mlst.json,1,"Escherichia coli","EHEC/STEC","The United States","O157:H7",55,"2024/05/21","milk",false,s2-meta9,s2-meta10,s2-meta11,s2-meta12,s2-meta13,s2-meta14,s2-meta15,s2-meta16,s2-meta16,s2-meta17,s2-meta18,s2-meta19,s2-meta20,s2-meta21,s2-meta22,s2-meta23,s2-meta24,s2-meta25,s2-meta26,s2-meta27,s2-meta28,s2-meta29,s2-meta30,s2-meta31,s2-meta32,s2-meta33,s2-meta34,s2-meta35,s2-meta36,s2-meta37,s2-meta38,s2-meta39,s2-meta40,s2-meta41,s2-meta42,s2-meta43,s2-meta44,s2-meta45,s2-meta46,s2-meta47,s2-meta48,s2-meta49,s2-meta50
S3,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S3.mlst.json,2,"Escherichia coli","EPEC","France","O125",14,"2024/04/30","cheese",true,s3-meta9,s3-meta10,s3-meta11,s3-meta12,s3-meta13,s3-meta14,s3-meta15,s3-meta16,s3-meta16,s3-meta17,s3-meta18,s3-meta19,s3-meta20,s3-meta21,s3-meta22,s3-meta23,s3-meta24,s3-meta25,s3-meta26,s3-meta27,s3-meta28,s3-meta29,s3-meta30,s3-meta31,s3-meta32,s3-meta33,s3-meta34,s3-meta35,s3-meta36,s3-meta37,s3-meta38,s3-meta39,s3-meta40,s3-meta41,s3-meta42,s3-meta43,s3-meta44,s3-meta45,s3-meta46,s3-meta47,s3-meta48,s3-meta49,s3-meta50
S4,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S4.mlst.json,2,"Escherichia coli","EPEC","France","O125",35,"2024/04/22","cheese",true,s4-meta9,s4-meta10,s4-meta11,s4-meta12,s4-meta13,s4-meta14,s4-meta15,s4-meta16,s4-meta16,s4-meta17,s4-meta18,s4-meta19,s4-meta20,s4-meta21,s4-meta22,s4-meta23,s4-meta24,s4-meta25,s4-meta26,s4-meta27,s4-meta28,s4-meta29,s4-meta30,s4-meta31,s4-meta32,s4-meta33,s4-meta34,s4-meta35,s4-meta36,s4-meta37,s4-meta38,s4-meta39,s4-meta40,s4-meta41,s4-meta42,s4-meta43,s4-meta44,s4-meta45,s4-meta46,s4-meta47,s4-meta48,s4-meta49,s4-meta50
S5,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S5.mlst.json,3,"Escherichia coli","EAEC","Canada","O126:H27",61,"2012/09/01","milk",false,s5-meta9,s5-meta10,s5-meta11,s5-meta12,s5-meta13,s5-meta14,s5-meta15,s5-meta16,s5-meta16,s5-meta17,s5-meta18,s5-meta19,s5-meta20,s5-meta21,s5-meta22,s5-meta23,s5-meta24,s5-meta25,s5-meta26,s5-meta27,s5-meta28,s5-meta29,s5-meta30,s5-meta31,s5-meta32,s5-meta33,s5-meta34,s5-meta35,s5-meta36,s5-meta37,s5-meta38,s5-meta39,s5-meta40,s5-meta41,s5-meta42,s5-meta43,s5-meta44,s5-meta45,s5-meta46,s5-meta47,s5-meta48,s5-meta49,s5-meta50
S6,https://raw.githubusercontent.com/phac-nml/arboratornf/dev/tests/data/profiles/S6.mlst.json,unassociated,"Escherichia coli","EAEC","Canada","O111:H21",43,"2011/12/25","fruit",false,s6-meta9,s6-meta10,s6-meta11,s6-meta12,s6-meta13,s6-meta14,s6-meta15,s6-meta16,s6-meta16,s6-meta17,s6-meta18,s6-meta19,s6-meta20,s6-meta21,s6-meta22,s6-meta23,s6-meta24,s6-meta25,s6-meta26,s6-meta27,s6-meta28,s6-meta29,s6-meta30,s6-meta31,s6-meta32,s6-meta33,s6-meta34,s6-meta35,s6-meta36,s6-meta37,s6-meta38,s6-meta39,s6-meta40,s6-meta41,s6-meta42,s6-meta43,s6-meta44,s6-meta45,s6-meta46,s6-meta47,s6-meta48,s6-meta49,s6-meta50
```

| Column                    | Description                                                                                                                                                                     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sample`                  | Custom sample name. Samples should be unique within a samplesheet.                                                                                                              |
| `sample_name`             | Sample name used in outputs (filenames and sample names)                                                                                                                        |
| `mlst_alleles`            | A URI path to a JSON-formatted genomic profile. An example of this file is provided in [tests/data/profiles/S1.mlst.json](../tests/data/profiles/S1.mlst.json).                 |
| `metadata_partition`      | The specific metadata column used to partition the genomic profiles. For example, this column might refer to the outbreak number and the contain such entries as "1", "2", etc. |
| `metadata_1..metadata_50` | Metadata that will be associated with each genomic profile. These metadata will be summarized in the Arborator outputs.                                                         |

An [example samplesheet](../tests/data/samplesheets/samplesheet-samplename.csv) has been provided with the pipeline.

## Running the pipeline

The typical command for running the pipeline is as follows:

```bash
nextflow run phac-nml/arboratornf -profile singularity -r main -latest --input assets/samplesheet.csv -params-file assets/parameters.yaml --outdir results
```

This will launch the pipeline with the `singularity` configuration profile. See below for more information about profiles.

Note that the pipeline will create the following files in your working directory:

```bash
work                # Directory containing the nextflow working files
<OUTDIR>            # Finished results in specified location (defined with --outdir)
.nextflow_log       # Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

If you wish to repeatedly use the same parameters for multiple runs, rather than specifying each flag in the command, you can specify these in a params file.

Pipeline settings can be provided in a `yaml` or `json` file via `-params-file <file>`.

Do not use `-c <file>` to specify parameters as this will result in errors. Custom config files specified with `-c` must only be used for [tuning process resource specifications](https://nf-co.re/docs/usage/configuration#tuning-workflow-resources), other infrastructural tweaks (such as output directories), or module arguments (args).
:::

The above pipeline run specified with a params file in yaml format:

```bash
nextflow run phac-nml/arboratornf -profile singularity -r main -latest --input assets/samplesheet.csv -params-file assets/parameters.yaml --outdir results
```

with `params.yaml` containing:

```yaml
input: './samplesheet.csv'
outdir: './results/'
metadata_partition_name: "outbreak"
metadata_1_header: "organism"
metadata_2_header: "subtype"
metadata_3_header: "country"
metadata_4_header: "serovar"
metadata_5_header: "age"
metadata_6_header: "date"
metadata_7_header: "source"
metadata_8_header: "special"
metadata_9_header: "metadata_9"
metadata_10_header: "metadata_10"
metadata_11_header: "metadata_11"
metadata_12_header: "metadata_12"
metadata_13_header: "metadata_13"
metadata_14_header: "metadata_14"
metadata_15_header: "metadata_15"
metadata_16_header: "metadata_16"
...
metadata_: metadata_50
<...>
```

You can also generate such `YAML`/`JSON` files via [nf-core/launch](https://nf-co.re/launch).

### Optional Parameters

The optional parameters are as follows:

#### Arborator

- `--ar_config`: The Arborator-specific config file for specifying the operations used when summarizing metadata and how such metadata should be displayed in the output (default: autogenerated).
- `--ar_thresholds`: The clustering thresholds used by Arborator. These thresholds must be provided as a list of integers (default: 100,50,25,20,15,10,5,0).
- `--tree_distances`: Instructs genomic address service to interpret distance matrices distances as either cophenetic (the distance at which two clusters or leaves cluster together) or patristic (the sum of branch lengths between clusters or leaves) (default: cophenetic).
- `--sort_matrix`: Whether or not to sort the samples by sample name in the distance matrix generated by the Genomic Address Service software. The order of samples has an effect on the assigned cluster labels and rarely the clustering itself. In particular, the arbitrary label assigned to each cluster is determined by the order of the samples. However, tie-breaking in the hierarchical clustering procedure is resolved by sample order, and this can create differences in the actual cluster and not just the labels assigned to those clusters. Sorting samples ensures that the same inputs always generate the same outputs, even when they're re-arranged (default: true).

#### Locidex

- `--batch_size n`: Modifies the size of LOCIDEX_MERGE batch sizes. When large samplesheets are provided to Locidex, they are split-up, into batches (default batch size: 100), to allow for `LOCIDEX_MERGE` to be run in parallel (default: 100).

#### Zip

- `--zip_cluster_results`: Zips files from `aborview`,`arborator` and `software_versions.yml` into `arboratornf.zip` (default: false)

### Reproducibility

It is a good idea to specify a pipeline version when running the pipeline on your data. This ensures that a specific version of the pipeline code and software are used when you run your pipeline. If you keep using the same tag, you'll be running the same version of the pipeline, even if there have been changes to the code since.

First, go to the [phac-nml/arboratornf page](https://github.com/phac-nml/arboratornf) and find the latest pipeline version - numeric only (eg. `1.3.1`). Then specify this when running the pipeline with `-r` (one hyphen) - eg. `-r 1.3.1`. Of course, you can switch to another version by changing the number after the `-r` flag.

This version number will be logged in reports when you run the pipeline, so that you'll know what you used when you look back in the future.

To further assist in reproducbility, you can use share and re-use [parameter files](#running-the-pipeline) to repeat pipeline runs with the same settings without having to write out a command with every single parameter.

If you wish to share such profile (such as upload as supplementary material for academic publications), make sure to NOT include cluster specific paths to files, nor institutional specific profiles.

## Core Nextflow arguments

These options are part of Nextflow and use a _single_ hyphen (pipeline parameters use a double-hyphen).

### `-profile`

Use this parameter to choose a configuration profile. Profiles can give configuration presets for different compute environments.

Several generic profiles are bundled with the pipeline which instruct the pipeline to use software packaged using different methods (Docker, Singularity, Podman, Shifter, Charliecloud, Apptainer, Conda) - see below.

We highly recommend the use of Docker or Singularity containers for full pipeline reproducibility, however when this is not possible, Conda is also supported.

The pipeline also dynamically loads configurations from [https://github.com/nf-core/configs](https://github.com/nf-core/configs) when it runs, making multiple config profiles for various institutional clusters available at run time. For more information and to see if your system is available in these configs please see the [nf-core/configs documentation](https://github.com/nf-core/configs#documentation).

Note that multiple profiles can be loaded, for example: `-profile test,docker` - the order of arguments is important!
They are loaded in sequence, so later profiles can overwrite earlier profiles.

If `-profile` is not specified, the pipeline will run locally and expect all software to be installed and available on the `PATH`. This is _not_ recommended, since it can lead to different results on different machines dependent on the computer enviroment.

- `test`
  - A profile with a complete configuration for automated testing
  - Includes links to test data so needs no other parameters
- `docker`
  - A generic configuration profile to be used with [Docker](https://docker.com/)
- `singularity`
  - A generic configuration profile to be used with [Singularity](https://sylabs.io/docs/)
- `podman`
  - A generic configuration profile to be used with [Podman](https://podman.io/)
- `shifter`
  - A generic configuration profile to be used with [Shifter](https://nersc.gitlab.io/development/shifter/how-to-use/)
- `charliecloud`
  - A generic configuration profile to be used with [Charliecloud](https://hpc.github.io/charliecloud/)
- `apptainer`
  - A generic configuration profile to be used with [Apptainer](https://apptainer.org/)
- `conda`
  - A generic configuration profile to be used with [Conda](https://conda.io/docs/). Please only use Conda as a last resort i.e. when it's not possible to run the pipeline with Docker, Singularity, Podman, Shifter, Charliecloud, or Apptainer.

### `-resume`

Specify this when restarting a pipeline. Nextflow will use cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously. For input to be considered the same, not only the names must be identical but the files' contents as well. For more info about this parameter, see [this blog post](https://www.nextflow.io/blog/2019/demystifying-nextflow-resume.html).

You can also supply a run name to resume a specific run: `-resume [run-name]`. Use the `nextflow log` command to show previous run names.

### `-c`

Specify the path to a specific config file (this is a core Nextflow command). See the [nf-core website documentation](https://nf-co.re/usage/configuration) for more information.

## Custom configuration

### Resource requests

Whilst the default requirements set within the pipeline will hopefully work for most people and with most input data, you may find that you want to customise the compute resources that the pipeline requests. Each step in the pipeline has a default set of requirements for number of CPUs, memory and time. For most of the steps in the pipeline, if the job exits with any of the error codes specified [here](https://github.com/nf-core/rnaseq/blob/4c27ef5610c87db00c3c5a3eed10b1d161abf575/conf/base.config#L18) it will automatically be resubmitted with higher requests (2 x original, then 3 x original). If it still fails after the third attempt then the pipeline execution is stopped.

To change the resource requests, please see the [max resources](https://nf-co.re/docs/usage/configuration#max-resources) and [tuning workflow resources](https://nf-co.re/docs/usage/configuration#tuning-workflow-resources) section of the nf-core website.

### Custom Containers

In some cases you may wish to change which container or conda environment a step of the pipeline uses for a particular tool. By default nf-core pipelines use containers and software from the [biocontainers](https://biocontainers.pro/) or [bioconda](https://bioconda.github.io/) projects. However in some cases the pipeline specified version maybe out of date.

To use a different container from the default container or conda environment specified in a pipeline, please see the [updating tool versions](https://nf-co.re/docs/usage/configuration#updating-tool-versions) section of the nf-core website.

### Custom Tool Arguments

A pipeline might not always support every possible argument or option of a particular tool used in pipeline. Fortunately, nf-core pipelines provide some freedom to users to insert additional parameters that the pipeline does not include by default.

To learn how to provide additional arguments to a particular tool of the pipeline, please see the [customising tool arguments](https://nf-co.re/docs/usage/configuration#customising-tool-arguments) section of the nf-core website.

### nf-core/configs

In most cases, you will only need to create a custom config as a one-off but if you and others within your organisation are likely to be running nf-core pipelines regularly and need to use the same settings regularly it may be a good idea to request that your custom config file is uploaded to the `nf-core/configs` git repository. Before you do this please can you test that the config file works with your pipeline of choice using the `-c` parameter. You can then create a pull request to the `nf-core/configs` repository with the addition of your config file, associated documentation file (see examples in [`nf-core/configs/docs`](https://github.com/nf-core/configs/tree/master/docs)), and amending [`nfcore_custom.config`](https://github.com/nf-core/configs/blob/master/nfcore_custom.config) to include your custom profile.

See the main [Nextflow documentation](https://www.nextflow.io/docs/latest/config.html) for more information about creating your own configuration files.

## Azure Resource Requests

To be used with the `azurebatch` profile by specifying the `-profile azurebatch`.
We recommend providing a compute `params.vm_type` of `Standard_D16_v3` VMs by default but these options can be changed if required.

Note that the choice of VM size depends on your quota and the overall workload during the analysis.
For a thorough list, please refer the [Azure Sizes for virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes).

## Running in the background

Nextflow handles job submissions and supervises the running jobs. The Nextflow process must run until the pipeline is finished.

The Nextflow `-bg` flag launches Nextflow in the background, detached from your terminal so that the workflow does not stop if you log out of your session. The logs are saved to a file.

Alternatively, you can use `screen` / `tmux` or similar tool to create a detached session which you can log back into at a later time.
Some HPC setups also allow you to run nextflow within a cluster job submitted your job scheduler (from where it submits more jobs).

## Nextflow memory requirements

In some cases, the Nextflow Java virtual machines can start to request a large amount of memory.
We recommend adding the following line to your environment to limit this (typically in `~/.bashrc` or `~./bash_profile`):

```bash
NXF_OPTS='-Xms1g -Xmx4g'
```
