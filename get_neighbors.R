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
  select_if(function(x) !(all(is.na(x)) | all(x == ""))) |> # remove empty cols stackoverflow 49374887
  relocate(gene, locus_tag, start, end, feature, product, seqname, strand, frame)


# definition of neighbor
CDS <- CDS |>
  arrange(start) |>
  mutate(order = 1:nrow(CDS)) |>
  relocate(order)


print(head(CDS))
names(CDS)


# Search Neighbors Functions ----------------------------------------------


circ <- function(idx, size) {
  # circular_index
  # In R indexes start on 1
  ((idx - 1) %% size) + 1
}

circ(-2, 3)

get_match_position <- function(target, genome) {
  x <- genome |>
    filter(locus_tag == target)
  as.numeric(x$order)
}

get_match_position(TO_SEARCH[1], CDS)

neighbor_seq <- function(N) {
  c(seq(N, 1, -1), 0, seq(1, N, 1))
}

neighbor_seq(4)


find_neighbors <- function(target, N, genome) {
  idx <- get_match_position(target, genome)
  R <- nrow(genome)

  start <- idx - N
  if (start < 1) {
    start_oflow <- TRUE
  } else {
    start_oflow <- FALSE
  }

  end <- idx + N
  if (end > R) {
    end_oflow <- TRUE
  } else {
    end_oflow <- FALSE
  }

  end <- (idx + N)

  if (!start_oflow && !end_oflow) {
    x <- genome[start:end, ]
  } else {
    cstart <- circ(start, R)
    cend <- circ(end, R)

    cbind(genome[cstart:R, ], genome[1:cend, ])
  }


  x |>
    mutate(neighbor_n = neighbor_seq(N)) |>
    relocate(neighbor_n) |>
    select(neighbor_n, order, gene, locus_tag, start, end, feature, product, seqname, strand, frame)
}


# Run ---------------------------------------------------------------------

write_tsv(find_neighbors(TO_SEARCH[1], 16, CDS), "ywqJ.tsv")
write_tsv(find_neighbors(TO_SEARCH[2], 16, CDS), "ywqL.tsv")
