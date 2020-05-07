# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ggExtra)  # v0.9
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat$fitted_values <- 0.146969004873 + 0.000004397314*dat$node
dat$residuals <- dat$path - dat$fitted_values

# Plot the marginal histogram scatter plot of residuals ----
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
    labs(
      subtitle = "Residuals",
      x = "\nFitted Values",
      y = NULL
    )
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)

# Save the scatter plot ----
ggsave("surya_figure_punctuation_sars_like_diagnostics.pdf", width = 5,
       height = 4, device = cairo_pdf, plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_sars_like_diagnostics.svg", width = 5,
       height = 4, plot_diag)
graphics.off()