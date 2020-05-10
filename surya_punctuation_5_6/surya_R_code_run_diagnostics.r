# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ggExtra)  # v0.9
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat$fitted_values <- 12.05444 + 0*dat$node
dat$residuals <- dat$path - dat$fitted_values
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$Region)
colnames(dat)[6] <- "continent"
dat_rate <- read.table(
  "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
  sep = "\t"
)
colnames(dat_rate) <- c("genome", "path", "node")
dat_rate$fitted_values <- 1796.6313 + -0.0006*dat_rate$node
dat_rate$residuals <- dat_rate$path - dat_rate$fitted_values

# Plot marginal histogram scatter plots of residuals ----
plot_diag <-
  ggplot(dat, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_rate <-
  ggplot(dat_rate, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)
plot_diag_rate <- ggMarginal(
  plot_diag_rate,
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
ggsave("surya_figure_punctuation_rate_diagnostics.pdf", width = 6.535,
       height = 4.089, device = cairo_pdf, plot_diag_rate)
graphics.off()
ggsave("surya_figure_punctuation_rate_diagnostics.svg", width = 6.535,
       height = 4.089, plot_diag_rate)
graphics.off()

# Check normality using the Shapiro-Wilk test ----
sink("surya_R_output_normality.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat$residuals)
sink()
sink("surya_R_output_normality_rate.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat_rate$residuals)
sink()
