# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(phytools)


# Read tree ----
tree <- read.nexus(
  file = "EXCLUDE_sars_cov_2_lanfear_2021_march_tree_v2_filtered.nex"
)

# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2021_march_metadata_v2_filtered.txt",
  sep = "\t",
  header = TRUE
)

# Sample 15,000 genomes from the tree ----
set.seed(0)
tip <- sample(meta$id, size = 15000)
tree <- keep.tip(phy = tree, tip = tip)
meta <- meta[meta$id %in% tip, ]

# Remove duplicate genomes ----
## Duplicate genomes have the same path length and
## node path (route from the root).
vcv <- vcv(phy = tree)
path <- diag(vcv)
meta <- meta[match(names(path), meta$id), ]
meta$path <- path
node_path <- nodepath(phy = tree)
node_path <- lapply(node_path, function(x) x[-length(x)])  # removes tip labels
node_path <- unlist(lapply(node_path, function(x) paste(x, collapse = "")))
meta$node_path <- node_path
meta <- meta[
  !(
    duplicated(meta[, c("path", "node_path")]) |
    duplicated(meta[, c("path", "node_path")], fromLast = TRUE)
  ),
]
## length(meta$id)
### [1] 12618
tree <- keep.tip(phy = tree, tip = meta$id)

# Save the tree ----
writeNexus(tree = tree, file = "sars_cov_2_2021_march_tree_v3_12618.nex")

# Save the data frame to a tab-delimited text file ----
write.table(
  meta,
  file = "sars_cov_2_2021_march_metadata_v3_12618.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
