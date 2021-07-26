# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(lubridate)


# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2020_december_metadata_v3_11275.txt",
  sep = "\t",
  header = TRUE
)

# Convert sampling times ----
times <- decimal_date(ymd(meta$date))
names(times) <- meta$id

# Save the sampling times to a tab-delimited text file ----
write.table(
  times,
  file = "sars_cov_2_2020_december_data_sampling_time_11275.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
