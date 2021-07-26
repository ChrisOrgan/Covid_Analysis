# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.newick(file = "sars_cov_2_tree_iqtree_output_tree.nwk")

# Root tree ----
root_genome <- "hCoV-19/Wuhan/WIV04/2019|EPI_ISL_402124|2019-12-30|China"
tree <- ladderize(
  reroot(
    tree = tree,
    node.number = which(tree$tip.label == root_genome),
    position = 0.5 * tree$edge.length[
      which(tree$edge[, 2] == which(tree$tip.label == root_genome))
    ]
  ),
  right = FALSE
)

# Save the edited tree ----
writeNexus(tree = tree, file = "sars_cov_2_tree_mol.nex")
