# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7.20


# Read trees ----
tree_mol <- read.newick(file = "nextstrain_ncov_global_tree_v2.nwk")
tree_time <- read.newick(file = "nextstrain_ncov_global_timetree_v2.nwk")

# Set negative branch lengths to zero ----
tree_time$edge.length[tree_time$edge.length < 0] <- 0

# Write trees in the NEXUS format ----
writeNexus(
  tree = tree_mol,
  file = "nextstrain_ncov_global_tree_v3.nex"
)
writeNexus(
  tree = tree_time,
  file = "nextstrain_ncov_global_timetree_v3.nex"
)
