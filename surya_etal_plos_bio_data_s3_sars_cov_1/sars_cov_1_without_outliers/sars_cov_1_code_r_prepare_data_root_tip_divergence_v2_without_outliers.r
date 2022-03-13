# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_1_tree_mol_v3_42.nex")

# Decompose the tree into a variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Extract root-to-tip divergences or path lengths (diagonals of the matrix) ----
path <- diag(vcv)

# Save the path lengths to a tab-delimited text file ----
write.table(
  path,
  file = "sars_cov_1_data_root_tip_divergence_v2_without_outliers.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
