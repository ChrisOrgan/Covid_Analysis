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
corr <- corPagel(value = 1, phy = tree, fixed = FALSE)

# Define variance weights ----
w <- diag(vcv)

# Fit a model with node count (alternative) ----
pgls_alt <- gls(
  path ~ time + node,
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
sum_alt <- summary(pgls_alt)
sink("sars_cov_2_output_r_regression_path_time_node_lambda_estimated.txt")
cat("========================\n")
cat("Regression (Alternative)\n")
cat("========================\n\n")
summary(pgls_alt)
cat("\n")
sum_alt$tTable
cat("\n")
sink()
