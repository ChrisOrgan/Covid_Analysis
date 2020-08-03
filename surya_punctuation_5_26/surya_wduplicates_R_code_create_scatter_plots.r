# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.12
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.2.1
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table(
  "surya_wduplicates_R_data_path_lengths_nodes_region.txt",
  sep = "\t"
)
colnames(dat) <- c("genome", "path", "node", "continent")
dat_out <- read.table("surya_wduplicates_R_output_outliers.txt")
colnames(dat_out) <- c("outlier")
dat_edit <- dat[!dat$genome %in% as.character(dat_out$outlier), ]

# Plot scatter plots ----
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.0000005895564 + 0.0000008291602*min(dat$node),
      yend = 0.0000005895564 + 0.0000008291602*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")
plot_reg_alpha <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray", alpha = 0.3) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.0000005895564 + 0.0000008291602*min(dat$node),
      yend = 0.0000005895564 + 0.0000008291602*max(dat$node),
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
      y = 0.0000005898981 + 0.0000008288184*min(dat_edit$node),
      yend = 0.0000005898981 + 0.0000008288184*max(dat_edit$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")
plot_reg_out_alpha <-
  ggplot(dat_edit, aes(node, path)) +
    geom_point(color = "gray", alpha = 0.25) +
    geom_segment(
      x = min(dat_edit$node),
      xend = max(dat_edit$node),
      y = 0.0000005898981 + 0.0000008288184*min(dat_edit$node),
      yend = 0.0000005898981 + 0.0000008288184*max(dat_edit$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations/site)\n")
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
CairoPDF("surya_wduplicates_figure_punctuation.pdf", width = 6.535,
         height = 4.039)
print(plot_reg)
graphics.off()
CairoSVG("surya_wduplicates_figure_punctuation.svg", width = 6.535,
         height = 4.039)
print(plot_reg)
graphics.off()
CairoPDF("surya_wduplicates_figure_punctuation_alpha.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_alpha)
graphics.off()
CairoSVG("surya_wduplicates_figure_punctuation_alpha.svg", width = 6.535,
         height = 4.039)
print(plot_reg_alpha)
graphics.off()
CairoPDF("surya_wduplicates_figure_punctuation_no_outliers.pdf", width = 6.535,
         height = 4.039)
print(plot_reg_out)
graphics.off()
CairoSVG("surya_wduplicates_figure_punctuation_no_outliers.svg", width = 6.535,
         height = 4.039)
print(plot_reg_out)
graphics.off()
CairoPDF("surya_wduplicates_figure_punctuation_no_outliers_alpha.pdf",
         width = 6.535, height = 4.039)
print(plot_reg_out_alpha)
graphics.off()
CairoSVG("surya_wduplicates_figure_punctuation_no_outliers_alpha.svg",
         width = 6.535, height = 4.039)
print(plot_reg_out_alpha)
graphics.off()
## Interactive plots
saveWidget(
  widget = as_widget(plot_interactive),
  file = "surya_wduplicates_figure_punctuation_interactive.html"
)

# Should we need to plot 95% CIs, see:
# http://www.real-statistics.com/regression/confidence-and-prediction-intervals/
# https://statscalculator.com/tcriticalvaluecalculator?x1=0.05&x2=3958
