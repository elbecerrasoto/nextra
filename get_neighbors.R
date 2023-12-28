#!/usr/bin/env Rscript

# Bacillus subtillis JH462

# Getting Neighbors of the following genes:

# ywqJ Deaminase toxin locus tag: BSUA_RS19530
# ywqL Endo V          locus tag: BSUA_RS19520

# Get the GFF
# ./download_genome.py -i gff3 -p GCF_000699465.1_bsubJH642 GCF_000699465.1


N <- 2^4 # Number of Neighbors per direction
TO_SEARCH <- c("BSUA_RS19530", "BSUA_RS19520") # locus tag to search
GFF <- "GCF_000699465.1/GCF_000699465.1_bsubJH642.gff"

library(tidyverse)
library(stringr)
library(segmenTools)
# devtools::install_github("raim/segmenTools")

# GFF quality
Rgff::check_gff(GFF)
Rgff::gff_stats(GFF)
Rgff::get_features(GFF)


# Definition of Neighbor --------------------------------------------------


# What is the definition of a neighbor?
# Same feature type, same strand?
# CDS vs gene
# Mutually Exclusive?
# The table gets filter and ordered, to define the neighbors

# For now the definition is a CDS, doesn't matter the strand
# Contiguos by start position


CDS <- segmenTools::gff2tab(GFF) |>
  tibble() |>
  filter(feature == "CDS") |>
  select_if(function(x) !(all(is.na(x)) | all(x == ""))) |> # remove empty cols https://stackoverflow.com/questions/49374887/piping-the-removal-of-empty-columns-using-dplyr
  relocate(gene, locus_tag, start, end, feature, Parent, product, seqname, strand, frame) |>
  arrange(start) |> # definition of neighbor
  mutate(row = 1:nrow(CDS)) |>
  relocate(row)


print(head(CDS))
names(CDS)

# Search Neighbors --------------------------------------------------------

circular_index <- function(idx, size) {
  # In R indexes start on 1
  ((idx - 1) %% size) + 1
}


get_match_position <- function(target, genome) {
  x <- genome |>
    mutate(row = 1:nrow(genome)) |>
    relocate(row) |>
    filter(locus_tag == target)

  return(as.numeric(x$row))
}


neighbor_seq <- function(N) {
  c(seq(N, 1, -1), 0, seq(1, N, 1))
}


find_neighbors_by_locus_tag <- function(target, N, genome) {
  get_match_position()
}
