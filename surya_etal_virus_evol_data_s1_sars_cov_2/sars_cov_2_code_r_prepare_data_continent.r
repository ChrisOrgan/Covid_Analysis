# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)
library(stringr)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_tree_mol_v2_15019.nex")

# Extract continents from tip labels ----
continent <- word(tree$tip.label, start = 4, end = 4, sep = "\\|")
continent[continent == "CentralAmerica"] <- "North America"  # per Nextstrain
continent[continent == "China"] <- "Asia"
continent[continent == "NorthAmerica"] <- "North America"
continent[continent == "SouthAmerica"] <- "South America"
names(continent) <- tree$tip.label

# Save the continents to a tab-delimited text file ----
write.table(
  continent,
  file = "sars_cov_2_data_continent.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
