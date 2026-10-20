---
aliases:
   - Arborator PNC replacement requirements
project:
   - Arborator tool replacement
date: 2026-10-05
---

# Arborator Replacement — Requirements Specification

## 1. Purpose & Scope

This document defines the functional requirements for the replacement of the Arborator EPS tool. Requirements are derived from prioritization of the original tool's
capabilities.

- **1** — critical for first release
- **2** — valuable but can be released later

Each requirement has a stable ID for traceability to the data flow diagram and design-decision records (ADRs).

## 2. Functional Requirements

### 2.1 Input

| ID    | Requirement                                                    | Priority | Notes                      |
| ----- | -------------------------------------------------------------- | -------- | -------------------------- |
| FR-01 | Load input from comma-separated (CSV) sample sheet             | 1        | See arboratornf for format |
| FR-02 | Accept JSON input in addition to CSV sample sheet              | 2        |                            |
| FR-03 | Accept JSON configuration parameters to override CLI arguments | 1        | See Open questions section |

### 2.2 Validation & Preparation

| ID     | Requirement                                                                  | Priority | Notes                                                         |
| ------ | ---------------------------------------------------------------------------- | -------- | ------------------------------------------------------------- |
| FR-04  | Validate user parameters and clustering distance thresholds before running   | 1        |                                                               |
| FR-05  | Split data into one channel per group based on sample→group mapping          | 1        | Prefer Nextflow channel ops over in-Python splitting (ADR-01) |
| FR-05b | Drop groups below the minimum member count                                   | 2        | `node_filter_groups` (Phase 2)                                |
| FR-05c | Reconcile inputs — common-file check across profile/metadata before analysis | 2        | `node_reconcile`; feeds OUT-13                                |
| FR-06  | Clean input data by removing loci with excessive missing data                | 2        | Original implementation incomplete                            |


### 2.3 Quality Control

| ID    | Requirement                                                   | Priority | Notes                                   |
| ----- | ------------------------------------------------------------- | -------- | --------------------------------------- |
| FR-07 | Sample QC — remove samples exceeding a missing-data threshold | 2        |                                         |
| FR-08 | Locus QC — remove loci exceeding a missing-data threshold     | 2        |                                         |
| FR-09 | Skip-QC toggle to bypass quality-control steps                | 2        | Required if FR-07/FR-08 are implemented |

### 2.4 Distance & Clustering

| ID    | Requirement                                                                               | Priority | Notes                                                                 |
| ----- | ----------------------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------- |
| FR-10 | Compute a pairwise distance matrix for each partition                                     | 1        |                                                                       |
| FR-11 | Cluster samples at each chosen distance threshold                                         | 1        |                                                                       |
| FR-12 | Configurable missing-data handling in distance calculation (count as difference vs. skip) | 2        |                                                                       |
| FR-13 | Selectable distance method                                                                | 2        | May be dropped (orig. "2 maybe 0") as PNC typically uses Hamming only |
| FR-14 | Detect outliers (distant pairs and on-average odd samples), producing an outlier list     | 2        |                                                                       |

### 2.5 Summarization

| ID    | Requirement                                                                                                | Priority | Notes                                     |
| ----- | ---------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------------- |
| FR-15 | Summarize group statistics, adapting to each field's data type                                             | 1        | Parent capability for FR-16 through FR-19 |
| FR-16 | Categorical fields: value counts (separate columns for human, animal, food, env, unknown, and per geo_loc) | 1        |                                           |
| FR-17 | Range fields (e.g. dates): report min / max                                                                | 1        |                                           |
| FR-18 | Distance fields: report min, mean, median, max                                                             | 1        | Allele distance only                      |
| FR-19 | Unsummarized fields: keep raw values as a combined list (source type, geo_loc)                             | 1        |                                           |

### 2.6 Assembly

| ID    | Requirement                                                           | Priority | Notes               |
| ----- | --------------------------------------------------------------------- | -------- | ------------------- |
| FR-20 | Build per-sample line list combining cluster assignments and metadata | 1        | "metadata linelist" |
| FR-21 | Combine all group statistics results into the final cluster summary   | 1        |                     |

## 3. Output Requirements

### 3.1 Per-group Outputs

| ID      | Output                                                                                                                                     | Priority | Notes                                        |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------ | -------- | -------------------------------------------- |
| OUT-02  | `metadata.tsv` — sample name + all metadata fields + group name + denovo address                                                           | 1        | Do **not** concatenate address to group name |
| OUT-03  | `matrix.tsv` — within-group pairwise distance matrix                                                                                       | 1        | Make optional                                |
| OUT-04  | `tree.nwk` — Newick tree from within-group distances                                                                                       | 1        | Make optional                                |
| OUT-05  | `profile.tsv` — allele/profile slice for within-group samples                                                                              | 1        | Make optional                                |
| OUT-06  | `outliers.tsv` — samples flagged as outliers within the group (distant pairs + on-average odd samples)                                     | 2        | `node_outliers` (Phase 2)                    |
| OUT-07a | `qc_removed.samples.tsv` — samples removed by QC for this group: sample name, reason (missing-data threshold), missing fraction, threshold | 2        | `node_qc` / FR-07; missing in diagram        |
| OUT-07b | `qc_removed.loci.tsv` — loci removed by QC for this group: locus name, reason (missing-data threshold), missing fraction, threshold        | 2        | `node_qc` / FR-08; missing in diagram        |


### 3.2 Whole-dataset Outputs

| ID     | Output                                                                                                                 | Priority | Notes                           |
| ------ | ---------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------- |
| OUT-08 | `cluster_summary.tsv` — main results table with per-cluster statistics                                                 | 1        | Main group stats deliverable    |
| OUT-09 | `cluster_summary.xlsx` — Excel version of OUT-08                                                                       | 1        |                                 |
| OUT-10 | `metadata.linelist.tsv` — one row per clustered sample (metadata + cluster address)                                    | 1        | Main per-sample deliverable     |
| OUT-11 | `metadata.linelist.xlsx` — Excel version of OUT-10                                                                     | 1        |                                 |
| OUT-12 | `threshold_map.json` — thresholds used in the run                                                                      | 1        |                                 |
| OUT-13 | `run.json` — run log: parameters, thresholds, timing, missing/excluded counts                                          | 1        | Reproducibility/troubleshooting |
| OUT-14 | `groups.dropped.tsv` — groups removed before analysis: group name, member count, and reason (below `min_member_count`) | 2        | `node_filter_groups` (Phase 2)  |


## 4. Open Questions

- FR-13 (selectable distance method): confirm whether this stays in scope.
- Confirm which per-group outputs (OUT-03/04/05) default on vs. off.
- FR03 - JSON Config input format is marked TBD,  **confirm JSON schema**.
	- do we include "meta-programming"in json format.

## 5. Non-Functional & Architecture Notes

Derived from the data flow diagram (`20260929_arb-replacement-dataflow-USE`).

- **Partitioned, per-group execution**: groups are independent analysis units, enabling parallelism across partitions.
- **Provenance/auditability**: `run.json` is initialized at start  and finalized with outcome; thresholds are captured `threshold_map.json` and `run.json`.
- **Config-driven overrides**: CLI args and JSON config override defaults at  partition time and are recorded for reproducibility.
- **Phased delivery**: Phase 1 (solid edges) = core pipeline; Phase 2 (dashed)
  = QC, group filtering, and outlier detection.

## 6. Architecture Decision Records (ADRs)

Short records of significant design choices and their rationale.

### ADR-01 — Implement as a Nextflow pipeline, not a Python package

**Context.** The current Arborator does all grouping and splitting inside
Python, which forces loading the full dataset into memory/pandas and is a known
inefficiency.

**Decision.** Build the replacement as a Nextflow pipeline. Use Nextflow for
orchestration, grouping, and splitting (channel operations) rather than Python.
Keep Python to a minimum (ideally only a single container) and
minimize the number of Python packages overall.

**Consequences.**
- FR-05 (split into per-group channel) should be realized via Nextflow channels
  where possible, not a Python splitting step.
- Lower memory pressure; natural per-group parallelism.
- Logic is distributed across processes/scripts rather than one package, so
  provenance (`run.json`) and config handling must be explicit.

### ADR-02 — Pass intermediate metadata as JSON

**Context.** Multiple stages hand metadata to the next; format consistency
matters for reliability and debugging.

**Decision.** Any intermediate metadata file passed between stages uses JSON.
(Final deliverables remain TSV/XLSX as specified in Section 3.)

**Consequences.**
- Predictable, typed intermediate exchange; easier to validate; better parsing for commas and quotes.
- Avoids ad-hoc intermediate TSVs.

### ADR-03 — Use beave as a module with bespoke in-memory scripts

**Context.** Writing every intermediate to disk (e.g. profile merges) is slow
and clutters output.

**Decision.** Consume `beave` as a module and write small bespoke scripts around
it. Where practical (e.g. profile merges), keep data in memory and avoid
intermediate file writes.

**Consequences.**
- Fewer intermediate files; supports the "make optional" notes on OUT-03/04/05.
- Tighter coupling to beave's module API; version-pin beave.
