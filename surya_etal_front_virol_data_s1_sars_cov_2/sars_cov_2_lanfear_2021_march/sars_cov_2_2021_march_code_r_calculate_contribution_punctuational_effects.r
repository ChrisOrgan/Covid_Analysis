# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2021_march_tree_v3_12618.nex")

# Extract or write statistics ----
n_branch <- 2 * (length(tree$tip.label)-1)
beta <- 1.905264e-07
tree_length <- sum(tree$edge.length)

# Calculate the contribution of punctuational effects to molecular divergence
# ----
punc <- (n_branch*beta) / tree_length
## punc
### [1] 0.003729801
