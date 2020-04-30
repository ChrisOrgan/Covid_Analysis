# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(ggtree)  # v1.14.6
library(phytools)  # v0.7-20
library(svglite)  # v1.2.3


# Read trees ----
tree_punctuation <- read.newick(file = "surya_tree_punctuation.nwk")
tree_gradual <- read.newick(file = "surya_tree_gradual.nwk")
tree_negative <- read.newick(file = "surya_tree_negative.nwk")

# Plot trees ----
plot_tree_punc <-
  ggtree(tr = tree_punctuation) +
    geom_tippoint(aes(color = "#F8766D")) +
    scale_color_manual(values = "#F8766D")
plot_tree_grad <-
  ggtree(tr = tree_gradual) +
    geom_tippoint(aes(color = "#00BA38")) +
    scale_color_manual(values = "#00BA38")
plot_tree_neg <-
  ggtree(tr = tree_negative) +
    geom_tippoint(aes(color = "#619CFF")) +
    scale_color_manual(values = "#619CFF")

# Save tree plots ----
CairoSVG("surya_figure_tree_punctuation.svg", width = 2.0445, height = 2.1783)
print(plot_tree_punc)
graphics.off()
CairoSVG("surya_figure_tree_gradual.svg", width = 2.0445, height = 2.1783)
print(plot_tree_grad)
graphics.off()
CairoSVG("surya_figure_tree_negative.svg", width = 2.0445, height = 2.1783)
print(plot_tree_neg)
graphics.off()

# Plot regression scatter plots ----
path <- c(1, 2, 3)
node <- c(0, 1, 2)
dat_punc <- data.frame(path, node)
plot_punc <-
  ggplot(dat_punc, aes(node, path)) +
    geom_segment(
      x = min(dat_punc$node),
      xend = max(dat_punc$node),
      y = min(dat_punc$path),
      yend = max(dat_punc$path),
      color = "black"
    ) +
    geom_point(color = "#F8766D") +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank()) +
    labs(x = "\nNumber of nodes", y = "Total path length\n")
path <- c(3, 3, 3)
node <- c(0, 1, 2)
dat_grad <- data.frame(path, node)
plot_grad <-
  ggplot(dat_grad, aes(node, path)) +
    xlim(min(dat_punc$node), max(dat_punc$node)) +
    ylim(min(dat_punc$path), max(dat_punc$path)) +
    geom_segment(
      x = min(dat_grad$node),
      xend = max(dat_grad$node),
      y = max(dat_grad$path),
      yend = max(dat_grad$path),
      color = "black"
    ) +
    geom_point(color = "#00BA38") +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank()) +
    labs(x = "\nNumber of nodes", y = "Total path length\n")
path <- c(1, 2, 3)
node <- c(2, 1, 0)
dat_neg <- data.frame(path, node)
plot_neg <-
  ggplot(dat_neg, aes(node, path)) +
    xlim(min(dat_punc$node), max(dat_punc$node)) +
    ylim(min(dat_punc$path), max(dat_punc$path)) +
    geom_segment(
      x = min(dat_neg$node),
      xend = max(dat_neg$node),
      y = max(dat_neg$path),
      yend = min(dat_neg$path),
      color = "black"
    ) +
    geom_point(color = "#619CFF") +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    theme(axis.text.x = element_blank(), axis.text.y = element_blank()) +
    labs(x = "\nNumber of nodes", y = "Total path length\n")

# Save regression scatter plots ----
CairoSVG("surya_figure_regression_punctuation.svg", width = 2.1783,
         height = 2.0445)
print(plot_punc)
graphics.off()
CairoSVG("surya_figure_regression_gradual.svg", width = 2.1783, height = 2.0445)
print(plot_grad)
graphics.off()
CairoSVG("surya_figure_regression_negative.svg", width = 2.1783,
         height = 2.0445)
print(plot_neg)
graphics.off()
