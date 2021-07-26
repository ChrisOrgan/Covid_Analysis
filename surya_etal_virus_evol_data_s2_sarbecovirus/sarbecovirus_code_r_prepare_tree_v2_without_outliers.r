# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sarbecovirus_tree_mol_v2_60.nex")

# Remove outliers ----
outliers <- read.table("sarbecovirus_data_outliers.txt")
outliers <- outliers$V1
tree <- drop.tip(phy = tree, tip = outliers)

# Save the edited tree ----
writeNexus(tree = tree, file = "sarbecovirus_tree_mol_v3_51.nex")
