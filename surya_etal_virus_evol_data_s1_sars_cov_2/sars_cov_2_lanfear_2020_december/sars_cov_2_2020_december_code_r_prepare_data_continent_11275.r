# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(stringr)


# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2020_december_metadata_v3_11275.txt",
  sep = "\t",
  header = TRUE
)

# Extract continents ----
continent <- word(meta$location, start = 1, end = 1, sep = "\\ / ")
## table(continent)
### continent
###        Africa          Asia        Europe North America       Oceania
###           207           691          7119          2444           706
### South America
###           108
## round(table(continent) / 11275 * 100, 2)
### continent
### continent
###        Africa          Asia        Europe North America       Oceania
###          1.84          6.13         63.14         21.68          6.26
### South America
###          0.96
names(continent) <- meta$id

# Save the sampling times to a tab-delimited text file ----
write.table(
  continent,
  file = "sars_cov_2_2020_december_data_continent_11275.txt",
  quote = FALSE,
  sep = "\t",
  row.names = TRUE,
  col.names = FALSE
)
