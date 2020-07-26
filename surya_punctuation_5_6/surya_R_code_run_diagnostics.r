# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v.5.3
library(ggExtra)  # v0.9
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")

# Define variance-covariance matrix ----
vcv <- vcv(tree)

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
dat$fitted_values <- 0.0000000001040752 + -0.000000000003461947*dat$node
dat$res_raw <- dat$path - dat$fitted_values
dat$res_phy <- as.vector(Dfun(vcv) %*% dat$res_raw)
## dat_log <- dat
## dat_log$path <- log(dat_log$path)
## dat_log$node <- log(dat_log$node + 1)
## dat_log$fitted_values <- 2.250556 + 0*log(dat_log$node + 1)
## dat_log$residuals <- dat_log$path - dat_log$fitted_values
## dat_rate <- read.table(
##   "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
##   sep = "\t"
## )
## colnames(dat_rate) <- c("genome", "path", "node")
## dat_rate$fitted_values <- 1796.6313 + -0.0006*dat_rate$node
## dat_rate$residuals <- dat_rate$path - dat_rate$fitted_values

# Plot histograms of the variables ----
plot_y <-
  ggplot(dat, aes(path)) +
    geom_density() +
      theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
      labs(x = "\nTotal path length (mutations)", y = NULL)
plot_x <-
  ggplot(dat, aes(node)) +
    geom_density() +
      theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
      labs(x = "\nNode count", y = NULL)

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
    labs(x = "\nFitted values", y = "Phylogenetic residuals\n")
## plot_diag_loglog <-
##   ggplot(dat_log, aes(fitted_values, residuals)) +
##     geom_point(color = "gray", size = 0.5) +
##     geom_smooth(
##       color = "red",
##       size = 1,
##       method = "loess",
##       se = FALSE
##     ) +
##     scale_y_reverse() +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     labs(x = "\nFitted values", y = "Residuals\n")
## plot_diag_rate <-
##   ggplot(dat_rate, aes(fitted_values, residuals)) +
##     geom_point(color = "gray", size = 0.5) +
##     geom_smooth(
##       color = "red",
##       size = 1,
##       method = "loess",
##       se = FALSE
##     ) +
##     scale_y_reverse() +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     labs(x = "\nFitted values", y = "Residuals\n")
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)
## plot_diag_loglog <- ggMarginal(
##   plot_diag_loglog,
##   type = "density",
##   margins = "y",
##   size = 1.75
## )
## plot_diag_rate <- ggMarginal(
##   plot_diag_rate,
##   type = "density",
##   margins = "y",
##   size = 1.75
## )

# Save diagnostic plots ----
ggsave("surya_figure_distribution_path_lengths.pdf", width = 5, height = 4,
       device = cairo_pdf, plot_y)
graphics.off()
ggsave("surya_figure_distribution_path_lengths.svg", width = 5, height = 4,
       plot_y)
graphics.off()
ggsave("surya_figure_distribution_nodes.pdf", width = 5, height = 4,
       device = cairo_pdf, plot_x)
graphics.off()
ggsave("surya_figure_distribution_nodes.svg", width = 5, height = 4, plot_x)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics.pdf", width = 5, height = 4,
       device = cairo_pdf, plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics.svg", width = 5, height = 4,
       plot_diag)
graphics.off()
## ggsave("surya_figure_punctuation_loglog_diagnostics.pdf", width = 5, height = 4,
##        device = cairo_pdf, plot_diag_loglog)
## graphics.off()
## ggsave("surya_figure_punctuation_loglog_diagnostics.svg", width = 5, height = 4,
##        plot_diag_loglog)
## graphics.off()
## ggsave("surya_figure_punctuation_rate_diagnostics.pdf", width = 6.535,
##        height = 4.089, device = cairo_pdf, plot_diag_rate)
## graphics.off()
## ggsave("surya_figure_punctuation_rate_diagnostics.svg", width = 6.535,
##        height = 4.089, plot_diag_rate)
## graphics.off()

## # Check normality using the Shapiro-Wilk test ----
## sink("surya_R_output_normality.txt")
## cat("==============\n")
## cat("Normality Test\n")
## cat("==============\n\n")
## shapiro.test(dat$res_phy)
## sink()
## sink("surya_R_output_normality_loglog.txt")
## cat("==============\n")
## cat("Normality Test\n")
## cat("==============\n\n")
## shapiro.test(dat_log$residuals)
## sink()
## sink("surya_R_output_normality_rate.txt")
## cat("==============\n")
## cat("Normality Test\n")
## cat("==============\n\n")
## shapiro.test(dat_rate$residuals)
## sink()
