# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.newick(file = "sarbecovirus_tree_iqtree_output_tree.treefile")

# Root tree ----
root_genome <- "BtKY72.Bat-R_spp.Kenya.KY352407.2007-10"
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

# Drop the outgroup
tree <- drop.tip(phy = tree, tip = root_genome)

# Remove duplicate genomes ----
tip_remove <- read.table("sarbecovirus_data_duplicate_genomes.txt")
tip_remove <- as.character(tip_remove$V1)
tree <- drop.tip(phy = tree, tip = tip_remove)

# Save the edited tree ----
writeNexus(tree = tree, file = "sarbecovirus_tree_mol_v2_59.nex")
