# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(ape)
library(Cairo)
library(ggExtra)
library(ggplot2)
library(ggthemes)


# Set memory limit ----
memory.limit(size = 6000000)

# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2020_december_tree_v3_11275.nex")

# Define variance-covariance matrix ----
vcv <- vcv(phy = tree)

# Write function `Dfun` ----
## See https://github.com/cran/caper/blob/master/R/pgls.R
Dfun <- function(Cmat) {
  iCmat <- solve(Cmat, tol = 2e-18)
  svdCmat <- La.svd(iCmat)
  D <- svdCmat$u %*% diag(sqrt(svdCmat$d)) %*% t(svdCmat$v)
  return(t(D))
}

# Read data ----
dat <- read.table(
  "sars_cov_2_2020_december_data_11275.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)
dat$fitted_values <- -0.009684339 + 0.000004794*dat$time + 0.000000090*dat$node
dat$res_raw <- dat$path - dat$fitted_values
dat$res_phy <- as.vector(Dfun(vcv) %*% dat$res_raw)

# Plot marginal histogram scatter plots of residuals ----
plot_diag <-
  ggplot(dat, aes(fitted_values, res_phy)) +
    geom_point(color = "gray", size = 0.5) +
    scale_y_reverse() +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted values", y = "Phylogenetic residuals\n")
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)

# Save diagnostic plot ----
CairoPDF(
  file = "sars_cov_2_2020_december_figure_diagnostics_11275.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_diag)
graphics.off()
