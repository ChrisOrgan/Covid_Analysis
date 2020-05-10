# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3


# Check trees ----
tree_mol <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
tree_time <- read.nexus(file = "nextstrain_ncov_global_timetree_v4.nex")
tree_mol
tree_time
all.equal.phylo(target = tree_mol, current = tree_time, use.edge.length = FALSE)
## [1] TRUE
