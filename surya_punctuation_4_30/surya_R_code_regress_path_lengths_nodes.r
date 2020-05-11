# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(phytools)  # v0.7-20
library(nlme)  # v3.1-147


# Read tree ----
tree <- read.nexus(
  file = "nextstrain_ncov_non-subsampled_2020-04-30_tree_v4.nex"
)

# Decompose tree into a variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Define correlation matrices ----
vcv_lambda0 <- corPagel(value = 0, phy = tree, fixed = TRUE)
vcv_lambda1 <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
meta <- read.delim(
  "nextstrain_ncov_non-subsampled_2020-04-30_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$Region)
colnames(dat)[4] <- "continent"
dat$continent <- as.factor(dat$continent)
rownames(dat) <- dat$genome

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
cat(paste("Intercept = ", beta0, "\n", sep = ""))
cat(paste("Slope = ", beta1, "\n", sep = ""))
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
cat(paste("Intercept = ", beta0, "\n", sep = ""))
cat(paste("Slope = ", beta1, "\n", sep = ""))
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
cat(paste("Intercept = ", beta0, "\n", sep = ""))
cat(paste("Slope = ", beta1, "\n", sep = ""))
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
cat(paste("Intercept = ", beta0, "\n", sep = ""))
cat(paste("Slope = ", beta1, "\n", sep = ""))
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

# Fit equal-slopes model ----
pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda1)
sum_eq <- summary(pgls_eq)
sse <- sum(pgls_eq$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda0)
sum_eq <- summary(pgls_eq)
sse <- sum(pgls_eq$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit equal-slopes model (2nd replicate) ----
pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda1)
sum_eq <- summary(pgls_eq)
sse <- sum(pgls_eq$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_eq$sigma^2
sink(
  "surya_R_output_regression_punctuation_equal_slopes_lambda1.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_eq
cat("\n")
sum_eq$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_eq <- gls(path ~ node + continent, data = dat, correlation = vcv_lambda0)
sum_eq <- summary(pgls_eq)
sse <- sum(pgls_eq$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_eq$sigma^2
sink(
  "surya_R_output_regression_punctuation_equal_slopes_lambda0.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_eq
cat("\n")
sum_eq$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit separate-slopes model ----
pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda1)
sum_sep <- summary(pgls_sep)
sse <- sum(pgls_sep$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda0)
sum_sep <- summary(pgls_sep)
sse <- sum(pgls_sep$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit separate-slopes model (2nd replicate) ----
pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda1)
sum_sep <- summary(pgls_sep)
sse <- sum(pgls_sep$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_sep$sigma^2
sink(
  "surya_R_output_regression_punctuation_separate_slopes_lambda1.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_sep
cat("\n")
sum_sep$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_sep <- gls(path ~ node * continent, data = dat, correlation = vcv_lambda0)
sum_sep <- summary(pgls_sep)
sse <- sum(pgls_sep$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_sep$sigma^2
sink(
  "surya_R_output_regression_punctuation_separate_slopes_lambda0.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_sep
cat("\n")
sum_sep$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Add the population size variables ----
dat$pop_size[dat$continent == "Africa"] <- 1340598113
dat$pop_size[dat$continent == "Asia"] <- 4641054786
dat$pop_size[dat$continent == "Europe"] <- 747636045
dat$pop_size[dat$continent == "North America"] <- 368092846
dat$pop_size[dat$continent == "Oceania"] <- 42677809
dat$pop_size[dat$continent == "South America"] <- 653739130

# Fit node count + pop size model ----
pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda1)
sum_pop <- summary(pgls_pop)
sse <- sum(pgls_pop$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda0)
sum_pop <- summary(pgls_pop)
sse <- sum(pgls_pop$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit node count + pop size model (2nd repliate) ----
pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda1)
sum_pop <- summary(pgls_pop)
sse <- sum(pgls_pop$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pop$sigma^2
sink("surya_R_output_regression_punctuation_pop_lambda1.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_pop
cat("\n")
sum_pop$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pop <- gls(path ~ node + pop_size, data = dat, correlation = vcv_lambda0)
sum_pop <- summary(pgls_pop)
sse <- sum(pgls_pop$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pop$sigma^2
sink("surya_R_output_regression_punctuation_pop_lambda0.txt", append = TRUE)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_pop
cat("\n")
sum_pop$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit node count x pop size model ----
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = vcv_lambda1
)
sum_pop_int <- summary(pgls_pop_int)
sse <- sum(pgls_pop_int$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = vcv_lambda0
)
sum_pop_int <- summary(pgls_pop_int)
sse <- sum(pgls_pop_int$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
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
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()

# Fit node count x pop size model (2nd replicate) ----
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = vcv_lambda1
)
sum_pop_int <- summary(pgls_pop_int)
sse <- sum(pgls_pop_int$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pop_int$sigma^2
sink(
  "surya_R_output_regression_punctuation_pop_interaction_lambda1.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_pop_int
cat("\n")
sum_pop_int$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
pgls_pop_int <- gls(
  path ~ node * pop_size,
  data = dat,
  correlation = vcv_lambda0
)
sum_pop_int <- summary(pgls_pop_int)
sse <- sum(pgls_pop_int$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sigma2 <- sum_pop_int$sigma^2
sink(
  "surya_R_output_regression_punctuation_pop_interaction_lambda0.txt",
  append = TRUE
)
cat("\n================================\n")
cat("Punctuation Test (2nd Replicate)\n")
cat("================================\n\n")
sum_pop_int
cat("\n")
sum_pop_int$tTable
cat("\n")
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), sep = ""))
cat("\n")
sink()
