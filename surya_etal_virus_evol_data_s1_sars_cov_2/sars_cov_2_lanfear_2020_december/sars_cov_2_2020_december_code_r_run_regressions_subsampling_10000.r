# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# library(ape)
library(lubridate)
library(nlme)
library(phytools)


# Set memory limit ----
memory.limit(size = 6000000)

# Read tree ----
tree <- read.nexus(
  file = "EXCLUDE_sars_cov_2_lanfear_2020_december_tree_v2_filtered.nex"
)

# Read metadata ----
meta <- read.csv(
  "sars_cov_2_2020_december_metadata_v2_filtered.txt",
  sep = "\t",
  header = TRUE
)
meta <- meta[match(tree$tip.label, meta$id), ]

# Subsample data and test for punctuation for each subsample ----
list_delta <- list_beta0 <- list_beta1 <- list_beta2 <- list_se2 <-
  list_p_val <- list_r2 <- list_partial_r2 <- list_var <- list_punc <-
  list_dbic <- list_n <- NULL
for (subs in 1:10) {
  subsample <- sample(tree$tip.label, size = 10000)
  ## Subset tree and metadata
  tree_subs <- keep.tip(phy = tree, tip = subsample)
  meta_subs <- meta[meta$id %in% subsample, ]
  ### Remove duplicate genomes
  vcv_subs <- vcv(phy = tree_subs)
  path_subs <- diag(vcv_subs)
  meta_subs <- meta_subs[match(names(path_subs), meta_subs$id), ]
  meta_subs$path_subs <- path_subs
  node_path_subs <- nodepath(phy = tree_subs)
  node_path_subs <- lapply(node_path_subs, function(x) x[-length(x)])
  node_path_subs <- unlist(
    lapply(node_path_subs, function(x) paste(x, collapse = ""))
  )
  meta_subs$node_path_subs <- node_path_subs
  meta_subs <- meta_subs[
    !(
      duplicated(meta_subs[, c("path_subs", "node_path_subs")]) |
      duplicated(meta_subs[, c("path_subs", "node_path_subs")], fromLast = TRUE)
    ),
  ]
  tree_subs <- keep.tip(phy = tree_subs, tip = as.character(meta_subs$id))
  #### Add random noise in case not all duplicates were removed
  tree_subs$edge.length <-
    tree_subs$edge.length +
    runif(
      n = length(tree_subs$edge.length),
      min = 0,
      max = 1e-11
    )
  list_n[subs] <- length(tree_subs$tip.label)
  ### (end)
  vcv <- vcv(phy = tree_subs)
  corr <- corPagel(value = 1, phy = tree_subs, fixed = TRUE)
  w <- diag(vcv)
  ## Extract and prepare data
  path <- diag(vcv)
  time <- decimal_date(ymd(meta_subs$date))
  names(time) <- meta_subs$id
  time <- time[match(names(path), names(time))]
  node <- unlist(lapply(nodepath(phy = tree_subs), function(x) length(x)-2))
  names(node) <- tree_subs$tip.label
  node <- node[match(names(path), names(node))]
  dat_subs <- data.frame(path, time, node)
  dat_subs <- dat_subs[match(tree_subs$tip.label, rownames(dat_subs)), ]
  ## Test for the node-density artifact
  pgls_nda <- gls(
    log(node+1) ~ log(path+1e-07),
    data = dat_subs,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  beta <- exp(as.numeric(pgls_nda$coefficients[1]))
  list_delta[subs] <- delta <- as.numeric(pgls_nda$coefficients[2])
  ## Run regressions
  pgls_int <- gls(
    path ~ 1,
    data = dat_subs,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  mean_phylo <- as.numeric(pgls_int$coefficients[1])
  pgls_null <- gls(
    path ~ time,
    data = dat_subs,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  sum_null <- summary(pgls_null)
  res_raw_null <- as.numeric(pgls_null$residuals)
  res_null <- as.matrix(dat_subs$path - mean_phylo)
  sse_null <-
    as.numeric(t(res_raw_null) %*% solve(vcv, tol = 2e-18) %*% res_raw_null)
  sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
  pgls_alt <- gls(
    path ~ time + node,
    data = dat_subs,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  sum_alt <- summary(pgls_alt)
  list_beta0[subs] <- beta0 <- as.numeric(pgls_alt$coefficients[1])
  list_beta1[subs] <- beta1 <- as.numeric(pgls_alt$coefficients[2])
  list_beta2[subs] <- beta2 <- as.numeric(pgls_alt$coefficients[3])
  list_se2[subs] <- sum_alt$tTable[6]
  list_p_val[subs] <- sum_alt$tTable[12]
  res_raw_alt <- as.numeric(pgls_alt$residuals)
  sse_alt <-
    as.numeric(t(res_raw_alt) %*% solve(vcv, tol = 2e-18) %*% res_raw_alt)
  list_r2[subs] <- r2_alt <- 1 - sse_alt/sst
  list_partial_r2[subs] <- partial_r2_alt <- (sse_null-sse_alt) / sse_null
  list_var[subs] <- sig2_alt <- sum_alt$sigma^2
  list_punc[subs] <- (2*(length(tree_subs$tip.label)-1)*beta2) /
                     sum(tree_subs$edge.length)
  list_dbic[subs] <- sum_null$BIC - sum_alt$BIC
  ## Save results
  setwd("sars_cov_2_2020_december_subsampling_10000")
  sink(
    paste("sars_cov_2_2020_december_subsampling_output_r_node_density_artifact_",
          subs, ".txt", sep = "")
  )
  cat("======================\n")
  cat(paste("Node-Density Test #", subs, "\n", sep = ""))
  cat("======================\n\n")
  print(summary(pgls_nda))
  cat("\n")
  cat(paste("Beta = ", beta, "\n", sep = ""))
  cat(paste("Delta = ", delta, sep = ""))
  cat("\n")
  sink()
  sink(
    paste("sars_cov_2_2020_december_subsampling_output_r_regression_path_time_node_",
          subs, ".txt", sep = "")
  )
  cat("==============================\n")
  cat(paste("Regression (Alternative) #", subs, "\n", sep = ""))
  cat("==============================\n\n")
  print(summary(pgls_alt))
  cat("\n")
  print(sum_alt$tTable)
  cat("\n")
  cat(paste("R-squared = ", r2_alt, "\n", sep = ""))
  cat(paste("Partial R-squared = ", partial_r2_alt, "\n", sep = ""))
  cat(paste("Variance = ", sig2_alt, "\n", sep = ""))
  cat(paste("SSE = ", sse_alt, "\n", sep = ""))
  cat(paste("SST = ", sst, sep = ""))
  cat("\n")
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_delta.txt",
    append = TRUE
  )
  cat(paste(list_delta[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta0.txt",
    append = TRUE
  )
  cat(paste(list_beta0[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta1.txt",
    append = TRUE
  )
  cat(paste(list_beta1[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta2.txt",
    append = TRUE
  )
  cat(paste(list_beta2[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta2_se.txt",
    append = TRUE
  )
  cat(paste(list_se2[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta2_p_val.txt",
    append = TRUE
  )
  cat(paste(list_p_val[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_beta2_partial_r2.txt",
    append = TRUE
  )
  cat(paste(list_partial_r2[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_r2.txt",
    append = TRUE
  )
  cat(paste(list_r2[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_var.txt",
    append = TRUE
  )
  cat(paste(list_var[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_punc_contrib.txt",
    append = TRUE
  )
  cat(paste(list_punc[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_dbic.txt",
    append = TRUE
  )
  cat(paste(list_dbic[subs], "\n", sep = ""))
  sink()
  sink(
    "sars_cov_2_2020_december_subsampling_output_r_all_n.txt",
    append = TRUE
  )
  cat(paste(list_n[subs], "\n", sep = ""))
  sink()
  setwd("..")
}

# Calculate summary and test statistics ----
delta_025 <- as.numeric(quantile(list_delta, 0.025))
delta_500 <- as.numeric(quantile(list_delta, 0.500))
delta_975 <- as.numeric(quantile(list_delta, 0.975))
sink("sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt")
cat("=====\n")
cat("Delta\n")
cat("=====\n\n")
cat(paste("Percentile (2.5th)  = ", delta_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", delta_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", delta_975, "\n\n", sep = ""))
sink()
beta0_025 <- as.numeric(quantile(list_beta0, 0.025))
beta0_500 <- as.numeric(quantile(list_beta0, 0.500))
beta0_975 <- as.numeric(quantile(list_beta0, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("======\n")
cat("Beta 0\n")
cat("======\n\n")
cat(paste("Percentile (2.5th)  = ", beta0_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", beta0_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", beta0_975, "\n\n", sep = ""))
sink()
beta1_025 <- as.numeric(quantile(list_beta1, 0.025))
beta1_500 <- as.numeric(quantile(list_beta1, 0.500))
beta1_975 <- as.numeric(quantile(list_beta1, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("======\n")
cat("Beta 1\n")
cat("======\n\n")
cat(paste("Percentile (2.5th)  = ", beta1_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", beta1_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", beta1_975, "\n\n", sep = ""))
sink()
beta2_025 <- as.numeric(quantile(list_beta2, 0.025))
beta2_500 <- as.numeric(quantile(list_beta2, 0.500))
beta2_975 <- as.numeric(quantile(list_beta2, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("======\n")
cat("Beta 2\n")
cat("======\n\n")
cat(paste("Percentile (2.5th)  = ", beta2_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", beta2_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", beta2_975, "\n\n", sep = ""))
sink()
se2_025 <- as.numeric(quantile(list_se2, 0.025))
se2_500 <- as.numeric(quantile(list_se2, 0.500))
se2_975 <- as.numeric(quantile(list_se2, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("===========\n")
cat("Beta 2 (SE)\n")
cat("===========\n\n")
cat(paste("Percentile (2.5th)  = ", se2_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", se2_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", se2_975, "\n\n", sep = ""))
sink()
p_val_025 <- as.numeric(quantile(list_p_val, 0.025))
p_val_500 <- as.numeric(quantile(list_p_val, 0.500))
p_val_975 <- as.numeric(quantile(list_p_val, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("================\n")
cat("Beta 2 (p-value)\n")
cat("================\n\n")
cat(paste("Percentile (2.5th)  = ", p_val_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", p_val_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", p_val_975, "\n\n", sep = ""))
sink()
partial_r2_025 <- as.numeric(quantile(list_partial_r2, 0.025))
partial_r2_500 <- as.numeric(quantile(list_partial_r2, 0.500))
partial_r2_975 <- as.numeric(quantile(list_partial_r2, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("==========================\n")
cat("Beta 2 (Partial R-squared)\n")
cat("==========================\n\n")
cat(paste("Percentile (2.5th)  = ", partial_r2_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", partial_r2_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", partial_r2_975, "\n\n", sep = ""))
sink()
punc_025 <- as.numeric(quantile(list_punc, 0.025))
punc_500 <- as.numeric(quantile(list_punc, 0.500))
punc_975 <- as.numeric(quantile(list_punc, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("==========================\n")
cat("Punctuational Contribution\n")
cat("==========================\n\n")
cat(paste("Percentile (2.5th)  = ", punc_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", punc_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", punc_975, "\n\n", sep = ""))
sink()
r2_025 <- as.numeric(quantile(list_r2, 0.025))
r2_500 <- as.numeric(quantile(list_r2, 0.500))
r2_975 <- as.numeric(quantile(list_r2, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("=========\n")
cat("R-squared\n")
cat("=========\n\n")
cat(paste("Percentile (2.5th)  = ", r2_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", r2_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", r2_975, "\n\n", sep = ""))
sink()
var_025 <- as.numeric(quantile(list_var, 0.025))
var_500 <- as.numeric(quantile(list_var, 0.500))
var_975 <- as.numeric(quantile(list_var, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("========\n")
cat("Variance\n")
cat("========\n\n")
cat(paste("Percentile (2.5th)  = ", var_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", var_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", var_975, "\n\n", sep = ""))
sink()
dbic_025 <- as.numeric(quantile(list_dbic, 0.025))
dbic_500 <- as.numeric(quantile(list_dbic, 0.500))
dbic_975 <- as.numeric(quantile(list_dbic, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("=========\n")
cat("Delta BIC\n")
cat("=========\n\n")
cat(paste("Percentile (2.5th)  = ", dbic_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", dbic_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", dbic_975, "\n\n", sep = ""))
sink()
n_025 <- as.numeric(quantile(list_n, 0.025))
n_500 <- as.numeric(quantile(list_n, 0.500))
n_975 <- as.numeric(quantile(list_n, 0.975))
sink(
  "sars_cov_2_2020_december_output_r_regression_subsampling_10000.txt",
  append = TRUE
)
cat("===========\n")
cat("Sample Size\n")
cat("===========\n\n")
cat(paste("Percentile (2.5th)  = ", n_025, "\n", sep = ""))
cat(paste("Percentile (50.0th) = ", n_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", n_975, "\n", sep = ""))
sink()
