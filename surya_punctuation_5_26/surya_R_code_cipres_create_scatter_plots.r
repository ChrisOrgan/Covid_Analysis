# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.2.1
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_R_data_cipres_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")

# Plot scatter plots ----
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.0001207442 + 0.00004814203*min(dat$node),
      yend = 0.0001207442 + 0.00004814203*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")

# Save scatter plots ----
CairoPDF("surya_figure_cipres_punctuation.pdf", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoSVG("surya_figure_cipres_punctuation.svg", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
