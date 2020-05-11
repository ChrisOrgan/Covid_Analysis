# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7-20


# Read tree ----
tree_mol <- read.newick(
  file = "nextstrain_ncov_non-subsampled_2020-04-30_tree_v2.nwk"
)

# Write tree in the NEXUS format ----
writeNexus(
  tree = tree_mol,
  file = "nextstrain_ncov_non-subsampled_2020-04-30_tree_v3.nex"
)
