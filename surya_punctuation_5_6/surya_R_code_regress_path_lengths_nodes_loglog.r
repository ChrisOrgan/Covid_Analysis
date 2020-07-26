## # Written by Kevin Surya, 2020.
## # This code is part of the coronavirus-macroevolution project.
## 
## 
## # library(ape)  # v5.3
## library(phytools)  # v0.7-20
## library(nlme)  # v3.1-147
## 
## 
## # Read tree ----
## tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
## 
## # Decompose tree into variance-covariance matrix ----
## vcv <- vcv(phy = tree)
## 
## # Define correlation matrices ----
## vcv_lambda0 <- corPagel(value = 0, phy = tree, fixed = TRUE)
## vcv_lambda1 <- corPagel(value = 1, phy = tree, fixed = TRUE)
## 
## # Load and prepare data ----
## dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
## colnames(dat) <- c("genome", "path", "node")
## rownames(dat) <- dat$genome
## dat <- dat[, -1]
## dat$node <- dat$node + 1
## 
## # Test for punctuation ----
## pgls_pe <- gls(log(path) ~ log(node), data = dat, correlation = vcv_lambda1)
## sum_pe <- summary(pgls_pe)
## beta0 <- as.numeric(pgls_pe$coefficients[1])
## beta1 <- as.numeric(pgls_pe$coefficients[2])
## se_beta1 <- sum_pe$tTable[4]
## p_val <- sum_pe$tTable[8]
## sse <- sum(pgls_pe$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pe$sigma^2
## sink("surya_R_output_regression_punctuation_loglog_lambda1.txt")
## cat("================\n")
## cat("Punctuation Test\n")
## cat("================\n\n")
## summary(pgls_pe)
## cat("\n")
## cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## 
## # Test for punctuation (2nd replicate) ----
## pgls_pe <- gls(log(path) ~ log(node), data = dat, correlation = vcv_lambda1)
## sum_pe <- summary(pgls_pe)
## beta0 <- as.numeric(pgls_pe$coefficients[1])
## beta1 <- as.numeric(pgls_pe$coefficients[2])
## se_beta1 <- sum_pe$tTable[4]
## p_val <- sum_pe$tTable[8]
## sse <- sum(pgls_pe$residuals^2)
## sst <- sum((dat$path - mean(dat$path))^2)
## r2 <- 1 - sse/sst
## sigma2 <- sum_pe$sigma^2
## sink("surya_R_output_regression_punctuation_loglog_lambda1.txt", append = TRUE)
## cat("\n================================\n")
## cat("Punctuation Test (2nd Replicate)\n")
## cat("================================\n\n")
## summary(pgls_pe)
## cat("\n")
## cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
## cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
## cat(paste("SE (slope) = ", se_beta1, "\n", sep = ""))
## cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
## cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
## cat(paste("Variance = ", round(sigma2, 3), sep = ""))
## cat("\n")
## sink()
## 