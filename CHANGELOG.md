# phac-nml/arboratornf: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.2] - 2025-07-07

### `Updated`

- Updated the template ArborView html file `assets/ArborView.html` based on the the commit [a826e1f](https://github.com/phac-nml/ArborView/commit/a826e1f142eec2a6d599a10874f74318530546a2) of the `html/table.html` file in ArborView `v.0.1.1` [release](https://github.com/phac-nml/ArborView/releases/tag/v0.1.1). [PR #48](https://github.com/phac-nml/arboratornf/pull/48)

- Updated the arborator container (build 0 -> 1) which includes an update to the dependency of `profile_dists`. [PR #48](https://github.com/phac-nml/arboratornf/pull/48)

## [0.5.1] - 2025-06-04

### `Fix`

- Updated the template ArborView html file `assets/ArborView.html` based on the the commit [046ed92](https://github.com/phac-nml/ArborView/commit/046ed92021fe37016d771c6dc69fdbe8e204a70f) to the `html/table.html` file in ArborView `v.0.1.0` that fixes rendering of plots. [PR #45](https://github.com/phac-nml/arboratornf/pull/45)

## [0.5.0] - 2025-06-03

### `Updated`

- Updated `ArborView` to version [0.1.0](https://github.com/phac-nml/ArborView/releases/tag/v0.1.0). [PR #43](https://github.com/phac-nml/arboratornf/pull/43)
  - `assets/ArborView.html` replaced with [table.html](https://github.com/phac-nml/ArborView/blob/v0.1.0/html/table.html)
  - `bin/inline_arborview.py` replaced with [fillin_data.py](https://github.com/phac-nml/ArborView/blob/v0.1.0/scripts/fillin_data.py)
  - line 32 of `ARBOR_VIEW` process outputs `0.1.0` now to `software_versions.yml`

### `Enhancement`

- `locidex merge` in `0.3.0` now performs the functionality of `input_assure` (checking sample name against MLST profiles). This allows `arboratornf` to remove `input_assure` so that the MLST JSON file is read only once, and no longer needs to re-write with correction. [PR #44](https://github.com/phac-nml/arboratornf/pull/44)
- Added a pre-processing step to the input of `LOCIDEX_MERGE` that splits-up samples, into batches (default batch size: `100`), to allow for `LOCIDEX_MERGE` to be run in parallel. To modify the size of batches use the parameter `--batch_size n`. [PR #44](https://github.com/phac-nml/arboratornf/pull/44)

## [0.4.0] - 2025-05-26

### `Updated`

- Update the `arborator` software to version [1.0.6](https://github.com/phac-nml/arborator/releases/tag/1.0.6). [PR #41](https://github.com/phac-nml/arboratornf/pull/41)
- Updated `nf-iridanext` plugin to version [0.3.0](https://github.com/phac-nml/nf-iridanext/releases/tag/0.3.0). [PR #41](https://github.com/phac-nml/arboratornf/pull/41)
- Updated `ArborView` to version [0.0.9](https://github.com/phac-nml/ArborView/releases/tag/v0.0.9). [PR #41](https://github.com/phac-nml/arboratornf/pull/41)
- Updated `locidex` to version [0.3.0](https://github.com/phac-nml/locidex/releases/tag/v0.3.0). [PR #41](https://github.com/phac-nml/arboratornf/pull/41)

### `Changed`

- Changed the arborator Nextflow module to print the versions of `gas` and `profile_dists` to make it easier to verify which versions of those software were used. [PR #41](https://github.com/phac-nml/arboratornf/pull/41)

### `Removed`

- Removed `matrix.pq` (parquet) file in IRIDA Next JSON. [PR #41](https://github.com/phac-nml/arboratornf/pull/41)

## [0.3.6] - 2025-05-05

### `Fix`

- Fixes the issue [#38](https://github.com/phac-nml/arboratornf/issues/38) `metadata_partition` containing a "." were leading to misnamed Arborview output files. [PR #38](https://github.com/phac-nml/arboratornf/pull/38)

### `Added`

- `/pipeline_info/software_versions.yml` now added to the global files in the `iridanext.output.json.gz` to allow IRIDA-Next users access to software versions. [PR #38](https://github.com/phac-nml/arboratornf/pull/38)

## [0.3.5] - 2025-04-16

### `Updated`

- Update the `ArborView` version to [0.0.8](https://github.com/phac-nml/ArborView/releases/tag/v0.0.8) (i.e. replace `bin/inline_arborview.py` with `scripts/fillin_data.py` and `assets/ArborView.html` with `html/table.html`) [PR #33](https://github.com/phac-nml/arboratornf/pull/33)
- Update the `aborator` container [build](https://github.com/bioconda/bioconda-recipes/pull/55278) which in turn updates the dependency, `profile_dists`, to version 1.0.4 [PR #36](https://github.com/phac-nml/arboratornf/pull/36)

### `Changed`

- Changed the defaults for the `arborator` parameter `--ar_thresholds` from "10,9,8,7,6,5,4,3,2,1" to "100,50,25,20,15,10,5,0" [PR #35](https://github.com/phac-nml/arboratornf/pull/35)

## [0.3.4] - 2025-03-20

### `Changed`

- Updated the build of the arborator container in order to update the `genomic_address_service` dependency to [version 0.1.5](https://github.com/phac-nml/genomic_address_service/releases/tag/0.1.5). See [PR #31](https://github.com/phac-nml/arboratornf/pull/31).
- Fixed some nf-core linting warnings and moved arborview.nf and map_to_tsv.nf modules to subfolders. See [PR #31](https://github.com/phac-nml/arboratornf/pull/31).
- Removed unneeded input_check.nf. See [PR #31](https://github.com/phac-nml/arboratornf/pull/31).

## [0.3.3] - 2025-02-11

- Updated the build of the arborator container in order to update the `genomic_address_service` dependency to [version 0.1.4](https://github.com/phac-nml/genomic_address_service/releases/tag/0.1.4).

## [0.3.2] - 2025-01-15

- Updated the build of the arborator container in order to update the `genomic_address_service` dependency to [version 0.1.3](https://github.com/phac-nml/genomic_address_service/releases/tag/0.1.3), which fixes an issue with branch lengths in Newick files [PR 27](https://github.com/phac-nml/arboratornf/pull/27).

## [0.3.1] - 2024-11-05

- Fixed the replacement of `docker.userEmulation` with `docker.runOptions      = '-u $(id -u):$(id -g)'` that was causing a bug in Azure

## [0.3.0] - 2024-10-21

- Added the ability to include a `sample_name` column in the input samplesheet.csv. Allows for compatibility with IRIDA-Next input configuration.

  - `sample_name` special characters will be replaced with `"_"`
  - If no `sample_name` is supplied in the column `sample` will be used
  - To avoid repeat values for `sample_name` all `sample_name` values will be suffixed with the unique `sample` value from the input file

  - Fixed linting issues in CI caused by nf-core 3.0.1

## [0.2.0] - 2024-09-05

### `Changed`

- Upgraded `locidex/merge` to version `0.2.3` and updated `input_assure.py` and test data for compatibility with the new `mlst.json` allele file format.
  - [PR19](https://github.com/phac-nml/arboratornf/pull/19)

This pipeline is now compatible only with output generated by [Locidex v0.2.3+](https://github.com/phac-nml/locidex) and [Mikrokondo v0.4.0+](https://github.com/phac-nml/mikrokondo/releases/tag/v0.4.0).

## [0.1.0] - 2024-08-20

Initial release of the arboratornf pipeline to be used for running [Arborator](https://github.com/phac-nml/arborator) under Nextflow.

### `Added`

- Basic functionality of Arborator.
- Added support for metadata.
- Automatically generate Arborator config files.
- ArborView integration.

[0.1.0]: https://github.com/phac-nml/arboratornf/releases/tag/0.1.0
[0.2.0]: https://github.com/phac-nml/arboratornf/releases/tag/0.2.0
[0.3.0]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.0
[0.3.1]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.1
[0.3.2]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.2
[0.3.3]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.3
[0.3.4]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.4
[0.3.5]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.5
[0.3.6]: https://github.com/phac-nml/arboratornf/releases/tag/0.3.6
[0.4.0]: https://github.com/phac-nml/arboratornf/releases/tag/0.4.0
[0.5.0]: https://github.com/phac-nml/arboratornf/releases/tag/0.5.0
[0.5.1]: https://github.com/phac-nml/arboratornf/releases/tag/0.5.1
