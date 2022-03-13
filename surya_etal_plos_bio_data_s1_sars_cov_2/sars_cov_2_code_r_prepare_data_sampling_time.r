# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(lubridate)
library(phytools)
library(stringr)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_tree_mol_v2_15019.nex")

# Extract sampling times from tip labels ----
times <- word(tree$tip.label, start = 3, end = 3, sep = "\\|")
times <- gsub("-00", "-01", times)
times <- decimal_date(ymd(times))
names(times) <- tree$tip.label

# Save the sampling times to a tab-delimited text file ----
write.table(
  times,
  file = "sars_cov_2_data_sampling_time.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
