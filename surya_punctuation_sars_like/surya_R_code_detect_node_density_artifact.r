# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(nlme)  # v3.1-147
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat <- dat[, -1]

# Define the variance-covariance matrix ----
vcv <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Detect the node-density artifact ----
pgls <- gls(log(node) ~ log(path), data = dat, correlation = vcv)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("surya_R_output_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Delta = ", round(delta, 2), sep = ""))
cat("\n")
sink()

# Plot the scatter plot ----
scatter_plot <-
  ggplot(dat, aes(path, node)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path){beta * path^delta}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nTotal path length", y = "Node count\n")

# Save the scatter plot ----
CairoPDF("surya_figure_punctuation_sars_like_node_density_artifact.pdf",
         width = 3.2675, height = 3.2675)
print(scatter_plot)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_node_density_artifact.svg",
         width = 3.2675, height = 3.2675)
print(scatter_plot)
graphics.off()
