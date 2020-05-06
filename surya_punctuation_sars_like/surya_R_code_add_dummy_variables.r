# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
meta <- read.delim(
  "nextstrain_groups_blab_sars-like-cov_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$virus.type)
colnames(dat)[4] <- "virus_type"
dat$genome <- sQuote(dat$genome)
## 2-group (ref = SARS-CoVs)
dat2 <- dat
dat2$beta2 <- ifelse(grepl("SARS-like CoV", dat2$virus_type), 1, 0)
dat2$beta2_node <- dat2$node * dat2$beta2
dat2 <- dat2[, -4]
## 2-group (ref = SARS-like CoV)
dat2b <- dat
dat2b$beta2 <- ifelse(grepl("SARS-like CoV", dat2b$virus_type), 0, 1)
dat2b$beta2_node <- dat2b$node * dat2b$beta2
dat2b <- dat2b[, -4]
## 3-group (ref = SARS-CoV)
dat3 <- dat
dat3$beta2 <- ifelse(grepl("SARS-CoV-2", dat3$virus_type), 1, 0)
dat3$beta3 <- ifelse(grepl("SARS-like CoV", dat3$virus_type), 1, 0)
dat3$beta3_node <- dat3$node * dat3$beta3
dat3 <- dat3[, -4]
## 3-group (ref = SARS-CoV-2)
dat3b <- dat
dat3b$beta2 <- ifelse(grepl("^SARS-CoV$", dat3b$virus_type), 1, 0)
dat3b$beta3 <- ifelse(grepl("SARS-like CoV", dat3b$virus_type), 1, 0)
dat3b$beta3_node <- dat3b$node * dat3b$beta3
dat3b <- dat3b[, -4]
## 3-group (ref = SARS-like CoV)
dat3c <- dat
dat3c$beta2 <- ifelse(grepl("^SARS-CoV$", dat3c$virus_type), 1, NA)
dat3c$beta3 <- ifelse(grepl("SARS-CoV-2", dat3c$virus_type), 1, NA)
dat3c$beta2_node <- dat3c$node * dat3c$beta2
dat3c$beta3_node <- dat3c$node * dat3c$beta3
dat3c$beta23_node <- ifelse(is.na(dat3c$beta2_node), dat3c$beta3_node,
                            dat3c$beta2_node)
dat3c <- dat3c[, -c(4, 7, 8)]
dat3c[is.na(dat3c)] <- 0

# Write data frames to tab-delimited text files ----
write.table(
  dat2,
  file = "surya_BayesTraits_data_path_lengths_nodes_type_2group.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat2b,
  file = "surya_BayesTraits_data_path_lengths_nodes_type_2group_ref2.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat3,
  file = "surya_BayesTraits_data_path_lengths_nodes_type_3group.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat3b,
  file = "surya_BayesTraits_data_path_lengths_nodes_type_3group_ref2.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
write.table(
  dat3c,
  file = "surya_BayesTraits_data_path_lengths_nodes_type_3group_ref3.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
