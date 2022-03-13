# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_tree_mol.nex")

# Read list of tips to remove ----
tip_remove <- read.table("sars_cov_2_data_outliers_problematic.txt")
tip_remove <- as.character(tip_remove$V1)

# Remove problematic genomes ----
tree <- drop.tip(phy = tree, tip = tip_remove)

# Save the edited tree ----
writeNexus(tree = tree, file = "sars_cov_2_tree_mol_v2_15019.nex")
