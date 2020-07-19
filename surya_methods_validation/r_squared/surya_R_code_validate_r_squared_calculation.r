# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(caper)  # v1.0.1


# Replicate R-squared calculation (non-phylogenetic) ----
## Write data
x <- c(1, 2, 3, 4, 5)
y <- c(1, 3, 2, 4, 7)
species <- c("t1", "t2", "t3", "t4", "t5")
dat <- data.frame(species, y, x)
## Calculate mean
mean_non_phylo <- mean(y)
## Fit regression
model_non <- lm(y ~ x, data = dat)
## Extract R-squared
sum_non <- summary(model_non)
### sum_non
r2_non_auto <- sum_non$r.squared
## Calculate R-squared
sse <- sum(sum_non$residuals^2)
sst <- sum((dat$y - mean_non_phylo)^2)
r2_non_man <- 1 - sse/sst
## Calculat R-squared (matrix)
res <- as.matrix(sum_non$residuals)
res_null <- as.matrix(dat$y - mean_non_phylo)
vcv_non <-
  matrix(
    c(
      c(1, 0, 0, 0, 0),
      c(0, 1, 0, 0, 0),
      c(0, 0, 1, 0, 0),
      c(0, 0, 0, 1, 0),
      c(0, 0, 0, 0, 1)
    ),
    nrow = 5
  )
sse <- as.numeric(t(res) %*% solve(vcv_non) %*% res)
sst <- as.numeric(t(res_null) %*% solve(vcv_non) %*% res_null)
r2_non_man <- 1 - sse/sst
## Check calculation
r2_non_auto == r2_non_man
### [1] TRUE

# Replicate R-squared calculation (phylogenetic) ----
## Simulate tree
set.seed(0)
tree <- rtree(n = 5)
## Combine tree and data
dat_caper <- comparative.data(phy = tree, data = dat, names.col = "species")
## Calculate phylogenetic mean
model_null <- pgls(y ~ 1, data = dat_caper)
sum_null <- summary(model_null)
mean_phylo <- sum_null$coefficients[1]
## Fit regression
model <- pgls(y ~ x, data = dat_caper)
sum_p <- summary(model)
b0 <- sum_p$coefficients[1]
b1 <- sum_p$coefficients[2]
## Extract R-squared
r2_phylo_auto <- sum_p$r.squared
## Calculate R-squared
rownames(dat) <- dat$species
dat <- dat[, -1]
dat <- dat[match(tree$tip.label, rownames(dat)), ]
res_raw <- as.matrix(dat$y - (b0 + b1*dat$x))
res_null <- as.matrix(dat$y - mean_phylo)
vcv <- vcv(tree)
### vcv
sse <- as.numeric(t(res_raw) %*% solve(vcv) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv) %*% res_null)
r2_phylo_man <- 1 - sse/sst
## Check calculation
model_n <- c(rep("non-phylogenetic", 2), rep("phylogenetic", 2))
calculation <- rep(c("automatic", "manual"), 2)
r2 <- c(r2_non_auto, r2_non_man, r2_phylo_auto, r2_phylo_man)
correct <- c(NA, "yes", NA, "yes")
check <- data.frame(model_n, calculation, r2, correct)
check

# Calculate phylogenetic residuals ----
## See https://github.com/cran/caper/blob/master/R/pgls.R
Dfun <- function(Cmat) {
  iCmat <- solve(Cmat, tol = .Machine$double.eps)
  svdCmat <- La.svd(iCmat)
  D <- svdCmat$u %*% diag(sqrt(svdCmat$d)) %*% t(svdCmat$v)
  return(t(D))
}
res_phylo <- as.vector(Dfun(vcv) %*% res_raw)
res_phylo == as.vector(model$phyres)
### [1] TRUE TRUE TRUE TRUE TRUE
