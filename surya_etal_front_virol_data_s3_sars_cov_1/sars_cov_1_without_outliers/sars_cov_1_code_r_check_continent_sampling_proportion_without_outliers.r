# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read data ----
continent_temp <- read.table(
  "../sars_cov_1_data_continent.txt",
  sep = "\t",
  header = FALSE,
  row.names = 1
)
continent <- continent_temp$V2
names(continent) <- rownames(continent_temp)

# Remove outliers ----
outliers <- read.table("sars_cov_1_data_outliers.txt")
outliers <- outliers$V1
continent <- continent[!names(continent) %in% outliers]

# Check by-continent sampling proportion ----
# table(continent)
#> continent
#>          Asia        Europe North America
#>            36             3             3

# Check by-continent sampling proportion (per 1,000 genomes) ----
# table(continent) / length(continent) * 1000
#> continent
#>          Asia        Europe North America
#>     857.14286      71.42857      71.42857
