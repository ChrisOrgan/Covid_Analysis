# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(caper)  # v1.0.1
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(nlme)  # v3.1.147
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
## tree_rate <- read.nexus(file = "surya_tree_rate_v2.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
rownames(dat) <- dat$genome
dat$node <- dat$node + 1  # This addition prevents log-transforming zero
dat <- dat[match(tree$tip.label, rownames(dat)), ]
dat_caper <- comparative.data(
  phy = tree,
  data = dat,
  names.col = "genome",
  force.root = TRUE  # This function doesn't accept a tree with a basal polytomy
)
## dat_rate <- read.table(
##   "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
##   sep = "\t"
## )
## colnames(dat_rate) <- c("genome", "path", "node")
## rownames(dat_rate) <- dat_rate$genome
## dat_rate <- dat_rate[, -1]
## dat_rate$node <- dat_rate$node + 1

# Define variance-covariance matrices ----
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)
## vcv_rate <- corPagel(value = 1, phy = tree_rate)  # infinite beta*

# Define variance weights ----
vf <- diag(vcv(tree))

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
sink("surya_R_output_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Delta = ", delta, sep = ""))
cat("\n")
sink()
pgls_reml <- gls(
  log(node) ~ log(path),
  data = dat,
  correlation = corr,
  weights = varFixed(~vf),
  method = "REML"
)
## Try REML
beta_reml <- exp(as.numeric(pgls_reml$coefficients[1]))
delta_reml <- as.numeric(pgls_reml$coefficients[2])
sink("surya_R_output_node_density_artifact_reml.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls_reml)
cat("\n")
cat(paste("Delta = ", delta_reml, sep = ""))
cat("\n")
sink()
## Force the tree as rooted while keeping the basal polytomy
tree_force <- tree
tree_force$root.edge <- 0
corr_force <- corPagel(value = 1, phy = tree_force, fixed = TRUE)
vf_force <- diag(vcv(tree_force))
pgls_root <- gls(
  log(node) ~ log(path),
  data = dat,
  correlation = corr_force,
  weights = varFixed(~vf_force),
  method = "ML"
)
beta_root <- exp(as.numeric(pgls_root$coefficients[1]))
delta_root <- as.numeric(pgls_root$coefficients[2])
sink("surya_R_output_node_density_artifact_root.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls_root)
cat("\n")
cat(paste("Delta = ", delta_root, sep = ""))
cat("\n")
sink()
## The variance-covariance matrix is singular unless we change the tolerance
## Polytomies and or duplicate sequences may be the culprits
## See http://blog.phytools.org/2013/01/
## Set tol = 2e-18 for all `solve` functions in `caper`
trace(caper::pgls, edit = TRUE)
trace(caper::pgls.likelihood, edit = TRUE)
pgls_caper <- pgls(log(node) ~ log(path), data = dat_caper)
sum_caper <- summary(pgls_caper)
beta_caper <- exp(sum_caper$coefficients[1])
delta_caper <- sum_caper$coefficients[2]
sink("surya_R_output_node_density_artifact_caper.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
sum_caper
cat("\n")
cat(paste("Delta = ", delta_caper, sep = ""))
cat("\n")
sink()

## pgls_rate <- gls(
##   log(node) ~ log(path),
##   data = dat_rate,
##   correlation = vcv_rate
## )
## beta_rate <- exp(as.numeric(pgls_rate$coefficients[1]))
## delta_rate <- as.numeric(pgls_rate$coefficients[2])
## sink("surya_R_output_node_density_artifact_rate.txt")
## cat("=================\n")
## cat("Node-Density Test\n")
## cat("=================\n\n")
## summary(pgls_rate)
## cat("\n")
## cat(paste("Delta = ", round(delta_rate, 3), sep = ""))
## cat("\n")
## sink()

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
## plot_bias_rate <-
##   ggplot(dat_rate, aes(path, node)) +
##     geom_point(color = "gray", size = 0.5) +
##     stat_function(
##       color = "red",
##       size = 1,
##       fun = function(path_rate){beta_rate * path_rate^delta_rate}
##     ) +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     labs(x = "\nTotal path lengths", y = "Node count\n")

# Save scatter plots ----
CairoPDF("surya_figure_punctuation_node_density_artifact.pdf", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
CairoSVG("surya_figure_punctuation_node_density_artifact.svg", width = 3.2675,
         height = 3.2675)
print(plot_bias)
graphics.off()
## CairoPDF("surya_figure_punctuation_rate_node_density_artifact.pdf",
##          width = 3.2675, height = 3.2675)
## print(plot_bias_rate)
## graphics.off()
## CairoSVG("surya_figure_punctuation_rate_node_density_artifact.svg",
##          width = 3.2675, height = 3.2675)
## print(plot_bias_rate)
## graphics.off()
