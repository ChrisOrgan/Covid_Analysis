# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20


# Read tree ----
tree <- read.nexus(
  file = "nextstrain_ncov_non-subsampled_2020-04-30_tree_v4.nex"
)

# Decompose tree into a variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Extract path lengths (diagonals of the matrix) ----
path <- diag(vcv)

# Extract nodes ----
node <- NULL
for (strain in 1:length(tree$tip.label)) {
  node[strain] <- length(
    nodepath(
      phy = tree,
      from = length(tree$tip.label) + 1,  # root
      to = strain
    )
  ) - 2  # minus the root and terminal tip
}

# Create data frames ----
dat <- data.frame(sQuote(tree$tip.label), path, node)
dat_int <- data.frame(sQuote(tree$tip.label), path)  # intercept-only

# Write data frames to tab-delimited text files ----
write.table(
  dat,
  file = "surya_BayesTraits_data_path_lengths_nodes.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_int,
  file = "surya_BayesTraits_data_path_lengths.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
