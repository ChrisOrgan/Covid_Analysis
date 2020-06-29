# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.
# Part of the codes were adopted from Sandra L. Ament-Velásquez.
# See http://evoslav.blogspot.com/2015/01/how-to-collapse-unsupported-branches-of.html


# library(ape)  # v5.3
library(phytools)  # v0.7-20


# Read and prepare tree ----
setwd("cipres")
tree <- read.newick(file = "output.treefile")
setwd("..")
seq_names <- read.table("surya_R_output_sequence_names.txt", sep = "\t")
colnames(seq_names) <- c("original", "edited")
seq_names$original <- as.character(seq_names$original)
seq_names$edited <- as.character(seq_names$edited)
seq_names <- seq_names[match(tree$tip.label, seq_names$edited), ]
# table(tree$tip.label == seq_names$edited)
#
#  TRUE
# 15019
tree$tip.label <- seq_names$original
tree$node.label <- as.numeric(gsub("/", "", tree$node.label))
tree$node.label[1] <- 1
# tree

# Locate nodes with low support values (< 0.5) ----
bad_nodes <- which(as.numeric(tree$node.label) < 0.5) + length(tree$tip.label)

# Get the actual indexes of the nodes with low support ----
bad_node_indexes <- c()
for(node in bad_nodes) {
  bad_node_indexes <- c(bad_node_indexes, which(tree$edge[, 2] == node))
}

# Make the branch length of the bad nodes = 0 ----
tree$edge.length[bad_node_indexes] <- 0

# Convert the branches with length = 0 to polytomies ----
tree_poly <- di2multi(tree)
tree_poly$node.label <- NULL
# tree_poly

# Write tree in the NEXUS format ----
writeNexus(tree = tree_poly, file = "surya_cipres_tree_collapsed.nex")
