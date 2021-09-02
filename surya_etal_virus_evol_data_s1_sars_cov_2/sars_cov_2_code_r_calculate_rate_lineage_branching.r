# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read data ----
dat <- read.table(
  "sars_cov_2_data.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)

# Calculate the rate of lineage-branching ----
## Previously estimated root age = 2019.84 (Duchene et al. 2020)
dat$branch_rate <- (dat$node/(dat$time-2019.84)) / 12  # months
# min(dat$branch_rate)
## [1] 0
# max(dat$branch_rate)
## [1] 173.4694
