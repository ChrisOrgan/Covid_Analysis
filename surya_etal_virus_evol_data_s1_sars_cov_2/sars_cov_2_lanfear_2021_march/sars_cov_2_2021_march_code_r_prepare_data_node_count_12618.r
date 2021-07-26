# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2021_march_tree_v3_12618.nex")

# Extract node counts ----
node <- NULL
for (genome in 1:length(tree$tip.label)) {
  node[genome] <- length(
    nodepath(
      phy = tree,
      from = length(tree$tip.label) + 1,  # root
      to = genome
    )
  ) - 2  # minus the root and terminal tip
  names(node)[genome] <- tree$tip.label[genome]
}

# Save the node counts to a tab-delimited text file ----
write.table(
  node,
  file = "sars_cov_2_2021_march_data_node_count_12618.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
