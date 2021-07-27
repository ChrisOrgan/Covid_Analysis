# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.newick(file = "sars_cov_1_tree_iqtree_output_tree.treefile")

# Root tree ----
root_genome <- "DQ071615_BatCoV_Rp3"
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

# Drop the outgroup and non-human SARS-like CoV genomes ----
non_human <- tree$tip.label[grepl("CivetCoV", tree$tip.label) == TRUE]
tip_remove <- c(root_genome, non_human)
tree <- drop.tip(phy = tree, tip = tip_remove)

# Remove duplicate genomes ----
tip_remove2 <- read.table("sars_cov_1_data_duplicate_genomes.txt")
tip_remove2 <- as.character(tip_remove2$V1)
tree <- drop.tip(phy = tree, tip = tip_remove2)

# Save the edited tree ----
writeNexus(tree = tree, file = "sars_cov_1_tree_mol_v2_53.nex")
