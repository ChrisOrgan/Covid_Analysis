# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(car)
library(nlme)
library(phytools)


# Set memory limit ----
memory.limit(size = 10000000)

# Read tree ----
tree <- read.nexus(file = "sars_cov_2_tree_mol_v2_15019.nex")

# Read data ----
dat <- read.table(
  "sars_cov_2_data.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)
dat <- dat[match(tree$tip.label, rownames(dat)), ]

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
sink("sars_cov_2_output_r_regression_path.txt")
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
sink("sars_cov_2_output_r_regression_path_time.txt")
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

# Fit a model with node count (alternative) ----
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
sink("sars_cov_2_output_r_regression_path_time_node.txt")
cat("========================\n")
cat("Regression (Alternative)\n")
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

# Fit a model with node count and continent ----
pgls_con <- gls(
  path ~ time + node + continent,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_con <- summary(pgls_con)
res_raw_con <- as.numeric(pgls_con$residuals)
sse_con <-
  as.numeric(t(res_raw_con) %*% solve(vcv, tol = 2e-18) %*% res_raw_con)
r2_con <- 1 - sse_con/sst
partial_r2_con <- (sse_alt-sse_con) / sse_alt
sig2_con <- sum_con$sigma^2
sink("sars_cov_2_output_r_regression_path_time_node_continent.txt")
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_con)
cat("\n")
sum_con$tTable
cat("\n")
cat(paste("R-squared = ", r2_con, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_con, "\n", sep = ""))
cat(paste("Variance = ", sig2_con, "\n", sep = ""))
cat(paste("SSE = ", sse_con, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count and continent plus an interaction ----
pgls_convar <- gls(
  path ~ time + node * continent,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_convar <- summary(pgls_convar)
res_raw_convar <- as.numeric(pgls_convar$residuals)
sse_convar <-
  as.numeric(t(res_raw_convar) %*% solve(vcv, tol = 2e-18) %*% res_raw_convar)
r2_convar <- 1 - sse_convar/sst
partial_r2_convar <- (sse_con-sse_convar) / sse_con
sig2_convar <- sum_convar$sigma^2
sink("sars_cov_2_output_r_regression_path_time_node_continent_interaction.txt")
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_convar)
cat("\n")
sum_convar$tTable
cat("\n")
cat(paste("R-squared = ", r2_convar, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_convar, "\n", sep = ""))
cat(paste("Variance = ", sig2_convar, "\n", sep = ""))
cat(paste("SSE = ", sse_convar, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Fit a model with node count and an interaction with time ----
pgls_time <- gls(
  path ~ time * node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_time <- summary(pgls_time)
res_raw_time <- as.numeric(pgls_time$residuals)
sse_time <-
  as.numeric(t(res_raw_time) %*% solve(vcv, tol = 2e-18) %*% res_raw_time)
r2_time <- 1 - sse_time/sst
partial_r2_time <- (sse_alt-sse_time) / sse_alt
sig2_time <- sum_time$sigma^2
sink("sars_cov_2_output_r_regression_path_time_node_interaction_time.txt")
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_time)
cat("\n")
sum_time$tTable
cat("\n")
cat(paste("R-squared = ", r2_time, "\n", sep = ""))
cat(paste("Partial R-squared = ", partial_r2_time, "\n", sep = ""))
cat(paste("Variance = ", sig2_time, "\n", sep = ""))
cat(paste("SSE = ", sse_time, "\n", sep = ""))
cat(paste("SST = ", sst, sep = ""))
cat("\n")
sink()

# Calculate variance inflation factors (VIFs) ----
models <- NULL
models[[1]] <- pgls_alt
sink("sars_cov_2_output_r_variance_inflation_factors.txt")
cat("==========================\n")
cat("Variance Inflation Factors\n")
cat("==========================\n\n")
for (model in 1:length(models)) {
  print(vif(models[[model]]))
  cat("")
}
sink()
