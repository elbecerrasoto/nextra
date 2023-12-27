#!/usr/bin/env Rscript

# Bacillus subtillis JH462

# ywqJ Deaminase toxin gene
# locus-tag BSUA_RS19530

# ywqL Endo V gene
# BSUA_RS19520

# ./download_genome.py -i gff3 protein genome 'seq-report' cds -p GCF_000699465.1_bsubJH642 GCF_000699465.1

library(tidyverse)
library(stringr)

CDS <- microseq::readGFF("GCF_000699465.1/GCF_000699465.1_bsubJH642.gff") |>  filter(Type=="CDS")

  
# attributes targets
# str_detect("hello", "llo")
