[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A523.04.3-brightgreen.svg)](https://www.nextflow.io/)

# arboratornf (Arborator)

This [Nextflow](https://www.nextflow.io/) pipeline implements [Arborator](https://github.com/phac-nml/arborator). Arborator takes as input JSON-formatted genomic profiles and corresponding metadata, groups genomic profiles according to specified metadata criteria, and then summarizes each group and its corresponding metadata.

# Input

The input to the pipeline is a standard sample sheet (passed as `--input samplesheet.csv`) that looks like:

| sample  | mlst_alleles      | metadata_partition | metadata_1 | metadata_2 | metadata_3 | metadata_4 | metadata_5 | metadata_6 | metadata_7 | metadata_8 |
| ------- | ----------------- | ------------------ | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| SampleA | sampleA.mlst.json | partition_meta     | meta_1     | meta_2     | meta_3     | meta_4     | meta_5     | meta_6     | meta_7     | meta_8     |

The columns of the samplesheet are defined as follows:

- sample: The sample ID name. This name should not contain spaces.
- mlst_alleles: A URI path to a JSON-formatted genomic profile. An example of this file is provided in [tests/data/profiles/S1.mlst.json](tests/data/profiles/S1.mlst.json).
- metadata_partition: The specific metadata column used to partition the genomic profiles. For example, this column might refer to the outbreak number and the contain such entries as "1", "2", etc. If an individual sample row in the sample sheet is missing the `metadata_partition` entry, that sample will not be included in the analysis and will instead be reported in the `arborator/metadata.excluded.tsv` output file.
- metadata_1..metadata_8: Metadata that will be associated with each genomic profile. These metadata will be summarized in the Arborator outputs.

The names of each metadata column (metadata_partition, and metadata_1..metadata_8) are provided using the following parameters:

- `--metadata_partition_name`: The name of the metadata_partition column (for example: "outbreak").
- `--metadata_1_header..metadata_8_header`: The name of each individual metadata column (for example: "organism" or "source").

Entries in the `metadata_partition` column in the sample sheet, as well as the name provided by the `metadata_partition_name` parameter, must contain only the following characters alphanumeric, `_`, `.`, and `-` characters.

Entries in the metadata columns in the sample sheet (`metadata_1` through `metadata_8`), as well as the name provided by the metadata header parameters (`metadata_1_header` through `metadata_8_header`), may not contain newlines, tabs, `"`, `'`, `\`, `|`, `;`, `>`, or `<` characters.

An example of the sample sheet is available in [tests/data/samplesheets/samplesheet.csv](tests/data/samplesheets/samplesheet.csv) and corresponding example metadata headers are available in [assets/parameters.yaml](assets/parameters.yaml).

Furthermore, the structure of the sample sheet is programmatically defined in [assets/schema_input.json](assets/schema_input.json). Validation of the sample sheet is performed by [nf-validation](https://nextflow-io.github.io/nf-validation/).

# Parameters

The mandatory parameters are `--input`, which specifies the samplesheet as described above, and `--output`, which specifies the output results directory. You may wish to provide `-profile singularity` to specify the use of singularity containers and `-r [branch]` to specify which GitHub branch you would like to run. Metadata-related parameters are described above in [Input](#input).

## Optional

The optional parameters are as follows:

### Arborator

* `--ar_config`: The Arborator-specific config file for specifying the operations used when summarizing metadata and how such metadata should be displayed in the output.
* `--ar_thresholds`: The clustering thresholds used by Arborator. These thresholds must be provided as a list of integers.

Further parameters (defaults from nf-core) are defined in [nextflow_schema.json](nextflow_schema.json).

# Running

To execute the pipeline, please run:

```bash
nextflow run phac-nml/arboratornf -profile singularity -r main -latest --input assets/samplesheet.csv -params-file assets/parameters.yaml --outdir results
```

Where the `samplesheet.csv` is structured as specified in the [Input](#input) section and `parameters.yaml` provides parameters for renaming metadata column headers, which may either be specified individually on the command line or collectively in a parameters file.

Additional details on usage of the pipeline are found in [docs/usage.md](docs/usage.md).

# Output

A JSON-formatted file for loading metadata into IRIDA Next is output by this pipeline. The format of this JSON-formatted file is specified in our [Pipeline Standards for the IRIDA Next JSON](https://github.com/phac-nml/pipeline-standards#32-irida-next-json). This JSON-formatted file is written directly within the `--outdir` provided to the pipeline with the name `iridanext.output.json.gz` (ex: `[outdir]/iridanext.output.json.gz`).

An example of the what the contents of the IRIDA Next JSON-formatted file looks like for this particular pipeline is as follows:

```
{
    "files": {
        "global": [
            {
                "path": "arborator/metadata.included.tsv"
            },
            {
                "path": "arborator/metadata.excluded.tsv"
            },
            {
                "path": "arborator/cluster_summary.tsv"
            }
        ],
        "samples": {

        }
    },
    "metadata": {
        "samples": {

        }
    }
}
```

Within the `files` section of this JSON-formatted file, all of the output paths are relative to the `outdir`. Therefore, `"path": "arborator/cluster_summary.tsv"` refers to a file located within `outdir/arborator/cluster_summary.tsv`.

The `arborator/metadata.included.tsv` and `arborator/metadata.excluded.tsv` output files summarize which samples were analyzed and which were not. Samples that contain missing data for the `metadata_partition` column will not be included in analysis and will be reported in the `arborator/metadata.excluded.tsv` output file.

Additional details on output files are found in [docs/output.md](docs/output.md)

## Test profile

To run with the test profile, please do:

```bash
nextflow run phac-nml/arboratornf -profile docker,test -r main -latest --outdir results
```

# Legal

Copyright 2024 Government of Canada

Licensed under the MIT License (the "License"); you may not use
this work except in compliance with the License. You may obtain a copy of the
License at:

https://opensource.org/license/mit/

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
