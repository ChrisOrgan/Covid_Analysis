# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7.20


# Read tree ----
tree <- read.newick(file = "msa_trimmed_filtered_masked_clustered.nwk")

# Write tree in the NEXUS format ----
writeNexus(tree = tree, file = "tanner_tree.nex")
