# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.2.1
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$Region)
colnames(dat)[4] <- "continent"
dat_africa <- dat[dat$continent == "Africa", ]
dat_asia <- dat[dat$continent == "Asia", ]
dat_europe <- dat[dat$continent == "Europe", ]
dat_namerica <- dat[dat$continent == "North America", ]
dat_oceania <- dat[dat$continent == "Oceania", ]
dat_samerica <- dat[dat$continent == "South America", ]
dat_rate <- read.table(
  "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
  sep = "\t"
)
colnames(dat_rate) <- c("genome", "path", "node")
meta_rate <- meta
drop_list <- c("Iceland/104/2020", "England/20134078904/2020",
               "Wales/PHWC-2559D/2020", "Scotland/EDB119/2020",
               "Scotland/EDB120/2020", "Scotland/EDB099/2020",
               "Scotland/EDB098/2020")
meta_rate <- meta_rate[!meta_rate$Strain %in% drop_list, ]
dat_rate <- dat_rate[match(meta_rate$Strain, dat_rate$genome), ]
dat_rate <- cbind(dat_rate, meta_rate$Region)
colnames(dat_rate)[4] <- "continent"
dat_rate_africa <- dat_rate[dat_rate$continent == "Africa", ]
dat_rate_asia <- dat_rate[dat_rate$continent == "Asia", ]
dat_rate_europe <- dat_rate[dat_rate$continent == "Europe", ]
dat_rate_namerica <- dat_rate[dat_rate$continent == "North America", ]
dat_rate_oceania <- dat_rate[dat_rate$continent == "Oceania", ]
dat_rate_samerica <- dat_rate[dat_rate$continent == "South America", ]

# Plot scatter plots ----
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL
    )
plot_region <-
  ggplot(dat, aes(node, path, color = continent)) +
    geom_jitter(size = 0.75, height = 0.2, width = 0.2, alpha = 0.3) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region <-
  ggplot(dat, aes(node, path, color = continent)) +
    geom_point(size = 0.75, alpha = 0.1) +
    geom_segment(
      x = min(dat_africa$node),
      xend = max(dat_africa$node),
      y = 7.399117120309 + 0.244231555262*min(dat_africa$node),
      yend = 7.399117120309 + 0.244231555262*max(dat_africa$node),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      x = min(dat_asia$node),
      xend = max(dat_asia$node),
      y = -2.392610646453 + 0.811741351289*min(dat_asia$node),
      yend = -2.392610646453 + 0.811741351289*max(dat_asia$node),
      color = "#B79F00",
      size = 1
    ) +
    geom_segment(
      x = min(dat_europe$node),
      xend = max(dat_europe$node),
      y = 13.239131460533 + -0.359224246134*min(dat_europe$node),
      yend = 13.239131460533 + -0.359224246134*max(dat_europe$node),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      x = min(dat_namerica$node),
      xend = max(dat_namerica$node),
      y = 2.874872765671 + 0.274321504554*min(dat_namerica$node),
      yend = 2.874872765671 + 0.274321504554*max(dat_namerica$node),
      color = "#00BFC4",
      size = 1
    ) +
    geom_segment(
      x = min(dat_oceania$node),
      xend = max(dat_oceania$node),
      y = 22.058314121794 + -0.992735546963*min(dat_oceania$node),
      yend = 22.058314121794 + -0.992735546963*max(dat_oceania$node),
      color = "#619CFF",
      size = 1
    ) +
    geom_segment(
      x = min(dat_samerica$node),
      xend = max(dat_samerica$node),
      y = 38.583500810899 + -4.448433729704*min(dat_samerica$node),
      yend = 38.583500810899 + -4.448433729704*max(dat_samerica$node),
      color = "#F564E3",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_africa <-
  ggplot(dat_africa, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    ## see https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
    geom_segment(
      x = min(dat_africa$node),
      xend = max(dat_africa$node),
      y = 7.399117120309 + 0.244231555262*min(dat_africa$node),
      yend = 7.399117120309 + 0.244231555262*max(dat_africa$node),
      color = "#F8766D",
      size = 1
    ) +
    scale_color_manual(values = "#F8766D") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_asia <-
  ggplot(dat_asia, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    geom_segment(
      x = min(dat_asia$node),
      xend = max(dat_asia$node),
      y = -2.392610646453 + 0.811741351289*min(dat_asia$node),
      yend = -2.392610646453 + 0.811741351289*max(dat_asia$node),
      color = "#B79F00",
      size = 1
    ) +
    scale_color_manual(values = "#B79F00") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_europe <-
  ggplot(dat_europe, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    geom_segment(
      x = min(dat_europe$node),
      xend = max(dat_europe$node),
      y = 13.239131460533 + -0.359224246134*min(dat_europe$node),
      yend = 13.239131460533 + -0.359224246134*max(dat_europe$node),
      color = "#00BA38",
      size = 1
    ) +
    scale_color_manual(values = "#00BA38") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_namerica <-
  ggplot(dat_namerica, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    geom_segment(
      x = min(dat_namerica$node),
      xend = max(dat_namerica$node),
      y = 2.874872765671 + 0.274321504554*min(dat_namerica$node),
      yend = 2.874872765671 + 0.274321504554*max(dat_namerica$node),
      color = "#00BFC4",
      size = 1
    ) +
    scale_color_manual(values = "#00BFC4") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_oceania <-
  ggplot(dat_oceania, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    geom_segment(
      x = min(dat_oceania$node),
      xend = max(dat_oceania$node),
      y = 22.058314121794 + -0.992735546963*min(dat_oceania$node),
      yend = 22.058314121794 + -0.992735546963*max(dat_oceania$node),
      color = "#619CFF",
      size = 1
    ) +
    scale_color_manual(values = "#619CFF") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_region_samerica <-
  ggplot(dat_samerica, aes(node, path, color = continent)) +
    xlim(min(dat$node), max(dat$node)) +
    ylim(min(dat$path), max(dat$path)) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 8.37994550358 + -0.06281616049*min(dat$node),
      yend = 8.37994550358 + -0.06281616049*max(dat$node),
      color = "gainsboro",
      size = 0.5
    ) +
    geom_point(size = 1) +
    geom_segment(
      x = min(dat_samerica$node),
      xend = max(dat_samerica$node),
      y = 38.583500810899 + -4.448433729704*min(dat_samerica$node),
      yend = 38.583500810899 + -4.448433729704*max(dat_samerica$node),
      color = "#F564E3",
      size = 1
    ) +
    scale_color_manual(values = "#F564E3") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
plot_reg_rate <-
  ggplot(dat_rate, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat_rate$node),
      xend = max(dat_rate$node),
      y = 367.834030128746 + 4.550054972442*min(dat_rate$node),
      yend = 367.834030128746 + 4.550054972442*max(dat_rate$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths (mutations/year)\n",
      x = "\nNumber of Nodes",
      y = NULL
    )
plot_region_rate <-
  ggplot(dat_rate, aes(node, path, color = continent)) +
    geom_jitter(size = 0.75, height = 0.2, width = 0.2, alpha = 0.3) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations/year)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
## Interactive plots
plot_interactive <-
  ggplot(dat, aes(node, path, color = continent, label = genome)) +
    geom_jitter(height = 0.25, width = 0.25, alpha = 0.4) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(
      x = "Number of Nodes",
      y = "Total Path Lengths (mutations)"
    )
plot_interactive <- ggplotly(plot_interactive)

# Save scatter plots ----
CairoPDF("surya_figure_punctuation.pdf", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoSVG("surya_figure_punctuation.svg", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoPDF("surya_figure_punctuation_region.pdf", width = 6.535, height = 4.039)
print(plot_region)
graphics.off()
CairoSVG("surya_figure_punctuation_region.svg", width = 6.535, height = 4.039)
print(plot_region)
graphics.off()
CairoPDF("surya_figure_punctuation_region_lines.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region)
graphics.off()
CairoSVG("surya_figure_punctuation_region_lines.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region)
graphics.off()
CairoPDF("surya_figure_punctuation_region_africa.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_africa)
graphics.off()
CairoSVG("surya_figure_punctuation_region_africa.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_africa)
graphics.off()
CairoPDF("surya_figure_punctuation_region_asia.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_asia)
graphics.off()
CairoSVG("surya_figure_punctuation_region_asia.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_asia)
graphics.off()
CairoPDF("surya_figure_punctuation_region_europe.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_europe)
graphics.off()
CairoSVG("surya_figure_punctuation_region_europe.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_europe)
graphics.off()
CairoPDF("surya_figure_punctuation_region_north_america.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_namerica)
graphics.off()
CairoSVG("surya_figure_punctuation_region_north_america.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_namerica)
graphics.off()
CairoPDF("surya_figure_punctuation_region_oceania.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_oceania)
graphics.off()
CairoSVG("surya_figure_punctuation_region_oceania.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_oceania)
graphics.off()
CairoPDF("surya_figure_punctuation_region_south_america.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_region_samerica)
graphics.off()
CairoSVG("surya_figure_punctuation_region_south_america.svg", width = 6.535,
         height = 4.039)
print(plot_reg_region_samerica)
graphics.off()
CairoPDF("surya_figure_punctuation_rate.pdf", width = 6.535, height = 4.039)
print(plot_reg_rate)
graphics.off()
CairoSVG("surya_figure_punctuation_rate.svg", width = 6.535, height = 4.039)
print(plot_reg_rate)
graphics.off()
CairoPDF("surya_figure_punctuation_rate_region.pdf", width = 6.535,
         height = 4.039)
print(plot_region_rate)
graphics.off()
CairoSVG("surya_figure_punctuation_rate_region.svg", width = 6.535,
         height = 4.039)
print(plot_region_rate)
graphics.off()
## Interactive plots
saveWidget(
  widget = as_widget(plot_interactive),
  file = "surya_figure_punctuation_interactive.html"
)

# Should we need to plot 95% CIs, see:
# http://www.real-statistics.com/regression/confidence-and-prediction-intervals/
# https://statscalculator.com/tcriticalvaluecalculator?x1=0.05&x2=3958
