# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggimage)
library(ggtree)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2020_december_tree_v3_11275.nex")

# Read and prepare data ----
dat <- read.table(
  "sars_cov_2_2020_december_data_11275.txt",
  sep = "\t",
  header = TRUE
)
con_samerica <- as.character(dat$genome[dat$continent == "South America"])
con_africa <- as.character(dat$genome[dat$continent == "Africa"])
con_oceania <- as.character(dat$genome[dat$continent == "Oceania"])
con_namerica <- as.character(dat$genome[dat$continent == "North America"])
con_euro <- as.character(dat$genome[dat$continent == "Europe"])
con_asia <- as.character(dat$genome[dat$continent == "Asia"])
continents <- list(con_samerica, con_africa, con_oceania, con_namerica,
                   con_euro, con_asia)
names(continents) <- c("South America", "Africa", "Oceania", "North America",
                       "Europe", "Asia")

# Plot tree ----
tree_plot <- groupOTU(tree, continents)
plot_tree <-
  ggtree(tree_plot, aes(color = group), size = 0.1) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "subs/site")

# Save the tree plot ----
CairoPDF(
  file = "sars_cov_2_2020_december_figure_tree_11275.pdf",
  width = 4.75,
  height = 5.88
)
print(plot_tree)
graphics.off()
