# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(car)
library(nlme)
library(phytools)


# Set memory limit ----
memory.limit(size = 10000000)

# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2021_march_tree_v3_12618.nex")

# Read data ----
dat <- read.table(
  "sars_cov_2_2021_march_data_12618.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)
dat <- dat[match(tree$tip.label, rownames(dat)), ]
dat$b117 <- as.factor(dat$b117)

# Define variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Define correlation matrix ----
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Define variance weights ----
w <- diag(vcv)

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
sig2_int <- sum_int$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_12618.txt")
cat("===========================\n")
cat("Regression (Intercept-Only)\n")
cat("===========================\n\n")
summary(pgls_int)
cat("\n")
sum_int$tTable
cat("\n")
cat(paste("Variance = ", sig2_int, sep = ""))
cat("\n")
sink()

# Fit a model without node count (null) ----
pgls_null <- gls(
  path ~ time,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_null <- summary(pgls_null)
res_raw_null <- as.numeric(pgls_null$residuals)
res_null <- as.matrix(dat$path - mean_phylo)
sse_null <-
  as.numeric(t(res_raw_null) %*% solve(vcv, tol = 2e-18) %*% res_raw_null)
sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
r2_null <- 1 - sse_null/sst
sig2_null <- sum_null$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_time_12618.txt")
cat("=================\n")
cat("Regression (Null)\n")
cat("=================\n\n")
summary(pgls_null)
cat("\n")
sum_null$tTable
cat("\n")
cat(paste("R-squared = ", r2_null, "\n", sep = ""))
cat(paste("Variance = ", sig2_null, "\n", sep = ""))
cat(paste("SSE = ", sse_null, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model node count, not accounting for B.1.1.7 (alternative) ----
pgls_alt <- gls(
  path ~ time + node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_alt <- summary(pgls_alt)
res_raw_alt <- as.numeric(pgls_alt$residuals)
sse_alt <-
  as.numeric(t(res_raw_alt) %*% solve(vcv, tol = 2e-18) %*% res_raw_alt)
r2_alt <- 1 - sse_alt/sst
partial_r2_alt <- (sse_null-sse_alt) / sse_null
sig2_alt <- sum_alt$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_time_node_12618.txt")
cat("========================\n")
cat("Regression (alternative)\n")
cat("========================\n\n")
summary(pgls_alt)
cat("\n")
sum_alt$tTable
cat("\n")
cat(paste("R-squared = ", r2_alt, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_alt, "\n", sep = ""))
cat(paste("Variance = ", sig2_alt, "\n", sep = ""))
cat(paste("SSE = ", sse_alt, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Calculate variance inflation factors (VIFs) ----
models <- NULL
models[[1]] <- pgls_alt
sink("sars_cov_2_2021_march_output_r_variance_inflation_factors_12618.txt")
cat("==========================\n")
cat("Variance Inflation Factors\n")
cat("==========================\n\n")
for (model in 1:length(models)) {
  print(vif(models[[model]]))
  cat("")
}
sink()

# Fit a model without node count, accounting for B.1.1.7 (null) ----
pgls_nullb <- gls(
  path ~ time + b117,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_nullb <- summary(pgls_nullb)
res_raw_nullb <- as.numeric(pgls_nullb$residuals)
sse_nullb <-
  as.numeric(t(res_raw_nullb) %*% solve(vcv, tol = 2e-18) %*% res_raw_nullb)
r2_nullb <- 1 - sse_nullb/sst
partial_r2_nullb <- (sse_null-sse_nullb) / sse_null
sig2_nullb <- sum_nullb$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_time_b117_12618.txt")
cat("=================\n")
cat("Regression (Null)\n")
cat("=================\n\n")
summary(pgls_nullb)
cat("\n")
sum_nullb$tTable
cat("\n")
cat(paste("R-squared = ", r2_nullb, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_nullb, "\n", sep = ""))
cat(paste("Variance = ", sig2_nullb, "\n", sep = ""))
cat(paste("SSE = ", sse_nullb, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count, accounting for B.1.1.7 (alternative) ----
pgls_altb <- gls(
  path ~ time + b117 + node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_altb <- summary(pgls_altb)
res_raw_altb <- as.numeric(pgls_altb$residuals)
sse_altb <-
  as.numeric(t(res_raw_altb) %*% solve(vcv, tol = 2e-18) %*% res_raw_altb)
r2_altb <- 1 - sse_altb/sst
partial_r2_altb <- (sse_nullb-sse_altb) / sse_nullb
sig2_altb <- sum_altb$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_time_b117_node_12618.txt")
cat("========================\n")
cat("Regression (alternative)\n")
cat("========================\n\n")
summary(pgls_altb)
cat("\n")
sum_altb$tTable
cat("\n")
cat(paste("R-squared = ", r2_altb, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_altb, "\n", sep = ""))
cat(paste("Variance = ", sig2_altb, "\n", sep = ""))
cat(paste("SSE = ", sse_altb, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count and an interaction, accounting for B.1.1.7
# (alternative) ----
pgls_altb2 <- gls(
  path ~ time + b117 * node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_altb2 <- summary(pgls_altb2)
res_raw_altb2 <- as.numeric(pgls_altb2$residuals)
sse_altb2 <-
  as.numeric(t(res_raw_altb2) %*% solve(vcv, tol = 2e-18) %*% res_raw_altb2)
r2_altb2 <- 1 - sse_altb2/sst
partial_r2_altb2 <- (sse_altb-sse_altb2) / sse_altb
sig2_altb2 <- sum_altb2$sigma^2
sink(
  "sars_cov_2_2021_march_output_r_regression_path_time_b117_node_interaction_12618.txt"
)
cat("========================\n")
cat("Regression (alternative)\n")
cat("========================\n\n")
summary(pgls_altb2)
cat("\n")
sum_altb2$tTable
cat("\n")
cat(paste("R-squared = ", r2_altb2, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_altb2, "\n", sep = ""))
cat(paste("Variance = ", sig2_altb2, "\n", sep = ""))
cat(paste("SSE = ", sse_altb2, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model without node count, accounting for B.1.1.7 (null) ----
pgls_nullc <- gls(
  path ~ time * b117,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_nullc <- summary(pgls_nullc)
res_raw_nullc <- as.numeric(pgls_nullc$residuals)
sse_nullc <-
  as.numeric(t(res_raw_nullc) %*% solve(vcv, tol = 2e-18) %*% res_raw_nullc)
r2_nullc <- 1 - sse_nullc/sst
partial_r2_nullc <- (sse_nullb-sse_nullc) / sse_nullb
sig2_nullc <- sum_nullc$sigma^2
sink("sars_cov_2_2021_march_output_r_regression_path_time_b117_interaction_12618.txt")
cat("=================\n")
cat("Regression (Null)\n")
cat("=================\n\n")
summary(pgls_nullc)
cat("\n")
sum_nullc$tTable
cat("\n")
cat(paste("R-squared = ", r2_nullc, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_nullc, "\n", sep = ""))
cat(paste("Variance = ", sig2_nullc, "\n", sep = ""))
cat(paste("SSE = ", sse_nullc, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count, accounting for B.1.1.7 (alternatuve) ----
pgls_altc <- gls(
  path ~ time * b117 + node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_altc <- summary(pgls_altc)
res_raw_altc <- as.numeric(pgls_altc$residuals)
sse_altc <-
  as.numeric(t(res_raw_altc) %*% solve(vcv, tol = 2e-18) %*% res_raw_altc)
r2_altc <- 1 - sse_altc/sst
partial_r2_altc <- (sse_nullc-sse_altc) / sse_nullc
sig2_altc <- sum_altc$sigma^2
sink(
  "sars_cov_2_2021_march_output_r_regression_path_time_b117_interaction_node_12618.txt"
)
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_altc)
cat("\n")
sum_altc$tTable
cat("\n")
cat(paste("R-squared = ", r2_altc, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_altc, "\n", sep = ""))
cat(paste("Variance = ", sig2_altc, "\n", sep = ""))
cat(paste("SSE = ", sse_altc, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count, accounting for B.1.1.7 (alternatuve) ----
pgls_altc2 <- gls(
  path ~ time * b117 + node + b117*node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_altc2 <- summary(pgls_altc2)
res_raw_altc2 <- as.numeric(pgls_altc2$residuals)
sse_altc2 <-
  as.numeric(t(res_raw_altc2) %*% solve(vcv, tol = 2e-18) %*% res_raw_altc2)
r2_altc2 <- 1 - sse_altc2/sst
partial_r2_altc2 <- (sse_altc-sse_altc2) / sse_altc
sig2_altc2 <- sum_altc2$sigma^2
sink(
  "sars_cov_2_2021_march_output_r_regression_path_time_b117_interaction_node_interaction_wb117_12618.txt"
)
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_altc2)
cat("\n")
sum_altc2$tTable
cat("\n")
cat(paste("R-squared = ", r2_altc2, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_altc2, "\n", sep = ""))
cat(paste("Variance = ", sig2_altc2, "\n", sep = ""))
cat(paste("SSE = ", sse_altc2, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()
