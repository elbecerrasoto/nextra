#!/usr/bin/env Rscript

# Bacillus subtillis JH462

# ywqJ Deaminase toxin gene
# locus-tag BSUA_RS19530

# ywqL Endo V gene
# BSUA_RS19520

# ./download_genome.py -i gff3 protein genome 'seq-report' cds -p GCF_000699465.1_bsubJH642 GCF_000699465.1

library(tidyverse)
library(stringr)
library(segmenTools)
# devtools::install_github("raim/segmenTools")

N <- 2^3
GFF <- "GCF_000699465.1/GCF_000699465.1_bsubJH642.gff"

# CDS <- microseq::readGFF(GFF) |> filter(Type == "CDS") |> arrange(Start)

Rgff::check_gff(GFF)
Rgff::gff_stats(GFF)
Rgff::get_features(GFF)

# https://stackoverflow.com/questions/49374887/piping-the-removal-of-empty-columns-using-dplyr # remove NA columns
CDS <- segmenTools::gff2tab(GFF) |>
  tibble() |>
  filter(feature == "CDS") |>
  select_if(function(x) !(all(is.na(x)) | all(x == ""))) |>
  relocate(gene, locus_tag, start, end, feature) |>
  arrange(start)

print(head(CDS))
