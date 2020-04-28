# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggimage)  # v0.2.8
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(ggtree)  # v1.14.6
library(nlme)  # v3.1-147
library(phytools)  # v0.7-20


# Simulate tree ----
set.seed(0)
tree <- rtree(n = 100)

# Set tree branch lengths to be equal (positive control) ----
tree_pos <- compute.brlen(phy = tree, 1)

# Make tree ultrametric (negative control) ----
tree_neg <- force.ultrametric(tree = tree_pos, method = "extend")

# Add some random noises to branches of the control trees ----
set.seed(1)
tree_pos$edge.length <- jitter(tree_pos$edge.length, factor = 0.05)
set.seed(2)
tree_neg$edge.length <- jitter(tree_neg$edge.length, factor = 0.05)

# Write trees in the NEXUS format ----
writeNexus(tree = tree, file = "surya_tree_validation.nex")
writeNexus(tree = tree_pos, file = "surya_tree_validation_positive.nex")
writeNexus(tree = tree_neg, file = "surya_tree_validation_negative.nex")

# Plot trees ----
plot_tree <- ggtree(tr = tree)
plot_tree_pos <- ggtree(tr = tree_pos)
plot_tree_neg <- ggtree(tr = tree_neg)

# Save tree plots ----
CairoPDF("surya_figure_validation_tree.pdf", width = 3.2675, height = 3.2675)
print(plot_tree)
graphics.off()
CairoPDF("surya_figure_validation_tree_positive.pdf", width = 3.2675,
         height = 3.2675)
print(plot_tree_pos)
graphics.off()
CairoPDF("surya_figure_validation_tree_negative.pdf", width = 3.2675,
         height = 3.2675)
print(plot_tree_neg)
graphics.off()

# Decompose trees into variance-covariance matrices ----
vcv <- vcv(phy = tree)
vcv_pos <- vcv(phy = tree_pos)
vcv_neg <- vcv(phy = tree_neg)

# Extract path lengths (diagonals of the matrix) ----
path <- diag(vcv)
path_pos <- diag(vcv_pos)
path_neg <- diag(vcv_neg)

# Extract nodes ----
node <- node_pos <- node_neg <- NULL
for (tip in 1:length(tree$tip.label)) {
  node[tip] <- length(
    nodepath(
      phy = tree,
      from = length(tree$tip.label) + 1,  # root
      to = tip
    )
   ) - 2  # minus the root and terminal tip
}
for (tip in 1:length(tree_pos$tip.label)) {
  node_pos[tip] <- length(
    nodepath(
      phy = tree_pos,
      from = length(tree_pos$tip.label) + 1,
      to = tip
    )
   ) - 2
}
for (tip in 1:length(tree_neg$tip.label)) {
  node_neg[tip] <- length(
    nodepath(
      phy = tree_neg,
      from = length(tree_neg$tip.label) + 1,
      to = tip
    )
   ) - 2
}

# Create data frames ----
dat <- data.frame(path, node)
dat_pos <- data.frame(path_pos, node_pos)
dat_neg <- data.frame(path_neg, node_neg)

# Write data frames ----
write.table(
  dat,
  file = "surya_data_validation.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)
write.table(
  dat_pos,
  file = "surya_data_validation_positive.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)
write.table(
  dat_neg,
  file = "surya_data_validation_negative.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)

# Define correlation matrices ----
vcv <- corBrownian(phy = tree)
vcv_pos <- corBrownian(phy = tree_pos)
vcv_neg <- corBrownian(phy = tree_neg)

# Detect node-density artifact ----
pgls <- gls(log(node) ~ log(path), data = dat, correlation = vcv)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("surya_R_output_validation_node_density.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Beta = ", round(beta, 3), "\n", sep = ""))
cat(paste("Delta = ", round(delta, 3), sep = ""))
cat("\n")
sink()
pgls_pos <- gls(
  log(node_pos) ~ log(path_pos),
  data = dat_pos,
  correlation = vcv_pos
)
beta_pos <- exp(as.numeric(pgls_pos$coefficients[1]))
delta_pos <- as.numeric(pgls_pos$coefficients[2])
sink("surya_R_output_validation_node_density_positive.txt")
cat("====================================\n")
cat("Node-Density Test (Positive Control)\n")
cat("====================================\n\n")
summary(pgls_pos)
cat("\n")
cat(paste("Beta = ", round(beta_pos, 3), "\n", sep = ""))
cat(paste("Delta = ", round(delta_pos, 3), sep = ""))
cat("\n")
sink()
pgls_neg <- gls(
  log(node_neg) ~ log(path_neg),
  data = dat_neg,
  correlation = vcv_neg
)
beta_neg <- exp(as.numeric(pgls_neg$coefficients[1]))
delta_neg <- as.numeric(pgls_neg$coefficients[2])
sink("surya_R_output_validation_node_density_negative.txt")
cat("====================================\n")
cat("Node-Density Test (Negative Control)\n")
cat("====================================\n\n")
summary(pgls_neg)
cat("\n")
cat(paste("Beta = ", round(beta_neg, 3), "\n", sep = ""))
cat(paste("Delta = ", round(delta_neg, 3), sep = ""))
cat("\n")
sink()

# Plot regression scatter plots ----
plot_reg <-
  ggplot(dat, aes(path, node)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path) {beta * path^delta}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Number of Nodes",
      x = "\nTotal Path Lengths",
      y = NULL
    )
plot_reg_pos <-
  ggplot(dat_pos, aes(path_pos, node_pos)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path_pos) {beta_pos * path_pos^delta_pos}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Number of Nodes",
      x = "\nTotal Path Lengths",
      y = NULL
    )
plot_reg_neg <-
  ggplot(dat_neg, aes(path_neg, node_neg)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 1,
      fun = function(path_neg) {beta_neg * path_neg^delta_neg}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Number of Nodes",
      x = "\nTotal Path Lengths",
      y = NULL
    )

# Save regression scatter plots ----
CairoPDF("surya_figure_validation_node_density.pdf", width = 3.2675,
         height = 3.2675)
print(plot_reg)
graphics.off()
CairoPDF("surya_figure_validation_node_density_positive.pdf", width = 3.2675,
         height = 3.2675)
print(plot_reg_pos)
graphics.off()
CairoPDF("surya_figure_validation_node_density_negative.pdf", width = 3.2675,
         height = 3.2675)
print(plot_reg_neg)
graphics.off()

# Test for punctuation ----
pgls_pe <- gls(path ~ node, data = dat, correlation = vcv)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
p_val <- sum_pe$tTable[8]
sse <- sum(pgls_pe$residuals^2)
sst <- sum((dat$path - mean(dat$path))^2)
r2 <- 1 - sse/sst
sink("surya_R_output_validation_punctuation.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), sep = ""))
cat("\n")
sink()
pgls_pe_pos <- gls(path_pos ~ node_pos, data = dat_pos, correlation = vcv_pos)
sum_pe_pos <- summary(pgls_pe_pos)
beta0_pos <- as.numeric(pgls_pe_pos$coefficients[1])
beta1_pos <- as.numeric(pgls_pe_pos$coefficients[2])
p_val_pos <- sum_pe_pos$tTable[8]
sse_pos <- sum(pgls_pe_pos$residuals^2)
sst_pos <- sum((dat_pos$path_pos - mean(dat_pos$path_pos))^2)
r2_pos <- 1 - sse_pos/sst_pos
sink("surya_R_output_validation_punctuation_positive.txt")
cat("===================================\n")
cat("Punctuation Test (Positive Control)\n")
cat("===================================\n\n")
summary(pgls_pe_pos)
cat("\n")
cat(paste("Intercept = ", round(beta0_pos, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1_pos, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val_pos, "\n", sep = ""))
cat(paste("R-squared = ", round(r2_pos, 3), sep = ""))
cat("\n")
sink()
pgls_pe_neg <- gls(path_neg ~ node_neg, data = dat_neg, correlation = vcv_neg)
sum_pe_neg <- summary(pgls_pe_neg)
beta0_neg <- as.numeric(pgls_pe_neg$coefficients[1])
beta1_neg <- as.numeric(pgls_pe_neg$coefficients[2])
p_val_neg <- sum_pe_neg$tTable[8]
sse_neg <- sum(pgls_pe_neg$residuals^2)
sst_neg <- sum((dat_neg$path_neg - mean(dat_neg$path_neg))^2)
r2_neg <- 1 - sse_neg/sst_neg
sink("surya_R_output_validation_punctuation_negative.txt")
cat("===================================\n")
cat("Punctuation Test (Negative Control)\n")
cat("===================================\n\n")
summary(pgls_pe_neg)
cat("\n")
cat(paste("Intercept = ", round(beta0_neg, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1_neg, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val_neg, "\n", sep = ""))
cat(paste("R-squared = ", round(r2_neg, 3), sep = ""))
cat("\n")
sink()

# Plot regression scatter plots ----
plot_pgls <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "blue",
      size = 1,
      fun = function(node) {beta0 + beta1*node}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths",
      x = "\nNumber of Nodes",
      y = NULL
    )
plot_pgls_pos <-
  ggplot(dat_pos, aes(node_pos, path_pos)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "blue",
      size = 1,
      fun = function(node_pos) {beta0_pos + beta1_pos*node_pos}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths",
      x = "\nNumber of Nodes",
      y = NULL
    )
plot_pgls_neg <-
  ggplot(dat_neg, aes(node_neg, path_neg)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "blue",
      size = 1,
      fun = function(node_neg) {beta0_neg + beta1_neg*node_neg}
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths",
      x = "\nNumber of Nodes",
      y = NULL
    )

# Save regression scatter plots ----
CairoPDF("surya_figure_validation_punctuation.pdf", width = 3.2675,
         height = 3.2675)
print(plot_pgls)
graphics.off()
CairoPDF("surya_figure_validation_punctuation_positive.pdf", width = 3.2675,
         height = 3.2675)
print(plot_pgls_pos)
graphics.off()
CairoPDF("surya_figure_validation_punctuation_negative.pdf", width = 3.2675,
         height = 3.2675)
print(plot_pgls_neg)
graphics.off()

# Cross-check results using the website http://www.evolution.rdg.ac.uk/pe/index.html
