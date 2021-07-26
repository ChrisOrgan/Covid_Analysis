# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggimage)
library(ggtree)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sarbecovirus_tree_mol_v3_51.nex")

# Read and prepare data ----
dat <- read.table(
  "sarbecovirus_data_v2_without_outliers.txt",
  sep = "\t",
  header = TRUE
)
host_human <- as.character(dat$genome[dat$host == "Human"])
host_bat <- as.character(dat$genome[dat$host == "Bat"])
hosts <- list(host_human, host_bat)
names(hosts) <- c("Human", "Bat")

# Plot tree ----
tree_plot <- groupOTU(tree, hosts)
plot_tree <-
  ggtree(tree_plot, aes(color = group), size = 0.3) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "subs/site")

# Save the tree plot ----
CairoPDF(
  file = "sarbecovirus_figure_tree_v2_without_outliers.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_tree)
graphics.off()
