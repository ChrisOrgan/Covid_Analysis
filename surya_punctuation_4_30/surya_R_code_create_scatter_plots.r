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
  "nextstrain_ncov_non-subsampled_2020-04-30_metadata.tsv",
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

# Plot scatter plots ----
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.000373140443584496 + 0.0000069967*min(dat$node),
      yend = 0.000373140443584496 + 0.0000069967*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (mutations)\n")
## Interactive plot
plot_interactive <-
  ggplot(dat, aes(node, path, color = continent, label = genome)) +
    geom_point() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(
      x = "Node count",
      y = "Total path length (mutations)"
    )
plot_interactive <- ggplotly(plot_interactive)

# Save scatter plots ----
CairoPDF("surya_figure_punctuation.pdf", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
CairoSVG("surya_figure_punctuation.svg", width = 6.535, height = 4.039)
print(plot_reg)
graphics.off()
## Interactive plots
saveWidget(
  widget = as_widget(plot_interactive),
  file = "surya_figure_punctuation_interactive.html"
)
