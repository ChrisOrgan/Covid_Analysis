# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_1_tree_mol_v2_53.nex")

# Assign continents to genomes based on their metadata on NCBI ----
genome <- tree$tip.label
continent <- rep(NA, length(tree$tip.label))
dat <- data.frame(genome = genome, continent = continent)
dat[c(1, 8, 53), ]$continent <- "North America"
dat[c(2:7, 9:15, 17:20, 22:31, 33:52), ]$continent <- "Asia"
dat[c(16, 21, 32), ]$continent <- "Europe"
continent <- dat$continent
names(continent) <- dat$genome

# Save the continents to a tab-delimited text file ----
write.table(
  continent,
  file = "sars_cov_1_data_continent.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
