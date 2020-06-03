# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20
library(nlme)  # v3.1-147


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat_out <- read.table("surya_R_output_outliers.txt")
colnames(dat_out) <- c("outlier")
dat_edit <- dat[!dat$genome %in% as.character(dat_out$outlier), ]
dat_edit <- dat_edit[, -1]

# Remove outliers from tree ----
tree_edit <- drop.tip(phy = tree, tip = as.character(dat_out$outlier))

# Define correlation matrix ----
vcv_lambda1 <- corPagel(value = 1, phy = tree_edit, fixed = TRUE)

# Test for punctuation ----
pgls_pe <- gls(path ~ node, data = dat_edit, correlation = vcv_lambda1)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
se_beta1 <- sum_pe$tTable[4]
p_val <- sum_pe$tTable[8]
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat_edit$path - mean(dat_edit$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pe$sigma^2
sink("surya_R_output_regression_punctuation_lambda1_no_outliers.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
