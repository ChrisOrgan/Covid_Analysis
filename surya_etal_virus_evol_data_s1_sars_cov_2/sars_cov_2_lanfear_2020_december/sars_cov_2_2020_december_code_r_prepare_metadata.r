# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read sequencing metadata ----
meta <- read.csv(
  "sars_cov_2_2020_december_metadata_sequencing.tsv",
  sep = "\t",
  header = TRUE
)

# Edit metadata ----
## colnames(meta)
###  [1] "Virus.name"                  "Accession.ID"
###  [3] "Collection.date"             "Location"
###  [5] "Host"                        "Passage"
###  [7] "Specimen"                    "Additional.host.information"
###  [9] "Sequencing.technology"       "Assembly.method"
### [11] "Comment"                     "Comment.type"
### [13] "Lineage"                     "Clade"
meta <- meta[, c(2:5)]
colnames(meta) <- c("id", "date", "location", "host")

# Save the data frame to a tab-delimited text file ----
write.table(
  meta,
  file = "sars_cov_2_2020_december_metadata.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
