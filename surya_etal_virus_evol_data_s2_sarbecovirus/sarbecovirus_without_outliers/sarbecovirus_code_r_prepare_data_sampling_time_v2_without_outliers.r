# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(lubridate)
library(phytools)
library(stringr)
library(zoo)


# Read tree ----
tree <- read.nexus(file = "sarbecovirus_tree_mol_v3_50.nex")

# Extract sampling times from tip labels ----
dates <- word(tree$tip.label, start = 5, end = 5, sep = "\\.")
times <- data.frame(tree$tip.label, dates)
colnames(times) <- c("genome", "dates") 
for (genome in 1:length(times$genome)) {
  if (nchar(times$dates[genome]) == 4) {
    times$dformat[genome] <- "y"
  } else if (nchar(times$dates[genome]) == 7) {
    times$dformat[genome] <- "ym"
  } else {
    times$dformat[genome] <- "ymd"
  }
}
for (pdate in 1:length(times$dates)) {
  if (times$dformat[pdate] == "y") {
    ## middle of the year
    times$dec_year[pdate] <- as.numeric(times$dates[pdate]) + 0.5
  } else if (times$dformat[pdate] == "ym") {
    ## middle of the month
    times$dec_year[pdate] <- decimal_date(
      ymd(as.Date(as.yearmon(times$dates[pdate], "%Y-%m"), frac = 0.5))
    )
  } else {
    times$dec_year[pdate] <- decimal_date(ymd(times$dates[pdate]))
  }
}
times <- times[, "dec_year"]
names(times) <- tree$tip.label

# Save the sampling times to a tab-delimited text file ----
write.table(
  times,
  file = "sarbecovirus_data_sampling_time_v2_without_outliers.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
