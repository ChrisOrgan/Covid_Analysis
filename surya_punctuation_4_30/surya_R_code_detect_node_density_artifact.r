# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(nlme)  # v3.1-147
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(
  file = "nextstrain_ncov_non-subsampled_2020-04-30_tree_v4.nex"
)

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat <- dat[, -1]
dat$node <- dat$node + 1  # This addition prevents log-transforming zero

# Define variance-covariance matrix ----
vcv <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Detect node-density artifact ----
pgls <- gls(log(node) ~ log(path), data = dat, correlation = vcv)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("surya_R_output_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Delta = ", round(delta, 3), sep = ""))
cat("\n")
sink()

# Create scatter plot ----
plot_bias <-
  ggplot(dat, aes(path, node)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path){beta * path^delta}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nTotal path length", y = "Node count\n")

# Save scatter plot ----
CairoPDF("surya_figure_punctuation_node_density_artifact.pdf", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
CairoSVG("surya_figure_punctuation_node_density_artifact.svg", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
