# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggplot2)
library(ggthemes)


# Read data ----
dat <- read.table("sarbecovirus_data.txt", sep = "\t", header = TRUE)
dat <- dat[-6, ]  # removes the Kenyan sarbecovirus

# Plot regression ----
plot_reg <-
  ggplot(dat, aes(x = time, y = path, color = node)) +
    geom_point() +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time (decimal year)",
      y = "Root-to-tip divergence (subs/site)\n",
      color = "Node\ncount"
    )

# Save scatter plots ----
CairoPDF(
  file = "sarbecovirus_figure_regression_path_time_node.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_reg)
graphics.off()
