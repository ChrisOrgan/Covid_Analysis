# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(lubridate)


# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2021_march_metadata_v3_12618.txt",
  sep = "\t",
  header = TRUE
)

# Convert sampling times ----
times <- decimal_date(ymd(meta$date))
names(times) <- meta$id

# Save the sampling times to a tab-delimited text file ----
write.table(
  times,
  file = "sars_cov_2_2021_march_data_sampling_time_12618.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
