# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sarbecovirus_tree_mol_v3_50.nex")

# Extract or write statistics ----
n_branch <- 2 * (length(tree$tip.label)-1)
beta <- 1.469128e-04
tree_length <- sum(tree$edge.length)

# Calculate the contribution of punctuational effects to molecular divergence
# ----
punc <- (n_branch*beta) / tree_length
## punc
### [1] 0.01680825
