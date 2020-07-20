# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(ggimage)  # v0.2.8
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(ggtree)  # v1.14.6
library(nlme)  # v3.1.147
library(phytools)  # v0.7.20


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
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)
corr_pos <- corPagel(value = 1, phy = tree_pos, fixed = TRUE)
corr_neg <- corPagel(value = 1, phy = tree_neg, fixed = TRUE)

# Define variance weights ----
vf <- diag(vcv)
vf_pos <- diag(vcv_pos)
vf_neg <- diag(vcv_neg)

# Detect node-density artifact ----
pgls <- gls(
  log(node) ~ log(path),
  data = dat,
  correlation = corr,
  weights = varFixed(~vf),
  method = "ML"
)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("surya_R_output_validation_node_density.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Beta = ", beta, "\n", sep = ""))
cat(paste("Delta = ", delta, sep = ""))
cat("\n")
sink()
pgls_pos <- gls(
  log(node_pos) ~ log(path_pos),
  data = dat_pos,
  correlation = corr_pos,
  weights = varFixed(~vf_pos),
  method = "ML"
)
beta_pos <- exp(as.numeric(pgls_pos$coefficients[1]))
delta_pos <- as.numeric(pgls_pos$coefficients[2])
sink("surya_R_output_validation_node_density_positive.txt")
cat("====================================\n")
cat("Node-Density Test (Positive Control)\n")
cat("====================================\n\n")
summary(pgls_pos)
cat("\n")
cat(paste("Beta = ", beta_pos, "\n", sep = ""))
cat(paste("Delta = ", delta_pos, sep = ""))
cat("\n")
sink()
pgls_neg <- gls(
  log(node_neg) ~ log(path_neg),
  data = dat_neg,
  correlation = corr_neg,
  weights = varFixed(~vf_neg),
  method = "ML"
)
beta_neg <- exp(as.numeric(pgls_neg$coefficients[1]))
delta_neg <- as.numeric(pgls_neg$coefficients[2])
sink("surya_R_output_validation_node_density_negative.txt")
cat("====================================\n")
cat("Node-Density Test (Negative Control)\n")
cat("====================================\n\n")
summary(pgls_neg)
cat("\n")
cat(paste("Beta = ", beta_neg, "\n", sep = ""))
cat(paste("Delta = ", delta_neg, sep = ""))
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
pgls_pe <- gls(
  path ~ node,
  data = dat,
  correlation = corr,
  weights = varFixed(~vf),
  method = "ML"
)
sum_pe <- summary(pgls_pe)
beta0 <- as.numeric(pgls_pe$coefficients[1])
beta1 <- as.numeric(pgls_pe$coefficients[2])
res_raw <- as.numeric(pgls_pe$residuals)
pgls_null <- gls(
  path ~ 1,
  data = dat,
  correlation = corr,
  weights = varFixed(~vf),
  method = "ML"
)
mean_phylo <- as.numeric(pgls_null$coefficients[1])
res_null <- as.matrix(dat$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv) %*% res_null)
r2 <- 1 - sse/sst
sink("surya_R_output_validation_punctuation.txt")
cat("================\n")
cat("Punctuation Test\n")
cat("================\n\n")
summary(pgls_pe)
cat("\n")
sum_pe$tTable
cat("\n")
cat(paste("R-squared = ", r2, sep = ""))
cat("\n")
sink()
pgls_pos <- gls(
  path_pos ~ node_pos,
  data = dat_pos,
  correlation = corr_pos,
  weights = varFixed(~vf_pos),
  method = "ML"
)
sum_pos <- summary(pgls_pos)
beta0_pos <- as.numeric(pgls_pos$coefficients[1])
beta1_pos <- as.numeric(pgls_pos$coefficients[2])
res_raw <- as.numeric(pgls_pos$residuals)
pgls_null <- gls(
  path_pos ~ 1,
  data = dat_pos,
  correlation = corr_pos,
  weights = varFixed(~vf_pos),
  method = "ML"
)
mean_phylo <- as.numeric(pgls_null$coefficients[1])
res_null <- as.matrix(dat_pos$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv_pos) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_pos) %*% res_null)
r2 <- 1 - sse/sst
sink("surya_R_output_validation_punctuation_positive.txt")
cat("===================================\n")
cat("Punctuation Test (Positive Control)\n")
cat("===================================\n\n")
summary(pgls_pos)
cat("\n")
sum_pos$tTable
cat("\n")
cat(paste("R-squared = ", r2, sep = ""))
cat("\n")
sink()
pgls_neg <- gls(
  path_neg ~ node_neg,
  data = dat_neg,
  correlation = corr_neg,
  weights = varFixed(~vf_neg),
  method = "ML"
)
sum_neg <- summary(pgls_neg)
beta0_neg <- as.numeric(pgls_neg$coefficients[1])
beta1_neg <- as.numeric(pgls_neg$coefficients[2])
res_raw <- as.numeric(pgls_neg$residuals)
pgls_null <- gls(
  path_neg ~ 1,
  data = dat_neg,
  correlation = corr_neg,
  weights = varFixed(~vf_neg),
  method = "ML"
)
mean_phylo <- as.numeric(pgls_null$coefficients[1])
res_null <- as.matrix(dat_neg$path - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv_neg) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_neg) %*% res_null)
r2 <- 1 - sse/sst
sink("surya_R_output_validation_punctuation_negative.txt")
cat("===================================\n")
cat("Punctuation Test (Negative Control)\n")
cat("===================================\n\n")
summary(pgls_neg)
cat("\n")
sum_neg$tTable
cat("\n")
cat(paste("R-squared = ", r2, sep = ""))
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

# Cross-check results using the 
# website http://www.evolution.rdg.ac.uk/pe/index.html
