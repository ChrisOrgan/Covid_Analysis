# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggimage)
library(ggtree)
library(phytools)


# Read tree ----
tree <- read.nexus(file = "sars_cov_2_2021_march_tree_v3_12618.nex")

# Read and prepare data ----
dat <- read.table(
  "sars_cov_2_2021_march_data_12618.txt",
  sep = "\t",
  header = TRUE
)
b117_0 <- as.character(dat$genome[dat$b117 == 0])
b117_1 <- as.character(dat$genome[dat$b117 == 1])
b117 <- list(b117_0, b117_1)
names(b117) <- c("others", "B.1.1.7")

# Plot tree ----
tree_plot <- groupOTU(tree, b117)
plot_tree <-
  ggtree(tree_plot, aes(color = group), size = 0.1) +
    scale_color_manual(values = c("#F8766D", "gray")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "subs/site")

# Save the tree plot ----
CairoPDF(
  file = "sars_cov_2_2021_march_figure_tree_12618.pdf",
  width = 4.75,
  height = 5.88
)
print(plot_tree)
graphics.off()
