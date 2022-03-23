# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_1_tree_mol_v2_53.nex")

# Remove outliers ----
outliers <- read.table("sars_cov_1_data_outliers.txt")
outliers <- outliers$V1
tree <- drop.tip(phy = tree, tip = outliers)

# Save the edited tree ----
writeNexus(tree = tree, file = "sars_cov_1_tree_mol_v3_42.nex")
