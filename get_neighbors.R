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


# Definition of Neighbor --------------------------------------------------


# What is the definition of a neighbor?
# Same feature type, same strand?
# Mutually Exclusive?
# The table gets filter and ordered, to define the neighbors


# https://stackoverflow.com/questions/49374887/piping-the-removal-of-empty-columns-using-dplyr # remove NA columns
CDS <- segmenTools::gff2tab(GFF) |>
  tibble() |>
  filter(feature == "CDS") |>
  select_if(function(x) !(all(is.na(x)) | all(x == ""))) |>
  relocate(gene, locus_tag, start, end, feature, seqname, strand, frame) |>
  arrange(start)


# write_tsv(CDS, "cds.tsv")
print(head(CDS))




# Search Neighbors --------------------------------------------------------

circular_index <- function(idx, size) {
  # In R indexes start on 1
  ((idx - 1) %% size) + 1
}


# Get match objects
# ywqJ Deaminase toxin gene
# locus-tag BSUA_RS19530

# ywqL Endo V gene
# BSUA_RS19520

search_by_locus_tag <- function(ilocus_tag) {
  x <- CDS |>
    mutate(row = 1:nrow(CDS)) |>
    relocate(row) |>
    filter(locus_tag == ilocus_tag)

  return(as.numeric(x$row))
}

to_search <- c("BSUA_RS19530", "BSUA_RS19520")

map(to_search, search_by_locus_tag)

# What is my output ...
# something tidy

neighbor_seq <- function(N) {
  c(seq(4, 1, -1), 0, seq(1, 4, 1))
}
sequence(39, 0, -1)
?seq
?sequence


c(seq(4, 1, -1), 0, seq(1, 4, 1))

find_neighbors_by_locus_tag <- function(tag, n, genome) {
  srta
}
