#!/usr/bin/env Rscript

# Bacillus subtillis JH462

# ywqJ Deaminase toxin gene
# locus-tag BSUA_RS19530

# ywqL Endo V gene
# BSUA_RS19520


library(tidyverse)
library(stringr)

CDS <- microseq::readGFF("GCF_000699465.1_bsubJH642.gff") |>  filter(Type=="CDS")

CDS <- 
  
# attributes targets
# 

str_detect("hello", "llo")
