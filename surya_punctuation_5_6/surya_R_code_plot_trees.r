# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(ggimage)  # v0.2.8
library(ggtree)  # v1.14.6
library(phytools)  # v0.7.20
library(svglite)  # v1.2.3


# Read trees ----
tree_mol <- read.nexus(file = "nextstrain_ncov_global_tree_v4.nex")
tree_time <- read.nexus(file = "nextstrain_ncov_global_timetree_v4.nex")
## tree_rate <- read.nexus(file = "surya_tree_rate_v2.nex")

# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
meta <- meta[match(dat$V1, meta$Strain), ]
dat$continent <- meta$Region
dat_africa <- dat
dat_africa$continent <- factor(
  dat_africa$continent,
  levels = c("Asia", "Europe", "North America", "Oceania", "South America",
             "Africa")
)
dat_asia <- dat
dat_asia$continent <- factor(
  dat_asia$continent,
  levels = c("Africa", "Europe", "North America", "Oceania", "South America",
             "Asia")
)
dat_europe <- dat
dat_europe$continent <- factor(
  dat_europe$continent,
  levels = c("Africa", "Asia", "North America", "Oceania", "South America",
             "Europe")
)
dat_namerica <- dat
dat_namerica$continent <- factor(
  dat_namerica$continent,
  levels = c("Africa", "Asia", "Europe", "Oceania", "South America",
             "North America")
)
dat_oceania <- dat
dat_oceania$continent <- factor(
  dat_oceania$continent,
  levels = c("Africa", "Asia", "Europe", "North America", "South America",
             "Oceania")
)
dat_samerica <- dat
dat_samerica$continent <- factor(
  dat_samerica$continent,
  levels = c("Africa", "Asia", "Europe", "Oceania", "North America",
             "South America")
)
## dat_rate <- read.table(
##   "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
##   sep = "\t"
## )
## meta_rate <- meta
## drop_list <- c("Iceland/104/2020", "England/20134078904/2020",
##                "Wales/PHWC-2559D/2020", "Scotland/EDB119/2020",
##                "Scotland/EDB120/2020", "Scotland/EDB099/2020",
##                "Scotland/EDB098/2020")
## meta_rate <- meta_rate[!meta_rate$Strain %in% drop_list, ]
## meta_rate <- meta_rate[match(dat_rate$V1, meta_rate$Strain), ]
## dat_rate$continent <- meta_rate$Region

# Plot trees ----
## plot_tree_mol <-
##   ggtree(tree_mol, color = "gray") %<+% dat +
##     geom_tippoint(aes(color = continent), size = 0.2) +
##     theme_tree2(legend = "right", legend.title = element_blank()) +
##     labs(caption = "mutations")
plot_tree_mol_africa <-
  ggtree(tree_mol) %<+% dat_africa +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#F8766D")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_mol_asia <-
  ggtree(tree_mol) %<+% dat_asia +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#B79F00")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_mol_europe <-
  ggtree(tree_mol) %<+% dat_europe +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#00BA38")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_mol_namerica <-
  ggtree(tree_mol) %<+% dat_namerica +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#00BFC4")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_mol_oceania <-
  ggtree(tree_mol) %<+% dat_oceania +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#619CFF")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_mol_samerica <-
  ggtree(tree_mol) %<+% dat_samerica +
    geom_tippoint(aes(color = continent), size = 0.1) +
    scale_color_manual(values = c(rep("black", 5), "#F564E3")) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "mutations")
plot_tree_time <-
  ggtree(tree_time) %<+% dat +
    geom_tippoint(aes(color = continent), size = 0.1) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "year")
## plot_tree_rate <-
##   ggtree(tree_rate) %<+% dat_rate +
##     geom_tippoint(aes(color = continent), size = 0.1) +
##     theme_tree2(legend = "right", legend.title = element_blank()) +
##     labs(caption = "mutations/year")

# Save tree plots ----
## CairoPDF("surya_figure_tree_molecular.pdf", width = 6.535, height = 7.21)
## print(plot_tree_mol)
## graphics.off()
## CairoSVG("surya_figure_tree_molecular.svg", width = 6.535, height = 7.21)
## print(plot_tree_mol)
## graphics.off()
CairoPDF("surya_figure_tree_molecular_region_africa.pdf", width = 4, height = 6)
print(plot_tree_mol_africa)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_africa.svg", width = 4, height = 6)
print(plot_tree_mol_africa)
graphics.off()
CairoPDF("surya_figure_tree_molecular_region_asia.pdf", width = 4, height = 6)
print(plot_tree_mol_asia)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_asia.svg", width = 4, height = 6)
print(plot_tree_mol_asia)
graphics.off()
CairoPDF("surya_figure_tree_molecular_region_europe.pdf", width = 4,
         height = 6)
print(plot_tree_mol_europe)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_europe.svg", width = 4,
         height = 6)
print(plot_tree_mol_europe)
graphics.off()
CairoPDF("surya_figure_tree_molecular_region_namerica.pdf", width = 4,
         height = 6)
print(plot_tree_mol_namerica)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_namerica.svg", width = 4,
         height = 6)
print(plot_tree_mol_namerica)
graphics.off()
CairoPDF("surya_figure_tree_molecular_region_oceania.pdf", width = 4,
         height = 6)
print(plot_tree_mol_oceania)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_oceania.svg", width = 4,
         height = 6)
print(plot_tree_mol_oceania)
graphics.off()
CairoPDF("surya_figure_tree_molecular_region_samerica.pdf", width = 4,
         height = 6)
print(plot_tree_mol_samerica)
graphics.off()
CairoSVG("surya_figure_tree_molecular_region_samerica.svg", width = 4,
         height = 6)
print(plot_tree_mol_samerica)
graphics.off()
CairoPDF("surya_figure_tree_time.pdf", width = 4, height = 6)
print(plot_tree_time)
graphics.off()
CairoSVG("surya_figure_tree_time.svg", width = 4, height = 6)
print(plot_tree_time)
graphics.off()
## CairoPDF("surya_figure_tree_rate.pdf", width = 4, height = 6)
## print(plot_tree_rate)
## graphics.off()
## CairoSVG("surya_figure_tree_rate.svg", width = 4, height = 6)
## print(plot_tree_rate)
## graphics.off()
