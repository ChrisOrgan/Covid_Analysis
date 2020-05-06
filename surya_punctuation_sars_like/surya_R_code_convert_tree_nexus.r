# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7-20


# Read tree ----
tree <- read.newick(file = "nextstrain_groups_blab_sars-like-cov_tree_v2.nwk")

# Enclose tip labels in single quotation marks ----
tree$tip.label <- gsub("'", "", tree$tip.label)
tree$tip.label <- sQuote(tree$tip.label)

# Write tree in the NEXUS format ----
writeNexus(
  tree = tree,
  file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex"
)
