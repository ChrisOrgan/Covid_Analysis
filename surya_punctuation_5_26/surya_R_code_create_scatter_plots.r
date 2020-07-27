# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.2.1
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_R_data_path_lengths_nodes_region.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node", "continent")
## dat_africa <- dat[dat$continent == "Africa", ]
## dat_asia <- dat[dat$continent == "Asia", ]
## dat_europe <- dat[dat$continent == "Europe", ]
## dat_namerica <- dat[dat$continent == "North America", ]
## dat_oceania <- dat[dat$continent == "Oceania", ]
## dat_samerica <- dat[dat$continent == "South America", ]
dat_out <- read.table("surya_R_output_outliers.txt")
colnames(dat_out) <- c("outlier")
dat_edit <- dat[!dat$genome %in% as.character(dat_out$outlier), ]

# Plot scatter plots ----
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.00000321034 + 0.000002329885*min(dat$node),
      yend = 0.00000321034 + 0.000002329885*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")
plot_reg_out <-
  ggplot(dat_edit, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat_edit$node),
      xend = max(dat_edit$node),
      y = 0.000003214526 + 0.000002327492*min(dat_edit$node),
      yend = 0.000003214526 + 0.000002327492*max(dat_edit$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")
## plot_reg_region_africa <-
##   ggplot(dat_africa, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     ## see https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
##     geom_segment(
##       x = min(dat_africa$node),
##       xend = max(dat_africa$node),
##       y = 0.0004647718 + 0.000003203409*min(dat_africa$node),
##       yend = 0.0004647718 + 0.000003203409*max(dat_africa$node),
##       color = "#F8766D",
##       size = 1
##     ) +
##     scale_color_manual(values = "#F8766D") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_region_asia <-
##   ggplot(dat_asia, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_asia$node),
##       xend = max(dat_asia$node),
##       y = 0.000461029103 + 0.00000321345824*min(dat_asia$node),
##       yend = 0.000461029103 + 0.00000321345824*max(dat_asia$node),
##       color = "#B79F00",
##       size = 1
##     ) +
##     scale_color_manual(values = "#B79F00") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_region_europe <-
##   ggplot(dat_europe, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_europe$node),
##       xend = max(dat_europe$node),
##       y = 0.0004645683563 + 0.000003202197223*min(dat_europe$node),
##       yend = 0.0004645683563 + 0.000003202197223*max(dat_europe$node),
##       color = "#00BA38",
##       size = 1
##     ) +
##     scale_color_manual(values = "#00BA38") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_region_namerica <-
##   ggplot(dat_namerica, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_namerica$node),
##       xend = max(dat_namerica$node),
##       y = 0.0004643728746 + 0.000003203400099621*min(dat_namerica$node),
##       yend = 0.0004643728746 + 0.000003203400099621*max(dat_namerica$node),
##       color = "#00BFC4",
##       size = 1
##     ) +
##     scale_color_manual(values = "#00BFC4") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_region_oceania <-
##   ggplot(dat_oceania, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_oceania$node),
##       xend = max(dat_oceania$node),
##       y = 0.0004644733968 + 0.000003202003727*min(dat_oceania$node),
##       yend = 0.0004644733968 + 0.000003202003727*max(dat_oceania$node),
##       color = "#619CFF",
##       size = 1
##     ) +
##     scale_color_manual(values = "#619CFF") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_region_samerica <-
##   ggplot(dat_samerica, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_samerica$node),
##       xend = max(dat_samerica$node),
##       y = 0.000465820931 + 0.0000032026161899*min(dat_samerica$node),
##       yend = 0.000465820931 + 0.0000032026161899*max(dat_samerica$node),
##       color = "#F564E3",
##       size = 1
##     ) +
##     scale_color_manual(values = "#F564E3") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations/site)\n",
##       color = NULL
##     )
## plot_reg_pop_africa <-
##   ggplot(dat_africa, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_africa$node),
##       xend = max(dat_africa$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_africa$node) +
##           -0.0000000000000008059717*1340598113 +
##           0.000000000000000002531615*min(dat_africa$node)*1340598113,
##       yend = 0.0004648931 + 0.000003201553*max(dat_africa$node) +
##              -0.0000000000000008059717*1340598113 +
##              0.000000000000000002531615*max(dat_africa$node)*1340598113,
##       color = "#F8766D",
##       size = 1
##     ) +
##     scale_color_manual(values = "#F8766D") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## plot_reg_pop_asia <-
##   ggplot(dat_asia, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_asia$node),
##       xend = max(dat_asia$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_asia$node) +
##           -0.0000000000000008059717*4641054786 +
##           0.000000000000000002531615*min(dat_asia$node)*4641054786,
##       yend = 0.0004648931 + 0.000003201553*max(dat_asia$node) +
##              -0.0000000000000008059717*4641054786 +
##              0.000000000000000002531615*max(dat_asia$node)*4641054786,
##       color = "#B79F00",
##       size = 1
##     ) +
##     scale_color_manual(values = "#B79F00") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## plot_reg_pop_europe <-
##   ggplot(dat_europe, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_europe$node),
##       xend = max(dat_europe$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_europe$node) +
##           -0.0000000000000008059717*747636045 +
##           0.000000000000000002531615*min(dat_europe$node)*747636045,
##       yend = 0.0004648931 + 0.000003201553*max(dat_europe$node) +
##              -0.0000000000000008059717*747636045 + 
##              0.000000000000000002531615*max(dat_europe$node)*747636045,
##       color = "#00BA38",
##       size = 1
##     ) +
##     scale_color_manual(values = "#00BA38") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## plot_reg_pop_namerica <-
##   ggplot(dat_namerica, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_namerica$node),
##       xend = max(dat_namerica$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_namerica$node) +
##           -0.0000000000000008059717*368092846 +
##           0.000000000000000002531615*min(dat_namerica$node)*368092846,
##       yend = 0.0004648931 + 0.000003201553*max(dat_namerica$node) +
##              -0.0000000000000008059717*368092846 + 
##              0.000000000000000002531615*max(dat_namerica$node)*368092846,
##       color = "#00BFC4",
##       size = 1
##     ) +
##     scale_color_manual(values = "#00BFC4") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## plot_reg_pop_oceania <-
##   ggplot(dat_oceania, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_oceania$node),
##       xend = max(dat_oceania$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_oceania$node) +
##           -0.0000000000000008059717*42677809 +
##           0.000000000000000002531615*min(dat_oceania$node)*42677809,
##       yend = 0.0004648931 + 0.000003201553*max(dat_oceania$node) +
##              -0.0000000000000008059717*42677809 + 
##              0.000000000000000002531615*max(dat_oceania$node)*42677809,
##       color = "#619CFF",
##       size = 1
##     ) +
##     scale_color_manual(values = "#619CFF") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## plot_reg_pop_samerica <-
##   ggplot(dat_samerica, aes(node, path, color = continent)) +
##     xlim(min(dat$node), max(dat$node)) +
##     ylim(min(dat$path), max(dat$path)) +
##     geom_segment(
##       x = min(dat$node),
##       xend = max(dat$node),
##       y = 0.0004632172 + 0.000003205359*min(dat$node),
##       yend = 0.0004632172 + 0.000003205359*max(dat$node),
##       color = "gainsboro",
##       size = 0.5
##     ) +
##     geom_point(size = 1) +
##     geom_segment(
##       x = min(dat_samerica$node),
##       xend = max(dat_samerica$node),
##       y = 0.0004648931 + 0.000003201553*min(dat_samerica$node) +
##           -0.0000000000000008059717*653739130 +
##           0.000000000000000002531615*min(dat_samerica$node)*653739130,
##       yend = 0.0004648931 + 0.000003201553*max(dat_samerica$node) +
##              -0.0000000000000008059717*653739130 + 
##              0.000000000000000002531615*max(dat_samerica$node)*653739130,
##       color = "#F564E3",
##       size = 1
##     ) +
##     scale_color_manual(values = "#F564E3") +
##     theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
##     theme(
##       legend.direction = "vertical",
##       legend.position = "right"
##     ) +
##     labs(
##       x = "\nNode count",
##       y = "Total path length (mutations)\n",
##       color = NULL
##     )
## Interactive plots
plot_interactive <-
  ggplot(dat, aes(node, path, color = continent, label = genome)) +
    geom_point(alpha = 0.4) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(
      x = "Node count",
      y = "Total path length (mutations/site)"
    )
plot_interactive <- ggplotly(plot_interactive)

# Save scatter plots ----
CairoPDF("surya_figure_punctuation.pdf", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoSVG("surya_figure_punctuation.svg", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoPDF("surya_figure_punctuation_no_outliers.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_out)
graphics.off()
CairoSVG("surya_figure_punctuation_no_outliers.svg", width = 6.535,
         height = 4.039)
print(plot_reg_out)
graphics.off()
## CairoPDF("surya_figure_punctuation_region_africa.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_africa)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_africa.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_africa)
## graphics.off()
## CairoPDF("surya_figure_punctuation_region_asia.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_asia)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_asia.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_asia)
## graphics.off()
## CairoPDF("surya_figure_punctuation_region_europe.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_europe)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_europe.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_europe)
## graphics.off()
## CairoPDF("surya_figure_punctuation_region_north_america.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_namerica)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_north_america.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_namerica)
## graphics.off()
## CairoPDF("surya_figure_punctuation_region_oceania.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_oceania)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_oceania.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_oceania)
## graphics.off()
## CairoPDF("surya_figure_punctuation_region_south_america.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_samerica)
## graphics.off()
## CairoSVG("surya_figure_punctuation_region_south_america.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_region_samerica)
## graphics.off()
## CairoPDF("surya_figure_punctuation_pop_africa.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_africa)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_africa.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_africa)
## CairoPDF("surya_figure_punctuation_pop_asia.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_asia)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_asia.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_asia)
## graphics.off()
## CairoPDF("surya_figure_punctuation_pop_europe.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_europe)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_europe.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_europe)
## graphics.off()
## CairoPDF("surya_figure_punctuation_pop_namerica.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_namerica)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_namerica.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_namerica)
## graphics.off()
## CairoPDF("surya_figure_punctuation_pop_oceania.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_oceania)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_oceania.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_oceania)
## graphics.off()
## CairoPDF("surya_figure_punctuation_pop_samerica.pdf", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_samerica)
## graphics.off()
## CairoSVG("surya_figure_punctuation_pop_samerica.svg", width = 6.535,
##          height = 4.039)
## print(plot_reg_pop_samerica)
## graphics.off()
## Interactive plots
saveWidget(
  widget = as_widget(plot_interactive),
  file = "surya_figure_punctuation_interactive.html"
)

# Should we need to plot 95% CIs, see:
# http://www.real-statistics.com/regression/confidence-and-prediction-intervals/
# https://statscalculator.com/tcriticalvaluecalculator?x1=0.05&x2=3958
