# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.6.99


# Read tree ----
setwd("../../2_data/nextstrain_ncov_04_15")
tree <- read.newick(file = "nextstrain_ncov_global_tree_v2.nwk")

# Write tree in the NEXUS format ----
setwd("../../3_analysis/nextstrain_ncov_04_15")
writeNexus(
  tree = tree,
  file = "nextstrain_ncov_global_tree_v3.nex"
)
