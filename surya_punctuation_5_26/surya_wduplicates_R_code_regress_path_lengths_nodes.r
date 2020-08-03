# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7.20
library(nlme)  # v3.1.147


# Read tree ----
tree <- read.nexus(file = "tanner_wduplicates_tree.nex")

# Define variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Define correlation matrix ----
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Define variance weights ----
w <- diag(vcv)

# Load and prepare data ----
dat <- read.table(
  "surya_wduplicates_R_data_path_lengths_nodes_region.txt",
  sep = "\t"
)
colnames(dat) <- c("genome", "path", "node", "continent")
rownames(dat) <- dat$genome
dat$pop_size[dat$continent == "Africa"] <- 1340598113
dat$pop_size[dat$continent == "Asia"] <- 4641054786
dat$pop_size[dat$continent == "Europe"] <- 747636045
dat$pop_size[dat$continent == "North America"] <- 368092846
dat$pop_size[dat$continent == "Oceania"] <- 42677809
dat$pop_size[dat$continent == "South America"] <- 653739130
dat <- dat[match(tree$tip.label, dat$genome), ]

# Fit intercept-only model ----
pgls_int <- gls(
  path ~ 1,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_int <- summary(pgls_int)
mean_phylo <- as.numeric(pgls_int$coefficients[1])
sigma2 <- sum_int$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_intercept_lambda1.txt")
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

# Test for punctuation ----
pgls_pe <- gls(
  path ~ node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_pe <- summary(pgls_pe)
res_raw <- as.numeric(pgls_pe$residuals)
res_null <- as.matrix(dat$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_lambda1.txt")
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

# Fit equal-slopes model ----
pgls_eq <- gls(
  path ~ node + continent,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_eq <- summary(pgls_eq)
res_raw <- as.numeric(pgls_eq$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_eq$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_equal_slopes_lambda1.txt")
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

# Fit separate-slopes model ----
pgls_sep <- gls(
  path ~ node * continent,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_sep <- summary(pgls_sep)
res_raw <- as.numeric(pgls_sep$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_sep$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_separate_slopes_lambda1.txt")
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

# Fit node count + pop size model ----
pgls_pop <- gls(
  path ~ node + pop_size,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_pop <- summary(pgls_pop)
res_raw <- as.numeric(pgls_pop$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pop$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_pop_lambda1.txt")
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

# Fit node count x pop size model ----
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_pop_int <- summary(pgls_pop_int)
res_raw <- as.numeric(pgls_pop_int$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pop_int$sigma^2
sink("surya_wduplicates_R_output_regression_punctuation_pop_interaction_lambda1.txt")
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
