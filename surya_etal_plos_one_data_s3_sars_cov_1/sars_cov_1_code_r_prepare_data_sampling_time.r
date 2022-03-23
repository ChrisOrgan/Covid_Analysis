# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)
library(stringr)


# Read tree ----
tree <- read.nexus(file = "sars_cov_1_tree_mol_v2_53.nex")

# Extract sampling times from tip labels ----
times <- word(tree$tip.label, start = 4, end = 4, sep = "_")
times[21] <- word(tree$tip.label[21], start = 5, end = 5, sep = "_")
names(times) <- tree$tip.label

# Save the sampling times to a tab-delimited text file ----
write.table(
  times,
  file = "sars_cov_1_data_sampling_time.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
