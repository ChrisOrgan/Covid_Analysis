# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.6.99


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v3.nex")

# Decompose the tree into a variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Extract path lengths (diagonals of the matrix) ----
paths <- diag(vcv)

# Extract nodes ----
nodes <- NULL
for (strain in 1:length(tree$tip.label)) {
  nodes[strain] <- length(
    nodepath(
      phy = tree,
      from = length(tree$tip.label) + 1,  # root
      to = strain
    )
   ) - 2  # minus the root and terminal tip
}

# Create a data frame ----
dat <- data.frame(sQuote(tree$tip.label), paths, nodes)

# Write data frame to a tab-delimited text file ----
write.table(
  dat,
  file = "surya_BayesTraits_data_path_lengths_nodes.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
