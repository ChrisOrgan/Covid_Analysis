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

# Subsample data and test for punctuation for each subsample ----
list_beta0 <- list_beta1 <- list_var <- list_r2 <- list_se0 <- list_se1 <-
  list_p <- NULL
for (subs in 1:1000) {
  subsample <- sample(tree$tip.label, size = 1000)
  tree_edit <- keep.tip(phy = tree, tip = subsample)
  dat_edit <- dat[dat$genome %in% subsample, ]
  dat_edit <- dat_edit[, -1]
  vcv <- vcv(tree_edit)
  corr <- corPagel(value = 1, phy = tree_edit, fixed = TRUE)
  w <- diag(vcv)
  pgls_int <- gls(
    path ~ 1,
    data = dat_edit,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  mean_phylo <- as.numeric(pgls_int$coefficients[1])
  pgls <- gls(
    path ~ node,
    data = dat_edit,
    correlation = corr,
    weights = varFixed(~w),
    method = "ML"
  )
  summ <- summary(pgls)
  beta0 <- as.numeric(pgls$coefficients[1])
  beta1 <- as.numeric(pgls$coefficients[2])
  sig2 <- summ$sigma^2
  res_raw <- as.numeric(pgls$residuals)
  res_null <- as.matrix(dat_edit$path - mean_phylo)
  sse <- as.numeric(t(res_raw) %*% solve(vcv, tol = 2e-18) %*% res_raw)
  sst <- as.numeric(t(res_null) %*% solve(vcv, tol = 2e-18) %*% res_null)
  r2 <- 1 - sse/sst
  se_b0 <- summ$tTable[3]
  se_b1 <- summ$tTable[4]
  p_val <- summ$tTable[8]
  setwd("subsampling_cipres")
  sink(paste("surya_cipres_R_output_subsampling_", subs, ".txt", sep = ""))
  cat("======================\n")
  cat(paste("Punctuation Test #", subs, "\n", sep = ""))
  cat("======================\n\n")
  print(summ)
  cat("\n")
  print(summ$tTable)
  cat("\n")
  cat(paste("R-squared = ", r2, "\n", sep = ""))
  cat(paste("Variance = ", sig2, sep = ""))
  cat("\n")
  sink()
  list_beta0[subs] <- beta0
  list_beta1[subs] <- beta1
  list_var[subs] <- sig2
  list_r2[subs] <- r2
  list_se0[subs] <- se_b0
  list_se1[subs] <- se_b1
  list_p[subs] <- p_val
  sink("surya_cipres_R_output_subsampling_beta0.txt", append = TRUE)
  cat(paste(beta0, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_beta1.txt", append = TRUE)
  cat(paste(beta1, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_var.txt", append = TRUE)
  cat(paste(sig2, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_r2.txt", append = TRUE)
  cat(paste(r2, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_se0.txt", append = TRUE)
  cat(paste(se_b0, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_se1.txt", append = TRUE)
  cat(paste(se_b1, "\n", sep = ""))
  sink()
  sink("surya_cipres_R_output_subsampling_p.txt", append = TRUE)
  cat(paste(p_val, "\n", sep = ""))
  sink()
  setwd("..")
}

# Calculate summary and test statistics ----
beta0_250 <- as.numeric(quantile(list_beta0, 0.025))
beta0_500 <- as.numeric(median(list_beta0))
beta0_975 <- as.numeric(quantile(list_beta0, 0.975))
sink("surya_cipres_R_output_subsampling_results.txt")
cat("=========\n")
cat("Intercept\n")
cat("=========\n\n")
cat(paste("Percentile (2.50th) = ", beta0_250, "\n", sep = ""))
cat(paste("Median = ", beta0_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", beta0_975, "\n\n", sep = ""))
sink()
beta1_250 <- as.numeric(quantile(list_beta1, 0.025))
beta1_500 <- as.numeric(median(list_beta1))
beta1_975 <- as.numeric(quantile(list_beta1, 0.975))
sink("surya_cipres_R_output_subsampling_results.txt", append = TRUE)
cat("=====\n")
cat("Slope\n")
cat("=====\n\n")
cat(paste("Percentile (2.50th) = ", beta1_250, "\n", sep = ""))
cat(paste("Median = ", beta1_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", beta1_975, "\n\n", sep = ""))
sink()
r2_250 <- as.numeric(quantile(list_r2, 0.025))
r2_500 <- as.numeric(median(list_r2))
r2_975 <- as.numeric(quantile(list_r2, 0.975))
sink("surya_cipres_R_output_subsampling_results.txt", append = TRUE)
cat("=========\n")
cat("R-squared\n")
cat("=========\n\n")
cat(paste("Percentile (2.50th) = ", r2_250, "\n", sep = ""))
cat(paste("Median = ", r2_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", r2_975, "\n\n", sep = ""))
sink()
p_250 <- as.numeric(quantile(list_p, 0.025))
p_500 <- as.numeric(median(list_p))
p_975 <- as.numeric(quantile(list_p, 0.975))
sink("surya_cipres_R_output_subsampling_results.txt", append = TRUE)
cat("=======\n")
cat("P value\n")
cat("=======\n\n")
cat(paste("Percentile (2.50th) = ", p_250, "\n", sep = ""))
cat(paste("Median = ", p_500, "\n", sep = ""))
cat(paste("Percentile (97.5th) = ", p_975, "\n", sep = ""))
sink()
