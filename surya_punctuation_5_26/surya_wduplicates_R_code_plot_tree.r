# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(ggimage)  # v0.2.8
library(ggtree)  # v1.14.6
library(phytools)  # v0.7.20
library(svglite)  # v1.2.3


# Load and prepare data ----
tree <- read.nexus(file = "tanner_wduplicates_tree.nex")
dat <- read.table(
  "surya_wduplicates_R_data_path_lengths_nodes_region.txt",
  sep = "\t"
)
con_samerica <- as.character(dat$V1[dat$V4 == "South America"])
con_africa <- as.character(dat$V1[dat$V4 == "Africa"])
con_oceania <- as.character(dat$V1[dat$V4 == "Oceania"])
con_namerica <- as.character(dat$V1[dat$V4 == "North America"])
con_euro <- as.character(dat$V1[dat$V4 == "Europe"])
con_asia <- as.character(dat$V1[dat$V4 == "Asia"])
continents <- list(con_samerica, con_africa, con_oceania, con_namerica,
                   con_euro, con_asia)
names(continents) <- c("South America", "Africa", "Oceania", "North America",
                       "Europe", "Asia")

# Plot tree ----
tree_plot <- groupOTU(tree, continents)
plot_tree <-
  ggtree(tree_plot, aes(color = group), size = 0.1) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations/site")
## Error in sys.parent() : node stack overflow
## The tree may be too large

# Randomly remove 4,237 sequences ----
drop_seq <- sample(tree$tip.label, size = 4237)
tree_edit <- drop.tip(phy = tree, tip = drop_seq)
dat_edit <- dat[!(dat$V1 %in% drop_seq), ]
con_samerica_edit <- as.character(dat_edit$V1[dat_edit$V4 == "South America"])
con_africa_edit <- as.character(dat_edit$V1[dat_edit$V4 == "Africa"])
con_oceania_edit <- as.character(dat_edit$V1[dat_edit$V4 == "Oceania"])
con_namerica_edit <- as.character(dat_edit$V1[dat_edit$V4 == "North America"])
con_euro_edit <- as.character(dat_edit$V1[dat_edit$V4 == "Europe"])
con_asia_edit <- as.character(dat_edit$V1[dat_edit$V4 == "Asia"])
continents_edit <- list(con_samerica_edit, con_africa_edit, con_oceania_edit,
                        con_namerica_edit, con_euro_edit, con_asia_edit)
names(continents_edit) <- c("South America", "Africa", "Oceania",
                            "North America", "Europe", "Asia")
tree_plot_edit <- groupOTU(tree_edit, continents_edit)
plot_tree_edit <-
  ggtree(tree_plot_edit, aes(color = group), size = 0.1) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations/site")

# Save tree plot ----
CairoPDF("surya_wduplicates_figure_tree.pdf", width = 4, height = 6)
print(plot_tree_edit)
graphics.off()
CairoSVG("surya_wduplicates_figure_tree.svg", width = 4, height = 6)
print(plot_tree_edit)
graphics.off()
