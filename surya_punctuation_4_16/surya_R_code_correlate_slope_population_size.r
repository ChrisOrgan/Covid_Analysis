# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggrepel)  # v0.8.2
library(ggthemes)  # v4.2.0


# Write data ----
continent <- c("Africa", "Asia", "Europe", "North America", "Oceania",
               "South America")
slope <- c(0.244231555262, 0.811741351289, -0.359224246134, 0.274321504554,
           -0.992735546963, -4.448433729704)
pop_size <-c(1340598113, 4641054786, 747636045, 368092846, 42677809, 653739130)
dat <- data.frame(continent, slope, pop_size)

# Test correlation ----
sink("surya_R_output_correlation_slope_population_size.txt")
cat("==========================\n")
cat("Kendall's Rank Correlation\n")
cat("==========================\n\n")
cor.test(
  x = dat$pop_size,
  y = dat$slope,
  alternative = "greater",
  method = "kendall"
)
sink()

# Create scatter plot ----
plot_corr <-
  ggplot(dat, aes(pop_size, slope, label = continent)) +
    geom_segment(
      x = 0,
      xend = max(dat$pop_size),
      y = 0,
      yend = 0,
      color = "gray80",
      size = 0.25,
      linetype = "dashed"
    ) +
    geom_smooth(color = "gray25", size = 0.5, method = "lm", se = FALSE) +
    geom_point(color = "gray50") +
    geom_text_repel(
      segment.color = "gray90",
      nudge_x = 0.5,
      nudge_y = 0.25,
      color = "gray",
      size = 1.85,
      family = "Arial"
    ) +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nPopulation Size",
      y = "Slope (total path lengths ~ node count)\n"
    )

# Save scatter plot ----
CairoPS("surya_figure_correlation.ps", width = 3.2675, height = 3.2675)
print(plot_corr)
graphics.off()
