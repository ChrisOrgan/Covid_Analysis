# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggimage)  # v0.2.8
library(ggtree)  # v1.14.6
library(phytools)  # v0.7-20
library(svglite)  # v1.2.3


# Load and prepare data ----
tree <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
meta <- meta[match(dat$V1, meta$Strain), ]
dat$continent <- meta$Region
con_samerica <- as.character(dat$V1[dat$continent == "South America"])
con_africa <- as.character(dat$V1[dat$continent == "Africa"])
con_oceania <- as.character(dat$V1[dat$continent == "Oceania"])
con_namerica <- as.character(dat$V1[dat$continent == "North America"])
con_euro <- as.character(dat$V1[dat$continent == "Europe"])
con_asia <- as.character(dat$V1[dat$continent == "Asia"])
continents <- list(con_samerica, con_africa, con_oceania, con_namerica,
                   con_euro, con_asia)
names(continents) <- c("South America", "Africa", "Oceania", "North America",
                       "Europe", "Asia")

# Plot tree ----
tree_plot <- groupOTU(tree, continents)
plot_tree <-
  ggtree(tree_plot, aes(color = group), size = 0.1) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")

# Save tree plot ----
CairoPDF("surya_figure_tree_molecular_branches.pdf", width = 4, height = 6)
print(plot_tree)
graphics.off()
CairoSVG("surya_figure_tree_molecular_branches.svg", width = 4, height = 6)
print(plot_tree)
graphics.off()
