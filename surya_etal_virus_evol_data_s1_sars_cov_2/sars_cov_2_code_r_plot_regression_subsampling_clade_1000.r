# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggplot2)
library(ggthemes)


# Read and prepare data ----
setwd("sars_cov_2_subsampling_clade")
node <- read.table("sars_cov_2_subsampling_clade_output_r_all_beta2.txt")
setwd("..")
node$iteration <- 1:1000
colnames(node)[1] <- "node"

# Plot the node count effect distribution ----
plot_node <-
  ggplot(node, aes(node)) +
    geom_segment(
      x = 0,
      xend = 0,
      y = 0,
      yend = 710000,
      linetype = "dashed",
      color = "gray40",
      size = 0.5
    ) +
    annotate("text", x = 0, y = 710000, label = "") +
    geom_density(color = "black") +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count effect", y = NULL)

# Save scatter plots ----
CairoPDF(
  file = "sars_cov_2_figure_regression_subsampling_clade_1000.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_node)
graphics.off()
