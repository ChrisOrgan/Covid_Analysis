# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggplot2)
library(ggthemes)


# Read and prepare data ----
setwd("sars_cov_2_2021_march_subsampling_5000")
node <- read.table(
  "sars_cov_2_2021_march_subsampling_output_r_all_beta2.txt"
)
setwd("..")
node$iteration <- 1:100
colnames(node)[1] <- "node"

# Plot the node count effect distribution ----
plot_node <-
  ggplot(node, aes(node)) +
    geom_segment(
      x = 0,
      xend = 0,
      y = 0,
      yend = 3000000,
      linetype = "dashed",
      color = "gray40",
      size = 0.5
    ) +
    annotate("text", x = 0, y = 3000000, label = "") +
    geom_density(color = "black") +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count effect", y = NULL)

# Determine one-sided p-value ----
length(node$node[node$node < 0]) / length(node$node)
## [1] 0.01

# Save scatter plots ----
CairoPDF(
  file = "sars_cov_2_2021_march_figure_regression_subsampling_5000.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_node)
graphics.off()
