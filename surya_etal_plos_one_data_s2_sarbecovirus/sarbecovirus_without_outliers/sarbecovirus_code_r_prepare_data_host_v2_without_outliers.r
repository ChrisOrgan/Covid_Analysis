# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)
library(stringr)


# Read tree ----
tree <- read.nexus(file = "sarbecovirus_tree_mol_v3_50.nex")

# Extract hosts from tip labels ----
host <- word(tree$tip.label, start = 2, end = 2, sep = "\\.")
dat <- data.frame(tree$tip.label, host)
colnames(dat) <- c("genome", "host")
dat$host[grepl("Bat", dat$host) == TRUE] <- "Bat"
dat$host[grepl("SARS-CoV", dat$host) == TRUE] <- "Human"
host <- dat$host
names(host) <- tree$tip.label

# Save the sampling times to a tab-delimited text file ----
write.table(
  host,
  file = "sarbecovirus_data_host_v2_without_outliers.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
