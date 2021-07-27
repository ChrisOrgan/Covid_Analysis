# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggimage)
library(ggtree)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_1_tree_mol_v2_53.nex")

# Plot tree ----
plot_tree <-
  ggtree(tree, size = 0.3) +
    theme_tree2() +
    labs(caption = "subs/site")

# Save the tree plot ----
CairoPDF(file = "sars_cov_1_figure_tree.pdf", width = 4.75, height = 2.94)
print(plot_tree)
graphics.off()
