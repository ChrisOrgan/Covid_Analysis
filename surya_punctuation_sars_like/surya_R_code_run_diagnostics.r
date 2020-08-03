# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v.5.3
library(ggExtra)  # v0.9
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex")

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

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat$fitted_values <- 0.143 + 0.0012114*dat$node
dat$res_raw <- dat$path - dat$fitted_values
dat$res_phy <- as.vector(Dfun(vcv) %*% dat$res_raw)
dat_out <- read.table("surya_outliers.txt")
colnames(dat_out) <- c("outlier")
tree_edit <- drop.tip(phy = tree, tip = as.character(dat_out$outlier))
vcv_edit <- vcv(phy = tree_edit)
dat_edit <- dat[!dat$genome %in% as.character(dat_out$outlier), ]
dat_edit$fitted_values <- 0.1407 + 0.00099491*dat_edit$node
dat_edit$res_raw <- dat_edit$path - dat_edit$fitted_values
dat_edit$res_phy <- as.vector(Dfun(vcv_edit) %*% dat_edit$res_raw)

# Plot marginal histogram scatter plots of residuals ----
plot_diag <-
  ggplot(dat, aes(fitted_values, res_phy)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted values", y = "Residuals\n")
plot_diag_out <-
  ggplot(dat_edit, aes(fitted_values, res_phy)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted values", y = "Residuals\n")
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)
plot_diag_out <- ggMarginal(
  plot_diag_out,
  type = "density",
  margins = "y",
  size = 1.75
)

# Save diagnostic plots ----
ggsave("surya_figure_punctuation_diagnostics.pdf", width = 5, height = 4,
       device = cairo_pdf, plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics.svg", width = 5, height = 4,
       plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics_no_outliers.pdf", width = 5,
       height = 4, device = cairo_pdf, plot_diag_out)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics_no_outliers.svg", width = 5,
       height = 4, plot_diag_out)
graphics.off()
