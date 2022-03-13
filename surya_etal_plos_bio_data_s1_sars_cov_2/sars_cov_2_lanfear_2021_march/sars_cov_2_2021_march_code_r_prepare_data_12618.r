# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read datasets ----
path <- read.table(
  "sars_cov_2_2021_march_data_root_tip_divergence_12618.txt",
  sep = "\t"
)
times <- read.table(
  "sars_cov_2_2021_march_data_sampling_time_12618.txt",
  sep = "\t"
)
node <- read.table(
  "sars_cov_2_2021_march_data_node_count_12618.txt",
  sep = "\t"
)
b117 <- read.table(
  "sars_cov_2_2021_march_data_lineage_b117_12618.txt",
  sep = "\t"
)

# Make a data frame ----
times <- times[match(path$V1, times$V1), ]
node <- node[match(path$V1, node$V1), ]
b117 <- b117[match(path$V1, b117$V1), ]
dat <- data.frame(path, times$V2, node$V2, b117$V2)
colnames(dat) <- c("genome", "path", "time", "node", "b117")

# Save the data frame to a tab-delimited text file ----
write.table(
  dat,
  file = "sars_cov_2_2021_march_data_12618.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
