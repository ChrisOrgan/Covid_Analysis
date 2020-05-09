# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
meta <- meta[match(dat$genome, meta$Strain), ]
dat$continent <- meta$Region
dat$genome <- sQuote(dat$genome)
dat_pop <- dat
dat_eq <- dat
## 6-group (ref = Africa)
dat_afr <- dat
dat_afr$asia_beta <- ifelse(grepl("Asia", dat_afr$continent), 1, 0)
dat_afr$asia_int <- dat_afr$asia_beta * dat_afr$node
dat_afr$euro_beta <- ifelse(grepl("Europe", dat_afr$continent), 1, 0)
dat_afr$euro_int <- dat_afr$euro_beta * dat_afr$node
dat_afr$namer_beta <- ifelse(grepl("North America", dat_afr$continent), 1, 0)
dat_afr$namer_int <- dat_afr$namer_beta * dat_afr$node
dat_afr$ocea_beta <- ifelse(grepl("Oceania", dat_afr$continent), 1, 0)
dat_afr$ocea_int <- dat_afr$ocea_beta * dat_afr$node
dat_afr$samer_beta <- ifelse(grepl("South America", dat_afr$continent), 1, 0)
dat_afr$samer_int <- dat_afr$samer_beta * dat_afr$node
## 6-group (ref = Asia)
dat_asia <- dat
dat_asia$afr_beta <- ifelse(grepl("Africa", dat_asia$continent), 1, 0)
dat_asia$afr_int <- dat_asia$afr_beta * dat_asia$node
dat_asia$euro_beta <- ifelse(grepl("Europe", dat_asia$continent), 1, 0)
dat_asia$euro_int <- dat_asia$euro_beta * dat_asia$node
dat_asia$namer_beta <- ifelse(grepl("North America", dat_asia$continent), 1, 0)
dat_asia$namer_int <- dat_asia$namer_beta * dat_asia$node
dat_asia$ocea_beta <- ifelse(grepl("Oceania", dat_asia$continent), 1, 0)
dat_asia$ocea_int <- dat_asia$ocea_beta * dat_asia$node
dat_asia$samer_beta <- ifelse(grepl("South America", dat_asia$continent), 1, 0)
dat_asia$samer_int <- dat_asia$samer_beta * dat_asia$node
## 6-group (ref = Europe)
dat_euro <- dat
dat_euro$afr_beta <- ifelse(grepl("Africa", dat_euro$continent), 1, 0)
dat_euro$afr_int <- dat_euro$afr_beta * dat_euro$node
dat_euro$asia_beta <- ifelse(grepl("Asia", dat_euro$continent), 1, 0)
dat_euro$asia_int <- dat_euro$asia_beta * dat_euro$node
dat_euro$namer_beta <- ifelse(grepl("North America", dat_euro$continent), 1, 0)
dat_euro$namer_int <- dat_euro$namer_beta * dat_euro$node
dat_euro$ocea_beta <- ifelse(grepl("Oceania", dat_euro$continent), 1, 0)
dat_euro$ocea_int <- dat_euro$ocea_beta * dat_euro$node
dat_euro$samer_beta <- ifelse(grepl("South America", dat_euro$continent), 1, 0)
dat_euro$samer_int <- dat_euro$samer_beta * dat_euro$node
## 6-group (ref = North America)
dat_namer <- dat
dat_namer$afr_beta <- ifelse(grepl("Africa", dat_namer$continent), 1, 0)
dat_namer$afr_int <- dat_namer$afr_beta * dat_namer$node
dat_namer$asia_beta <- ifelse(grepl("Asia", dat_namer$continent), 1, 0)
dat_namer$asia_int <- dat_namer$asia_beta * dat_namer$node
dat_namer$euro_beta <- ifelse(grepl("Europe", dat_namer$continent), 1, 0)
dat_namer$euro_int <- dat_namer$euro_beta * dat_namer$node
dat_namer$ocea_beta <- ifelse(grepl("Oceania", dat_namer$continent), 1, 0)
dat_namer$ocea_int <- dat_namer$ocea_beta * dat_namer$node
dat_namer$samer_beta <- ifelse(
  grepl("South America", dat_namer$continent), 1, 0
)
dat_namer$samer_int <- dat_namer$samer_beta * dat_namer$node
## 6-group (ref = Oceania)
dat_ocea <- dat
dat_ocea$afr_beta <- ifelse(grepl("Africa", dat_ocea$continent), 1, 0)
dat_ocea$afr_int <- dat_ocea$afr_beta * dat_ocea$node
dat_ocea$asia_beta <- ifelse(grepl("Asia", dat_ocea$continent), 1, 0)
dat_ocea$asia_int <- dat_ocea$asia_beta * dat_ocea$node
dat_ocea$euro_beta <- ifelse(grepl("Europe", dat_ocea$continent), 1, 0)
dat_ocea$euro_int <- dat_ocea$euro_beta * dat_ocea$node
dat_ocea$namer_beta <- ifelse(grepl("North America", dat_ocea$continent), 1, 0)
dat_ocea$namer_int <- dat_ocea$namer_beta * dat_ocea$node
dat_ocea$samer_beta <- ifelse(grepl("South America", dat_ocea$continent), 1, 0)
dat_ocea$samer_int <- dat_ocea$samer_beta * dat_ocea$node
## 6-group (ref = South America)
dat_samer <- dat
dat_samer$afr_beta <- ifelse(grepl("Africa", dat_samer$continent), 1, 0)
dat_samer$afr_int <- dat_samer$afr_beta * dat_samer$node
dat_samer$asia_beta <- ifelse(grepl("Asia", dat_samer$continent), 1, 0)
dat_samer$asia_int <- dat_samer$asia_beta * dat_samer$node
dat_samer$euro_beta <- ifelse(grepl("Europe", dat_samer$continent), 1, 0)
dat_samer$euro_int <- dat_samer$euro_beta * dat_samer$node
dat_samer$namer_beta <- ifelse(
  grepl("North America", dat_samer$continent), 1, 0
)
dat_samer$namer_int <- dat_samer$namer_beta * dat_samer$node
dat_samer$ocea_beta <- ifelse(grepl("Oceania", dat_samer$continent), 1, 0)
dat_samer$ocea_int <- dat_samer$ocea_beta * dat_samer$node
## 6-group (equal-slopes; ref = Africa)
dat_afr_eq <- dat_eq
dat_afr_eq$asia_beta <- ifelse(grepl("Asia", dat_afr_eq$continent), 1, 0)
dat_afr_eq$euro_beta <- ifelse(grepl("Europe", dat_afr_eq$continent), 1, 0)
dat_afr_eq$namer_beta <- ifelse(
  grepl("North America", dat_afr_eq$continent), 1, 0
)
dat_afr_eq$ocea_beta <- ifelse(grepl("Oceania", dat_afr_eq$continent), 1, 0)
dat_afr_eq$samer_beta <- ifelse(
  grepl("South America", dat_afr_eq$continent), 1, 0
)
## 6-group + pop. size (ref = Africa)
dat_afr_pop <- dat_pop
dat_afr_pop$asia_beta <- ifelse(grepl("Asia", dat_afr_pop$continent), 1, 0)
dat_afr_pop$asia_int <- dat_afr_pop$asia_beta * dat_afr_pop$node
dat_afr_pop$euro_beta <- ifelse(grepl("Europe", dat_afr_pop$continent), 1, 0)
dat_afr_pop$euro_int <- dat_afr_pop$euro_beta * dat_afr_pop$node
dat_afr_pop$namer_beta <- ifelse(
  grepl("North America", dat_afr_pop$continent), 1, 0
)
dat_afr_pop$namer_int <- dat_afr_pop$namer_beta * dat_afr_pop$node
dat_afr_pop$ocea_beta <- ifelse(grepl("Oceania", dat_afr_pop$continent), 1, 0)
dat_afr_pop$ocea_int <- dat_afr_pop$ocea_beta * dat_afr_pop$node
dat_afr_pop$samer_beta <- ifelse(
  grepl("South America", dat_afr_pop$continent), 1, 0
)
dat_afr_pop$samer_int <- dat_afr_pop$samer_beta * dat_afr_pop$node
dat_afr_pop$pop_size[dat_afr_pop$continent == "Africa"] <- 1340598113
dat_afr_pop$pop_size[dat_afr_pop$continent == "Asia"] <- 4641054786
dat_afr_pop$pop_size[dat_afr_pop$continent == "Europe"] <- 747636045
dat_afr_pop$pop_size[dat_afr_pop$continent == "North America"] <- 368092846
dat_afr_pop$pop_size[dat_afr_pop$continent == "Oceania"] <- 42677809
dat_afr_pop$pop_size[dat_afr_pop$continent == "South America"] <- 653739130
## 1-group + pop. size
dat_pop$pop_size[dat_pop$continent == "Africa"] <- 1340598113
dat_pop$pop_size[dat_pop$continent == "Asia"] <- 4641054786
dat_pop$pop_size[dat_pop$continent == "Europe"] <- 747636045
dat_pop$pop_size[dat_pop$continent == "North America"] <- 368092846
dat_pop$pop_size[dat_pop$continent == "Oceania"] <- 42677809
dat_pop$pop_size[dat_pop$continent == "South America"] <- 653739130
## 1-group x pop. size
dat_pop_int <- dat_pop
dat_pop_int$int <- dat_pop_int$node * dat_pop_int$pop_size

# Write data frames to tab-delimited text files ----
write.table(
  dat_afr[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_africa.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_asia[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_asia.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_euro[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_europe.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_namer[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_namerica.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_ocea[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_oceania.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_samer[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_samerica.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_afr_eq[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_africa_eq.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_afr_pop[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_region_ref_africa_pop.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_pop[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_pop.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat_pop_int[, -4],
  file = "surya_BayesTraits_data_path_lengths_nodes_pop_interaction.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
