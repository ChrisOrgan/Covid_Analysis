# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2021_march_metadata.txt",
  sep = "\t",
  header = TRUE
)

# Filter genomes ----
meta <- meta[meta$host == "Human", ]
meta <- meta[nchar(meta$date) == 10, ]

# Save the data frame to a tab-delimited text file ----
write.table(
  meta,
  file = "sars_cov_2_2021_march_metadata_v2_filtered.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
