# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20
library(nlme)  # v3.1-147


# Read tree ----
tree <- read.nexus(file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex")

# Define correlation matrix ----
vcv_lambda1 <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
meta <- read.delim(
  "nextstrain_groups_blab_sars-like-cov_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$virus.type)
colnames(dat)[4] <- "virus_type"
dat$genome <- sQuote(dat$genome)
dat <- dat[, -1]
## 2-group (ref = SARS-CoVs)
dat$virus_type2 <- dat$virus_type
dat$virus_type2[dat$virus_type2 == "SARS-CoV-2"] <- "SARS-CoV"
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

# Test for punctuation ----
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (2nd replicate) ----
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda1.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd replicate)\n")
cat("================================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (2 group) ----
pgls_pe <- gls(path ~ node * virus_type2, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_2group_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (2 group; 2nd replicate) ----
pgls_pe <- gls(path ~ node * virus_type2, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_2group_lambda1.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd replicate)\n")
cat("================================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (3 group; ref = SARS-CoV) ----
pgls_pe <- gls(
  path ~ node + beta2 + beta3 + beta3_node,
  data = dat3,
  correlation = vcv_lambda1
)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_3group_ref1_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (3 group; ref = SARS-CoV-2) ----
pgls_pe <- gls(
  path ~ node + beta2 + beta3 + beta3_node,
  data = dat3b,
  correlation = vcv_lambda1
)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_3group_ref2_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()

# Test for punctuation (3 group; ref = SARS-like CoV) ----
pgls_pe <- gls(
  path ~ node + beta2 + beta3 + beta23_node,
  data = dat3c,
  correlation = vcv_lambda1
)
sum_pe <- summary(pgls_pe)
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_3group_ref3_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, 3, sep = ""))
cat("\n")
sink()
