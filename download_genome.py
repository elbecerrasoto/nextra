#!/usr/bin/env python3

# Depends on ncbi-datasets-cli
# Install with
# mamba install -y -c conda-forge ncbi-datasets-cli

import os
import shutil 
import argparse
import subprocess as sp
import re
from pathlib import Path
from icecream import ic
from shlex import split, join

DESCRIPTION = """Wrapper for ncbi-datasets-cli

    under the hood:
        datasets download genome accession --help

    install:
        mamba install -y -c conda-forge ncbi-datasets-cli

    formats:
         genome:     genomic sequence
         rna:        transcript
         protein:    amnio acid sequences
         cds:        nucleotide coding sequences
         gff3:       general feature file
         gtf:        gene transfer format
         gbff:       GenBank flat file
         seq-report: sequence report file
         none:       do not retrieve any sequence files
         default [genome]
"""

# An Example: 

# ├── temp_GCF_024145975.1
# │   ├── GCF_024145975.1.zip
# │   ├── ncbi_dataset
# │   │   └── data
# │   │       ├── assembly_data_report.jsonl
# │   │       ├── dataset_catalog.json
# │   │       └── GCF_024145975.1
# │   │           ├── cds_from_genomic.fna
# │   │           ├── GCF_024145975.1_ASM2414597v1_genomic.fna
# │   │           ├── genomic.gbff
# │   │           ├── genomic.gff
# │   │           ├── genomic.gtf
# │   │           ├── protein.faa
# │   │           └── sequence_report.jsonl
# │   └── README.md


INCLUDE_DEF = "genome,protein,gff3" 
CWD = Path(os.getcwd())

parser = argparse.ArgumentParser(
    description=DESCRIPTION, formatter_class=argparse.RawDescriptionHelpFormatter
)
parser.add_argument("genome", help="NCBI accession")
parser.add_argument("-o", "--out-dir", help="Default: new dir with accession number")
parser.add_argument("-n", "--dry-run", action="store_true")
parser.add_argument("-d", "--debug", action="store_true")
parser.add_argument("-i", "--include", help=f"Which formats to download, Default: {INCLUDE_DEF}")
args = parser.parse_args()


GENOME = args.genome

RENAMES = {"genome": (re.compile(GENOME + r"_.*_genomic\.fna$"), lambda x: re.sub(GENOME + r"_.*_genomic\.fna$", f"{GENOME}.fna", x))}#, "rna": (regex, func), "protein": (regex, func), "cds": (), "gff3": (), "gtf": (), "gbff": (), "seq-report": ()}

# │   │           ├── cds_from_genomic.fna
# │   │           ├── GCF_024145975.1_ASM2414597v1_genomic.fna
# │   │           ├── genomic.gbff
# │   │           ├── genomic.gff
# │   │           ├── genomic.gtf
# │   │           ├── protein.faa
# │   │           └── sequence_report.jsonl



OUT_DIR = CWD / GENOME if args.out_dir is None else Path(args.out_dir)
INCLUDE = INCLUDE_DEF if args.include is None else Path(args.include)

DRY = args.dry_run
DEBUG = args.debug

if DEBUG:
    ic(args)

if __name__ == "__main__":
    TMP_DIR = CWD / f"temp_{GENOME}"
    ZIP = TMP_DIR / (GENOME + ".zip")

    DATASETS = split(
        f"datasets download genome accession {GENOME} --filename {ZIP} --include {INCLUDE}"
    )
    UNZIP = split(f"unzip -nq {ZIP} -d {TMP_DIR}")

    if DEBUG:
        ic(GENOME, OUT_DIR, INCLUDE, CWD, TMP_DIR, ZIP, DATASETS, UNZIP)

    if not DRY:
        TMP_DIR.mkdir(parents=True, exist_ok=True)
        OUT_DIR.mkdir(parents=True, exist_ok=True)

        sp.run(DATASETS, check=True)

        sp.run(UNZIP, check=True)

        NESTED = TMP_DIR / "ncbi_dataset" / "data" / GENOME
        # rename downloaded data
        for genome_data in NESTED.iterdir():
            for rename in RENAMES:
                genome_data = str(genome_data)
              
                test = RENAMES[rename][0] 
                sub = RENAMES[rename][1]
                
                if re.search(test, genome_data):
                    shutil.move(genome_data ,sub(genome_data))
                    break

        # move downloaded data
        for genome_data in NESTED.iterdir():
            shutil.move(genome_data, OUT_DIR)        
        
        shutil.rmtree(TMP_DIR)

    else:
        print("DRY RUN\nActions that would've run:\n")
        print(f"mkdir -p {OUT_DIR}")
        print(join(DATASETS))
        print(join(UNZIP))
        print(f"rm -r {TMP_DIR}")
