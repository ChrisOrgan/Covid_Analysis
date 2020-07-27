# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7.20
library(nlme)  # v3.1.147


# Read tree ----
tree <- read.nexus(file = "surya_cipres_tree_collapsed.nex")

# Load and prepare data ----
dat <- read.table("surya_cipres_R_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat_out <- read.table("surya_cipres_R_output_outliers.txt")
colnames(dat_out) <- c("outlier")
dat_edit <- dat[!dat$genome %in% as.character(dat_out$outlier), ]

# Remove outliers from tree ----
tree_edit <- drop.tip(phy = tree, tip = as.character(dat_out$outlier))

# Re-order data ----
dat_edit <- dat_edit[match(tree_edit$tip.label, dat_edit$genome), ]

# Define variance-covariance matrix ----
vcv <- vcv(phy = tree_edit)

# Define correlation matrix ----
corr <- corPagel(value = 1, phy = tree_edit, fixed = TRUE)

# Define variance weights ----
w <- diag(vcv)

# Fit intercept-only model ----
pgls_int <- gls(
  path ~ 1,
  data = dat_edit,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_int <- summary(pgls_int)
mean_phylo <- as.numeric(pgls_int$coefficients[1])
sigma2 <- sum_int$sigma^2
sink("surya_cipres_R_output_regression_punctuation_intercept_lambda1_no_outliers.txt")
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
  data = dat_edit,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_pe <- summary(pgls_pe)
res_raw <- as.numeric(pgls_pe$residuals)
res_null <- as.matrix(dat_edit$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_cipres_R_output_regression_punctuation_lambda1_no_outliers.txt")
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
