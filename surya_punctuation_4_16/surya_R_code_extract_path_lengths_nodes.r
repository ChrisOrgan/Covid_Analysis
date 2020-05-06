# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20


# Read trees ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
tree_rate <- read.nexus(file = "surya_tree_rate_v2.nex")

# Decompose trees into variance-covariance matrices ----
vcv <- vcv(phy = tree)
vcv_rate <- vcv(phy = tree_rate)

# Extract path lengths (diagonals of the matrix) ----
path <- diag(vcv)
path_rate <- diag(vcv_rate)

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
node_rate <- NULL
for (strain in 1:length(tree_rate$tip.label)) {
  node_rate[strain] <- length(
    nodepath(
      phy = tree_rate,
      from = length(tree_rate$tip.label) + 1,
      to = strain
    )
  ) - 2
}

# Create data frames ----
dat <- data.frame(sQuote(tree$tip.label), path, node)
dat_int <- data.frame(sQuote(tree$tip.label), path)  # intercept-only
dat_rate <- data.frame(sQuote(tree_rate$tip.label), path_rate, node_rate)
dat_rate_int <- data.frame(sQuote(tree_rate$tip.label), path_rate)

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
write.table(
  dat_rate,
  file = "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_rate_int,
  file = "surya_BayesTraits_data_rate_path_lengths.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
