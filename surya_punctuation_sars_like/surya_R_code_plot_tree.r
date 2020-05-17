# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggimage)  # v0.2.8
library(ggtree)  # v1.14.6
library(phytools)  # v0.7-20
library(svglite)  # v1.2.3


# Read tree ----
tree <- read.nexus(file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
## ggtree is very sensitive with colnames; don't change them!
meta <- read.delim(
  "nextstrain_groups_blab_sars-like-cov_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
meta <- meta[match(dat$V1, meta$Strain), ]
dat$virus_type <- meta$virus.type

# Plot tree ----
plot_tree <-
  ggtree(tree) %<+% dat +
    xlim(0, 0.35) +
    geom_tiplab(size = 2, offset = 0.005) +
    geom_tippoint(aes(color = virus_type), size = 1.75) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "substitutions/site")

# Save plot ----
CairoPDF("surya_figure_punctuation_sars_like_tree.pdf", width = 6,
         height = 5)
print(plot_tree)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_tree.svg", width = 6,
         height = 5)
print(plot_tree)
graphics.off()
