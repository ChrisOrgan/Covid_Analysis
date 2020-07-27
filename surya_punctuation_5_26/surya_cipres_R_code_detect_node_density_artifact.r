# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(nlme)  # v3.1.147
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "surya_cipres_tree_collapsed.nex")

# Define correlation matrix ----
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Define variance weights ----
w <- diag(vcv(tree))

# Load and prepare data ----
dat <- read.table("surya_cipres_R_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat$node <- dat$node + 1  # This addition prevents log-transforming zero
dat <- dat[match(tree$tip.label, rownames(dat)), ]

# Detect node-density artifact ----
pgls <- gls(
  log(node) ~ log(path),
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("surya_cipres_R_output_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Delta = ", delta, sep = ""))
cat("\n")
sink()

# Create scatter plots ----
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

# Save scatter plots ----
CairoPDF("surya_cipres_figure_punctuation_node_density_artifact.pdf",
         width = 3.2675, height = 3.2675)
print(plot_bias)
graphics.off()
CairoSVG("surya_cipres_figure_punctuation_node_density_artifact.svg",
         width = 3.2675, height = 3.2675)
print(plot_bias)
graphics.off()