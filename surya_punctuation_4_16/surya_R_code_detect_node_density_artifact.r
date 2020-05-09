# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(nlme)  # v3.1-147
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
tree_rate <- read.nexus(file = "surya_tree_rate_v2.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat <- dat[, -1]
dat$node <- dat$node + 1  # This addition prevents log-transforming zero
dat_rate <- read.table(
  "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
  sep = "\t"
)
colnames(dat_rate) <- c("genome", "path", "node")
rownames(dat_rate) <- dat_rate$genome
dat_rate <- dat_rate[, -1]
dat_rate$node <- dat_rate$node + 1

# Define variance-covariance matrices ----
vcv <- corPagel(value = 1, phy = tree, fixed = TRUE)
vcv_rate <- corPagel(value = 1, phy = tree_rate, fixed = TRUE)

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
pgls_rate <- gls(log(node) ~ log(path), data = dat_rate, correlation = vcv_rate)
beta_rate <- exp(as.numeric(pgls_rate$coefficients[1]))
delta_rate <- as.numeric(pgls_rate$coefficients[2])
sink("surya_R_output_node_density_artifact_rate.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls_rate)
cat("\n")
cat(paste("Delta = ", round(delta_rate, 3), sep = ""))
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
    labs(x = "\nTotal Path Lengths", y = "Number of Nodes\n")
plot_bias_rate <-
  ggplot(dat_rate, aes(path, node)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path_rate){beta_rate * path_rate^delta_rate}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nTotal Path Lengths", y = "Number of Nodes\n")

# Save scatter plots ----
CairoPDF("surya_figure_punctuation_node_density_artifact.pdf", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
CairoSVG("surya_figure_punctuation_node_density_artifact.svg", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
CairoPDF("surya_figure_punctuation_rate_node_density_artifact.pdf",
         width = 3.2675, height = 3.2675)
print(plot_bias_rate)
graphics.off()
CairoSVG("surya_figure_punctuation_rate_node_density_artifact.svg",
         width = 3.2675, height = 3.2675)
print(plot_bias_rate)
graphics.off()
