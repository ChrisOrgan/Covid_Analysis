# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7.20


# Read tree ----
tree <- read.newick(file = "msa_trimmed_filtered_masked.nwk")
## tree
## 
## Phylogenetic tree with 23237 tips and 23235 internal nodes.
## 
## Tip labels:
##         hCoV-19/Wuhan/WIV04/2019|EPI_ISL_402124|2019-12-30|China, hCoV-19/USA/NY-NYUMC389/2020|EPI_ISL_430416|2020-04-13|NorthAmerica, hCoV-19/USA/NY-NYUMC525/2020|EPI_ISL_444642|2020-03-30|NorthAmerica, hCoV-19/USA/NY-NYUMC258/2020|EPI_ISL_428772|2020-04-05|NorthAmerica, hCoV-19/Denmark/ALAB-SSI-719/2020|EPI_ISL_444873|2020-03-28|Europe, hCoV-19/USA/WA-S395/2020|EPI_ISL_434155|2020-03-30|NorthAmerica, ...
## 
## Unrooted; includes branch lengths.

# Write tree in the NEXUS format ----
writeNexus(tree = tree, file = "tanner_wduplicates_tree.nex")
