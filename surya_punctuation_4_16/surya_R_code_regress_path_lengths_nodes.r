# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20
library(nlme)  # v3.1-147


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")

# Decompose the tree into a variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Extract path lengths (diagonals of the matrix) ----
path <- diag(vcv)

# Extract nodes ----
node <- NULL
for (strain in 1:length(tree$tip.label)) {
  node[strain] <- length(
    nodepath(
      phy = tree,
      from = length(tree$tip.label) + 1,  # root
      to = strain
    )
  ) - 2  # minus the root and terminal tip
}

# Create data frame ----
dat <- data.frame(path, node)

# Define correlation matrices ----
vcv_lambda0 <- corPagel(value = 0, phy = tree, fixed = TRUE)
vcv_lambda1 <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Test for punctuation ----
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
se_beta1 <- sum_pe$tTable[4]
p_val <- sum_pe$tTable[8]
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
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda0)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
se_beta1 <- sum_pe$tTable[4]
p_val <- sum_pe$tTable[8]
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda0.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Test for punctuation (2nd replicate) ----
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
se_beta1 <- sum_pe$tTable[4]
p_val <- sum_pe$tTable[8]
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda1.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
summary(pgls_pe)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv_lambda0)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
se_beta1 <- sum_pe$tTable[4]
p_val <- sum_pe$tTable[8]
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda0.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
summary(pgls_pe)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit intercept-only model ----
pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda1)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda1.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda0)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink("surya_R_output_regression_punctuation_intercept_lambda0.txt")
cat("=================================\n")
cat("Punctuation Test (Intercept-Only)\n")
cat("=================================\n\n")
summary(pgls_int)
cat("\n")
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit intercept-only model (2nd replicate) ----
pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda1)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink(
  "surya_R_output_regression_punctuation_intercept_lambda1.txt",
  append = TRUE
)
cat("\n================================================\n")
cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
cat("================================================\n\n")
summary(pgls_int)
cat("\n")
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_int <- gls(path ~ 1, data = dat, correlation = vcv_lambda0)
sum_int <- summary(pgls_int)
sigma2 <- sum_int$sigma^2
sink(
  "surya_R_output_regression_punctuation_intercept_lambda0.txt",
  append = TRUE
)
cat("\n================================================\n")
cat("Punctuation Test (Intercept-Only; 2nd Replicate)\n")
cat("================================================\n\n")
summary(pgls_int)
cat("\n")
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
