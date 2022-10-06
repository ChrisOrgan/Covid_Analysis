# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(ape)
library(Cairo)
library(ggplot2)
library(ggthemes)
library(nlme)


# Set memory limit ----
memory.limit(size = 6000000)

# Read tree ----
tree <- read.nexus(file = "sars_cov_2_tree_mol_v2_15019.nex")

# Read data ----
dat <- read.table(
  "sars_cov_2_data.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)
dat <- dat[match(tree$tip.label, rownames(dat)), ]
dat$node <- dat$node + 1  # to prevent logging zero

# Detect node-density artifact ----
corr <- corPagel(value = 1, phy = tree, fixed = TRUE)
w <- diag(vcv(phy = tree))
pgls <- gls(
  log(node) ~ log(path),
  data = dat,
  correlation = corr,
  weights = varFixed(~w),
  method = "ML"
)
beta <- exp(as.numeric(pgls$coefficients[1]))
delta <- as.numeric(pgls$coefficients[2])
sink("sars_cov_2_output_r_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n\n")
summary(pgls)
cat("\n")
cat(paste("Beta = ", beta, "\n", sep = ""))
cat(paste("Delta = ", delta, sep = ""))
cat("\n")
sink()

# Create a scatter plot ----
plot_bias <-
  ggplot(dat, aes(path, node)) +
    geom_point(color = "gray", size = 0.5) +
    stat_function(
      color = "red",
      size = 0.5,
      fun = function(path){beta * path^delta}
    ) +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nRoot-to-tip divergence", y = "Node count\n")

# Save the scatter plot ----
CairoPDF(
  file = "sars_cov_2_figure_node_density_artifact.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_bias)
graphics.off()
