# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.newick(file = "EXCLUDE_sars_cov_2_lanfear_2021_march_tree.tree")
tree$node.label <- NULL

# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2021_march_metadata_v2_filtered.txt",
  sep = "\t",
  header = TRUE
)

# Drop genomes without metadata ----
tip <- meta$id
tree <- keep.tip(phy = tree, tip = tip)

# Save the edited tree ----
writeNexus(
  tree = tree,
  file = "EXCLUDE_sars_cov_2_lanfear_2021_march_tree_v2_filtered.nex"
)
