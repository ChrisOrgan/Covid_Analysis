# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20


# Read trees ----
tree_mol <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
tree_time <- read.nexus(file = "nextstrain_ncov_global_timetree_v4.nex")
## all.equal.phylo(
##   target = tree_mol,
##   current = tree_time,
##   use.edge.length = FALSE
## )

# Create dataframe ----
brlen <- data.frame(tree_mol$edge, tree_time$edge, tree_mol$edge.length,
                    tree_time$edge.length)
colnames(brlen) <- c("me1", "me2", "te1", "te2", "mol_length", "time_length")
brlen$check <- brlen$me1 == brlen$te1 & brlen$me2 == brlen$te2
length(brlen$check[brlen$check == TRUE]) == length(brlen$me1)
## [1] TRUE
## Avoid division by zero
hist(brlen$time_length[brlen$time_length != 0])
max(brlen$time_length[brlen$time_length != 0]) /
  min(brlen$time_length[brlen$time_length != 0])
brlen$time_length[brlen$time_length == 0] <- 0.000001
brlen$rate_length <- NULL
brlen$rate_length[brlen$mol_length != 0 & brlen$time_length != 0] <-
  brlen$mol_length[brlen$mol_length != 0 & brlen$time_length != 0] /
  brlen$time_length[brlen$mol_length != 0 & brlen$time_length != 0]
brlen$rate_length[brlen$mol_length == 0 & brlen$time_length != 0] <-
  brlen$mol_length[brlen$mol_length == 0 & brlen$time_length != 0] /
  brlen$time_length[brlen$mol_length == 0 & brlen$time_length != 0]

# Create rate tree ----
tree_rate <- tree_mol
tree_rate$edge.length <- brlen$rate_length
tree_rate$tip.label <- sQuote(tree_rate$tip.label)

# Write tree in the NEXUS format ----
writeNexus(tree = tree_rate, file = "surya_tree_rate.nex")

# Check rate branch lengths ----
hist(brlen$rate_length)
head(sort(brlen$rate_length), 5)
tail(sort(brlen$rate_length), 5)
rates <- brlen$rate_length[brlen$rate_length < max(brlen$rate_length)]
hist(rates)
head(sort(rates), 100)
tail(sort(rates), 100)

# Remove outlier branches ----
drop_list <- c("France/ARA13095/2020", "DRC/KN-0051/2020", "DRC/KN-0054/2020",
               "DRC/KN-0070/2020", "DRC/73/2020", "DRC/KN-0043/2020",
               "DRC/80/2020", "DRC/KN-0072/2020")
drop_list <- sQuote(drop_list)
tree_rate_edit <- drop.tip(phy = tree_rate, tip = drop_list)

# Write tree in the NEXUS format ----
writeNexus(tree = tree_rate_edit, file = "surya_tree_rate_v2.nex")
