# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.2


# Load and prepare data ----
setwd("subsampling_wduplicates")
slope <- read.table("surya_wduplicates_R_output_subsampling_beta1.txt")
setwd("..")
slope$iteration <- 1:1000
colnames(slope)[1] <- "slopes"

# Plot distribution ----
plot_dist <-
  ggplot(slope, aes(slopes)) +
    geom_segment(
      x = 0,
      xend = 0,
      y = 0,
      yend = 24000000,
      linetype = "dashed",
      color = "gray40",
      size = 0.5
    ) +
    annotate("text", x = 0, y = 24000000, label = "") +
    geom_density(color = "black") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nSlope", y = NULL)

# Save scatter plots ----
CairoPDF("surya_wduplicates_figure_slope_distribution_subsampling.pdf",
         width = 6.535, height = 4.089)
print(plot_dist)
graphics.off()
CairoSVG("surya_wduplicates_figure_slope_distribution_subsampling.svg",
         width = 6.535, height = 4.089)
print(plot_dist)
graphics.off()
