#!/usr/bin/env Rscript

# Bacillus subtillis JH462

# ywqJ Deaminase toxin gene
# locus-tag BSUA_RS19530

# ywqL Endo V gene
# BSUA_RS19520

# ./download_genome.py -i gff3 protein genome 'seq-report' cds -p GCF_000699465.1_bsubJH642 GCF_000699465.1

library(tidyverse)
library(stringr)

GFF <- "GCF_000699465.1/GCF_000699465.1_bsubJH642.gff"

CDS <- microseq::readGFF(GFF) |> filter(Type == "CDS")

Rgff::gff_stats(GFF)
Rgff::get_features(GFF)


CDS_ATTS_HEADERS <- c(
  "ID",
  "Parent",
  "Dbxref",
  "Name",
  "Ontology_term",
  "gbkey",
  "gene",
  "go_component",
  "go_function",
  "go_process",
  "inference",
  "locus_tag",
  "procuct",
  "protein_id",
  "transl_table"
)


# attributes targets
# str_detect("hello", "llo")
