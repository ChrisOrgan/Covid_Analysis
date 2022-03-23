# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(stringr)


# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2021_march_metadata_v3_12618.txt",
  sep = "\t",
  header = TRUE
)

# Extract lineage B.1.1.7 ----
meta$b117 <- 0
meta$b117[meta$lineage == "B.1.1.7"] <- 1
## table(meta$b117)
### 
###     0     1
### 10327  2291
## round(table(meta$b117) / 12618 * 100, 2)
### 
###     0     1
### 81.84 18.16

# Save the sampling times to a tab-delimited text file ----
write.table(
  meta[, c(1, 8)],
  file = "sars_cov_2_2021_march_data_lineage_b117_12618.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
