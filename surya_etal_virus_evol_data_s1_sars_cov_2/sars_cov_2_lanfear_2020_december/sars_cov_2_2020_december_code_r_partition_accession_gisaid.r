# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read GISAID accession IDs ----
id <- read.table("sars_cov_2_2020_december_accession_gisaid.txt")

# Set partitions ----
part_start <- seq(from = 0, to = 170000, by = 10000)
part_start <- part_start + 1
part_end <- part_start[-1] - 1
part_end <- c(part_end, length(id$V1))
part <- data.frame(part_start, part_end)
colnames(part) <- c("start", "end")

# Save IDs to tab-delimited text files ----
for (set in 1:length(part$start)) {
  write.table(
    id$V1[part$start[set]:part$end[set]],
    file = paste("sars_cov_2_2020_december_accession_gisaid_part_", set,
                 ".txt", sep = ""),
    quote = FALSE,
    sep = "\t",
    row.names = FALSE,
    col.names = FALSE
  )
}
