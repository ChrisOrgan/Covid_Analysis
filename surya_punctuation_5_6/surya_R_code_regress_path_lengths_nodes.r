# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(caper)  # v1.0.1
library(phytools)  # v0.7.20
library(nlme)  # v3.1.147


# Read trees ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
## tree_rate <- read.nexus(file = "surya_tree_rate_v2.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat <- dat[match(tree$tip.label, dat$genome), ]
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
meta <- meta[match(dat$genome, meta$Strain), ]
dat <- cbind(dat, meta$Region)
colnames(dat)[4] <- "continent"
dat$continent <- as.factor(dat$continent)
rownames(dat) <- dat$genome
dat$pop_size[dat$continent == "Africa"] <- 1340598113
dat$pop_size[dat$continent == "Asia"] <- 4641054786
dat$pop_size[dat$continent == "Europe"] <- 747636045
dat$pop_size[dat$continent == "North America"] <- 368092846
dat$pop_size[dat$continent == "Oceania"] <- 42677809
dat$pop_size[dat$continent == "South America"] <- 653739130
dat_caper <- comparative.data(
  phy = tree,
  data = dat,
  names.col = "genome",
  force.root = TRUE
)

## # Decompose trees into variance-covariance matrices ----
## vcv <- vcv(phy = tree)
## vcv_rate <- vcv(phy = tree_rate)

## # Extract path lengths (diagonals of the matrix) ----
## path <- diag(vcv)
## path_rate <- diag(vcv_rate)

## # Extract nodes ----
## node <- NULL
## for (strain in 1:length(tree$tip.label)) {
##   node[strain] <- length(
##     nodepath(
##       phy = tree,
##       from = length(tree$tip.label) + 1,  # root
##       to = strain
##     )
##   ) - 2  # minus the root and terminal tip
## }
## node_rate <- NULL
## for (strain in 1:length(tree_rate$tip.label)) {
##   node_rate[strain] <- length(
##     nodepath(
##       phy = tree_rate,
##       from = length(tree_rate$tip.label) + 1,
##       to = strain
##     )
##   ) - 2
## }

## # Create data frames ----
## dat <- data.frame(path, node)
## dat_rate <- data.frame(path_rate, node_rate)

# Define variance-covariance matrices ----
vcv <- vcv(tree)
vcv_id <- diag(nrow = length(tree$tip.label))

# Define correlation matrices ----
cor_lambda1 <- corPagel(value = 1, phy = tree, fixed = TRUE)
cor_lambda <- corPagel(value = 0, phy = tree)
## vcv_lambda0_rate <- corPagel(value = 0, phy = tree_rate, fixed = TRUE)
## vcv_lambda1_rate <- corPagel(value = 1, phy = tree_rate, fixed = TRUE)

# Define variance weights ----
vf <- diag(vcv)

# Fit intercept-only model ----
pgls_int <- gls(
  path ~ 1,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_int <- summary(pgls_int)
mean_phylo <- as.numeric(pgls_int$coefficients[1])
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda1.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
sum_int$tTable
cat("\n")
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_int <- gls(
  path ~ 1,
  data = dat,
  correlation = cor_lambda,
  weights = varFixed(~vf),
  method = "ML"
)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
sum_int$tTable
cat("\n")
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_int <- gls(
  path ~ 1,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML",
  control = list(maxIter = 100, msMaxIter = 100),
  verbose = TRUE
)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda1_max_iter.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
sum_int$tTable
cat("\n")
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_int <- gls(
  path ~ 1,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_int <- summary(pgls_int)
mean_non <- as.numeric(pgls_int$coefficients[1])
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda0.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
sum_int$tTable
cat("\n")
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
trace(caper::pgls, edit = TRUE)
trace(caper::pgls.likelihood, edit = TRUE)
pgls_int_caper <- pgls(path ~ 1, data = dat_caper)
sum_int_caper <- summary(pgls_int_caper)
sigma2 <- sum_int_caper$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda1_caper.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
sum_int_caper
cat("\n")
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

# Test for punctuation ----
pgls_pe <- gls(
  path ~ node,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_pe <- summary(pgls_pe)
res_raw <- as.numeric(pgls_pe$residuals)
res_null <- as.matrix(dat$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
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
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_pe <- gls(
  path ~ node,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_pe <- summary(pgls_pe)
res_raw <- as.numeric(pgls_pe$residuals)
res_null_non <- as.matrix(dat$path - mean(dat$path))
sse <- as.numeric(t(res_raw) %*% solve(vcv_id) %*% res_raw)
sst <- as.numeric(t(res_null_non) %*% solve(vcv_id) %*% res_null_non)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

## # Test for punctuation (2nd replicate) ----
## pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda1)
## sum_pe <- summary(pgls_pe)
## beta0 <- as.numeric(pgls_pe$coefficients[1])
## beta1 <- as.numeric(pgls_pe$coefficients[2])
## se_beta1 <- sum_pe$tTable[4]
## p_val <- sum_pe$tTable[8]
## sse <- sum(pgls_pe$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pe$sigma^2
## sink("surya_R_output_regression_punctuation_lambda1.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## summary(pgls_pe)
## cat("\n")
## sum_pe$tTable
## cat("\n")
## cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
## cat(paste("R-squared = ", r2, 3, "\n", sep = ""))
## cat(paste("Variance = ", sigma2, sep = ""))
## cat("\n")
## sink()
## pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda0)
## sum_pe <- summary(pgls_pe)
## beta0 <- as.numeric(pgls_pe$coefficients[1])
## beta1 <- as.numeric(pgls_pe$coefficients[2])
## se_beta1 <- sum_pe$tTable[4]
## p_val <- sum_pe$tTable[8]
## sse <- sum(pgls_pe$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pe$sigma^2
## sink("surya_R_output_regression_punctuation_lambda0.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## summary(pgls_pe)
## cat("\n")
## sum_pe$tTable
## cat("\n")
## cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
## cat(paste("R-squared = ", r2, "\n", sep = ""))
## cat(paste("Variance = ", sigma2, sep = ""))
## cat("\n")
## sink()

## # Fit intercept-only model (2nd replicate) ----
## pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda1)
## sum_int <- summary(pgls_int)
## sigma2 <- sum_int$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_intercept_lambda1.txt",
##   append = TRUE
## )
## cat("\n================================================\n")
## cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
## cat("================================================\n\n")
## summary(pgls_int)
## cat("\n")
## sum_int$tTable
## cat("\n")
## cat(paste("Variance = ", sigma2, sep = ""))
## cat("\n")
## sink()
## pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda0)
## sum_int <- summary(pgls_int)
## sigma2 <- sum_int$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_intercept_lambda0.txt",
##   append = TRUE
## )
## cat("\n================================================\n")
## cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
## cat("================================================\n\n")
## summary(pgls_int)
## cat("\n")
## sum_int$tTable
## cat("\n")
## cat(paste("Variance = ", sigma2, sep = ""))
## cat("\n")
## sink()

## # Test for punctuation (rate) ----
## pgls_pe_rate <- gls(
##   path_rate ~ node_rate,
##   data = dat_rate,
##   correlation = vcv_lambda1_rate
## )
## sum_pe_rate <- summary(pgls_pe_rate)
## beta0_rate <- as.numeric(pgls_pe_rate$coefficients[1])
## beta1_rate <- as.numeric(pgls_pe_rate$coefficients[2])
## se_beta1_rate <- sum_pe_rate$tTable[4]
## p_val_rate <- sum_pe_rate$tTable[8]
## sse_rate <- sum(pgls_pe_rate$residuals^2)
## sst_rate <- sum((dat_rate$path_rate - mean(dat_rate$path_rate))^2)
## r2_rate <- 1 - sse_rate/sst_rate
## sigma2_rate <- sum_pe_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_lambda1.txt")
## cat("================\n")
## cat("Punctuation Test\n")
## cat("================\n\n")
## summary(pgls_pe_rate)
## cat("\n")
## cat(paste("Intercept = ", round(beta0_rate, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1_rate, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1_rate, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val_rate, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2_rate, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()
## pgls_pe_rate <- gls(
##   path_rate ~ node_rate,
##   data = dat_rate,
##   correlation = vcv_lambda0_rate
## )
## sum_pe_rate <- summary(pgls_pe_rate)
## beta0_rate <- as.numeric(pgls_pe_rate$coefficients[1])
## beta1_rate <- as.numeric(pgls_pe_rate$coefficients[2])
## se_beta1_rate <- sum_pe_rate$tTable[4]
## p_val_rate <- sum_pe_rate$tTable[8]
## sse_rate <- sum(pgls_pe_rate$residuals^2)
## sst_rate <- sum((dat_rate$path_rate - mean(dat_rate$path_rate))^2)
## r2_rate <- 1 - sse_rate/sst_rate
## sigma2_rate <- sum_pe_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_lambda0.txt")
## cat("================\n")
## cat("Punctuation Test\n")
## cat("================\n\n")
## summary(pgls_pe_rate)
## cat("\n")
## cat(paste("Intercept = ", round(beta0_rate, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1_rate, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1_rate, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val_rate, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2_rate, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()

## # Test for punctuation (rate; 2nd replicate) ----
## pgls_pe_rate <- gls(
##   path_rate ~ node_rate,
##   data = dat_rate,
##   correlation = vcv_lambda1_rate
## )
## sum_pe_rate <- summary(pgls_pe_rate)
## beta0_rate <- as.numeric(pgls_pe_rate$coefficients[1])
## beta1_rate <- as.numeric(pgls_pe_rate$coefficients[2])
## se_beta1_rate <- sum_pe_rate$tTable[4]
## p_val_rate <- sum_pe_rate$tTable[8]
## sse_rate <- sum(pgls_pe_rate$residuals^2)
## sst_rate <- sum((dat_rate$path_rate - mean(dat_rate$path_rate))^2)
## r2_rate <- 1 - sse_rate/sst_rate
## sigma2_rate <- sum_pe_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_lambda1.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## summary(pgls_pe_rate)
## cat("\n")
## cat(paste("Intercept = ", round(beta0_rate, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1_rate, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1_rate, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val_rate, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2_rate, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()
## pgls_pe_rate <- gls(
##   path_rate ~ node_rate,
##   data = dat_rate,
##   correlation = vcv_lambda0_rate
## )
## sum_pe_rate <- summary(pgls_pe_rate)
## beta0_rate <- as.numeric(pgls_pe_rate$coefficients[1])
## beta1_rate <- as.numeric(pgls_pe_rate$coefficients[2])
## se_beta1_rate <- sum_pe_rate$tTable[4]
## p_val_rate <- sum_pe_rate$tTable[8]
## sse_rate <- sum(pgls_pe_rate$residuals^2)
## sst_rate <- sum((dat_rate$path_rate - mean(dat_rate$path_rate))^2)
## r2_rate <- 1 - sse_rate/sst_rate
## sigma2_rate <- sum_pe_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_lambda0.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## summary(pgls_pe_rate)
## cat("\n")
## cat(paste("Intercept = ", round(beta0_rate, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1_rate, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1_rate, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val_rate, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2_rate, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()

## # Fit intercept-only model (rate) ----
## pgls_int_rate <- gls(
##   path_rate ~ 1,
##   data = dat_rate,
##   correlation = vcv_lambda1_rate
## )
## sum_int_rate <- summary(pgls_int_rate)
## sigma2_rate <- sum_int_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_intercept_lambda1.txt")
## cat("=================================\n")
## cat("Punctuation Test (Intercept-Only)\n")
## cat("=================================\n\n")
## summary(pgls_int_rate)
## cat("\n")
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()
## pgls_int_rate <- gls(
##   path_rate ~ 1,
##   data = dat_rate,
##   correlation = vcv_lambda0_rate
## )
## sum_int_rate <- summary(pgls_int_rate)
## sigma2_rate <- sum_int_rate$sigma^2
## sink("surya_R_output_regression_punctuation_rate_intercept_lambda0.txt")
## cat("=================================\n")
## cat("Punctuation Test (Intercept-Only)\n")
## cat("=================================\n\n")
## summary(pgls_int_rate)
## cat("\n")
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()

## # Fit intercept-only model (rate; 2nd replicate) ----
## pgls_int_rate <- gls(
##   path_rate ~ 1,
##   data = dat_rate,
##   correlation = vcv_lambda1_rate
## )
## sum_int_rate <- summary(pgls_int_rate)
## sigma2_rate <- sum_int_rate$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_rate_intercept_lambda1.txt",
##   append = TRUE
## )
## cat("\n================================================\n")
## cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
## cat("================================================\n\n")
## summary(pgls_int_rate)
## cat("\n")
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()
## pgls_int_rate <- gls(
##   path_rate ~ 1,
##   data = dat_rate,
##   correlation = vcv_lambda0_rate
## )
## sum_int_rate <- summary(pgls_int_rate)
## sigma2_rate <- sum_int_rate$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_rate_intercept_lambda0.txt",
##   append = TRUE
## )
## cat("\n================================================\n")
## cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
## cat("================================================\n\n")
## summary(pgls_int_rate)
## cat("\n")
## cat(paste("Variance = ", round(sigma2_rate, 3), sep = ""))
## cat("\n")
## sink()

# Fit equal-slopes model ----
pgls_eq <- gls(
  path ~ node + continent,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_eq <- summary(pgls_eq)
res_raw <- as.numeric(pgls_eq$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_eq$sigma^2
sink("surya_R_output_regression_punctuation_equal_slopes_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_eq
cat("\n")
sum_eq$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_eq <- gls(
  path ~ node + continent,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_eq <- summary(pgls_eq)
res_raw <- as.numeric(pgls_eq$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_id) %*% res_raw)
sst <- as.numeric(t(res_null_non) %*% solve(vcv_id) %*% res_null_non)
r2 <- 1 - sse/sst
sigma2 <- sum_eq$sigma^2
sink("surya_R_output_regression_punctuation_equal_slopes_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_eq
cat("\n")
sum_eq$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

## # Fit equal-slopes model (2nd replicate) ----
## pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda1)
## sum_eq <- summary(pgls_eq)
## sse <- sum(pgls_eq$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_eq$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_equal_slopes_lambda1.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_eq
## cat("\n")
## sum_eq$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda0)
## sum_eq <- summary(pgls_eq)
## sse <- sum(pgls_eq$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_eq$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_equal_slopes_lambda0.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_eq
## cat("\n")
## sum_eq$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()

# Fit separate-slopes model ----
pgls_sep <- gls(
  path ~ node * continent,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_sep <- summary(pgls_sep)
res_raw <- as.numeric(pgls_sep$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_sep$sigma^2
sink("surya_R_output_regression_punctuation_separate_slopes_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_sep
cat("\n")
sum_sep$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_sep <- gls(
  path ~ node * continent,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_sep <- summary(pgls_sep)
res_raw <- as.numeric(pgls_sep$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_id) %*% res_raw)
sst <- as.numeric(t(res_null_non) %*% solve(vcv_id) %*% res_null_non)
r2 <- 1 - sse/sst
sigma2 <- sum_sep$sigma^2
sink("surya_R_output_regression_punctuation_separate_slopes_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_sep
cat("\n")
sum_sep$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

## # Fit separate-slopes model (2nd replicate) ----
## pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda1)
## sum_sep <- summary(pgls_sep)
## sse <- sum(pgls_sep$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_sep$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_separate_slopes_lambda1.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_sep
## cat("\n")
## sum_sep$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda0)
## sum_sep <- summary(pgls_sep)
## sse <- sum(pgls_sep$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_sep$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_separate_slopes_lambda0.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_sep
## cat("\n")
## sum_sep$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()

# Fit node count + pop size model ----
pgls_pop <- gls(
  path ~ node + pop_size,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_pop <- summary(pgls_pop)
res_raw <- as.numeric(pgls_pop$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pop$sigma^2
sink("surya_R_output_regression_punctuation_pop_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_pop
cat("\n")
sum_pop$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_pop <- gls(
  path ~ node + pop_size,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_pop <- summary(pgls_pop)
res_raw <- as.numeric(pgls_pop$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_id) %*% res_raw)
sst <- as.numeric(t(res_null_non) %*% solve(vcv_id) %*% res_null_non)
r2 <- 1 - sse/sst
sigma2 <- sum_pop$sigma^2
sink("surya_R_output_regression_punctuation_pop_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_pop
cat("\n")
sum_pop$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

## # Fit node count + pop size model (2nd repliate) ----
## pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda1)
## sum_pop <- summary(pgls_pop)
## sse <- sum(pgls_pop$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pop$sigma^2
## sink("surya_R_output_regression_punctuation_pop_lambda1.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_pop
## cat("\n")
## sum_pop$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda0)
## sum_pop <- summary(pgls_pop)
## sse <- sum(pgls_pop$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pop$sigma^2
## sink("surya_R_output_regression_punctuation_pop_lambda0.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_pop
## cat("\n")
## sum_pop$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()

# Fit node count x pop size model ----
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = cor_lambda1,
  weights = varFixed(~vf),
  method = "ML"
)
sum_pop_int <- summary(pgls_pop_int)
res_raw <- as.numeric(pgls_pop_int$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pop_int$sigma^2
sink("surya_R_output_regression_punctuation_pop_interaction_lambda1.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_pop_int
cat("\n")
sum_pop_int$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum_pop_int <- summary(pgls_pop_int)
res_raw <- as.numeric(pgls_pop_int$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_id) %*% res_raw)
sst <- as.numeric(t(res_null_non) %*% solve(vcv_id) %*% res_null_non)
r2 <- 1 - sse/sst
sigma2 <- sum_pop_int$sigma^2
sink("surya_R_output_regression_punctuation_pop_interaction_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
sum_pop_int
cat("\n")
sum_pop_int$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()

## # Fit node count x pop size model (2nd replicate) ----
## pgls_pop_int <- gls(
##   path ~ node * pop_size,
##   data = dat,
##   correlation = vcv_lambda1
## )
## sum_pop_int <- summary(pgls_pop_int)
## sse <- sum(pgls_pop_int$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pop_int$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_pop_interaction_lambda1.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_pop_int
## cat("\n")
## sum_pop_int$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## pgls_pop_int <- gls(
##   path ~ node * pop_size,
##   data = dat,
##   correlation = vcv_lambda0
## )
## sum_pop_int <- summary(pgls_pop_int)
## sse <- sum(pgls_pop_int$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pop_int$sigma^2
## sink(
##   "surya_R_output_regression_punctuation_pop_interaction_lambda0.txt",
##   append = TRUE
## )
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## sum_pop_int
## cat("\n")
## sum_pop_int$tTable
## cat("\n")
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
