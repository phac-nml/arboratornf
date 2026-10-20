#!/usr/bin/env python3
import argparse
import pathlib as p

import polars as pl

import numpy as np

from beave import transform_data as td
from beave import cluster as cl
from beave import declarations as dl



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("mlst", type=p.Path, help="Mlst file merged from arborator.")
    parser.add_argument("outbreak", type=str, help="Outbreak file name.")
    parser.add_argument("--output", "-o", type=str, help="Output file.")
    args = parser.parse_args()


    category = pl.Categories(physical=pl.UInt32, name="loci")
    lazy_alleles = pl.read_csv(
        args.mlst,
        separator="\t",
        infer_schema=False,
        raise_if_empty=True,
        has_header=True,
    )
    # TODO: Need to verify if checks need to be included here
    # TODO: Filtering may be done earlier in the pipeline need to check
    profiles = lazy_alleles.with_columns(
        pl.all()
        .exclude(lazy_alleles.columns[0])
        .replace(old=list(td.REPLACE_CHARS.keys()), new=None)
    )
    profiles = profiles.filter(~pl.all_horizontal(pl.all().is_null()))
    profiles = profiles.with_columns(
        pl.all().exclude(profiles.columns[0]).cast(pl.Categorical(category))
    )

    cluster_args = dl.ClusterArguments(
        delimiter="\t",
        normalize_distance=False,
        count_missing=False,
        columns_path=None,
        filter_threshold=0.95,  # TODO: find out
        cores=4,
        output_directory=p.Path("blah"),  # will not be made
        input_file=args.mlst,
        thresholds=[1.0],
        branch_type=dl.BranchType.PATRISTIC,
        linkage_method=dl.LinkageMetric.SINGLE,
        matrix=False,
    )

    dist_values = []
    distances, profile_names = cl.compute_dists(profiles, cluster_args=cluster_args)
    if distances.size == 0:
        dist_values.append((args.outbreak, np.nan, np.nan, np.nan, np.nan))
    else:
        mean = np.mean(distances)
        median = np.median(distances)
        min = distances.min()
        max = distances.max()
        dist_values.append((args.outbreak, min, median, mean, max))

    dist_df = pl.DataFrame(
        [
            {
                "national_outbreak_code": v[0],
                "min_dist": v[1],
                "median_dist": v[2],
                "mean_dist": v[3],
                "max_dist": v[4],
            }
            for v in dist_values
        ]
    )

    dist_df.write_csv(args.output, separator="\t")
