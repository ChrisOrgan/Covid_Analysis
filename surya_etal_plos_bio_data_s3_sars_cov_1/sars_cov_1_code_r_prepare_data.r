# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read datasets ----
path <- read.table("sars_cov_1_data_root_tip_divergence.txt", sep = "\t")
times <- read.table("sars_cov_1_data_sampling_time.txt", sep = "\t")
node <- read.table("sars_cov_1_data_node_count.txt", sep = "\t")

# Make a data frame ----
times <- times[match(path$V1, times$V1), ]
node <- node[match(path$V1, node$V1), ]
dat <- data.frame(path, times$V2, node$V2)
colnames(dat) <- c("genome", "path", "time", "node")

# Save the data frame to a tab-delimited text file ----
write.table(
  dat,
  file = "sars_cov_1_data.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = TRUE
)
