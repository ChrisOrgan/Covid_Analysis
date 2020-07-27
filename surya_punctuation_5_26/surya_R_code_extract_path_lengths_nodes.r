# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7.20
library(stringr)  # v.1.4.0


# Read tree ----
tree <- read.nexus(file = "tanner_tree.nex")

# Decompose tree into variance-covariance matrix ----
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

# Extract continent data from tip labels ----
continent <- word(tree$tip.label, start = 4, end = 4, sep = "\\|")
continent[continent == "CentralAmerica"] <- "North America"  # per Nextstrain
continent[continent == "China"] <- "Asia"
continent[continent == "NorthAmerica"] <- "North America"
continent[continent == "SouthAmerica"] <- "South America"
region <- data.frame(tree$tip.label, continent)

# Create data frames ----
dat <- data.frame(tree$tip.label, path, node)
dat_int <- data.frame(tree$tip.label, path)  # intercept-only
dat_region <- cbind(dat, region$continent)

# Write data frames to tab-delimited text files ----
write.table(
  dat,
  file = "surya_R_data_path_lengths_nodes.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_int,
  file = "surya_R_data_path_lengths.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_region,
  file = "surya_R_data_path_lengths_nodes_region.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
