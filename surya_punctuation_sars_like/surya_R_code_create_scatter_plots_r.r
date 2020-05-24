# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.2.1
library(svglite)  # v1.2.2


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
meta <- read.delim(
  "nextstrain_groups_blab_sars-like-cov_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$host, meta$virus.type)
colnames(dat)[4] <- "host"
colnames(dat)[5] <- "virus_type"
dat$host[50] <- "Human"  # Tor2
dat$virus_type_2 <- gsub("SARS-CoV-2", "SARS-CoV", dat$virus_type)
dat$virus_type_2[dat$virus_type_2 == "SARS-CoV"] <- "SARS-CoV & SARS-CoV-2"
dat_2_1 <- dat[dat$virus_type_2 == "SARS-CoV & SARS-CoV-2", ]
dat_2_2 <- dat[dat$virus_type == "SARS-like CoV", ]
dat_3_1 <- dat[dat$virus_type == "SARS-CoV", ]
dat_3_2 <- dat[dat$virus_type == "SARS-CoV-2", ]

# Plot scatter plots ----
scatter_plot <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1606673 + 0.00002166796*min(dat$node),
      yend = 0.1606673 + 0.00002166796*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (substitutions/site)\n")
scatter_plot_color <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_point(alpha = 0.75) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1606673 + 0.00002166796*min(dat$node),
      yend = 0.1606673 + 0.00002166796*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )
scatter_plot_color_final <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_point() +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1606673 + 0*min(dat$node),
      ## the line looks sharper in the plot when I set the slope to exactly zero
      yend = 0.1606673 + 0*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.position = "none") +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )

scatter_plot_color_final <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_jitter(alpha = 0.25, width = 0.1) +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1606673 + 0*min(dat$node),
      ## the line looks sharper in the plot when I set the slope to exactly zero
      yend = 0.1606673 + 0*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.position = "none") +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )

scatter_plot_type_2 <-
  ggplot(dat, aes(node, path, color = virus_type_2)) +
    geom_jitter(alpha = 0.25, width = 0.1) +
    geom_segment(
      x = min(dat_2_1$node),
      xend = max(dat_2_1$node),
      y = 0.1698504 + 0.00001282865*min(dat_2_1$node),
      yend = 0.1698504 + 0.00001282865*max(dat_2_1$node),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.14320773 + 0.00602055665*min(dat_2_2$node),
      yend = 0.14320773 + 0.00602055665*max(dat_2_2$node),
      color = "#00BFC4",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )
scatter_plot_type_3 <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_jitter(alpha = 0.25, width = 0.1) +
    geom_segment(
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.2148313 + 0.00001545486*min(dat_3_1$node),
      yend = 0.2148313 + 0.00001545486*max(dat_3_1$node),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.1687192 + 0.00001545486*min(dat_3_2$node),
      yend = 0.1687192 + 0.00001545486*max(dat_3_2$node),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.13163472 + 0.01002851*min(dat_2_2$node),
      yend = 0.13163472 + 0.01002851*max(dat_2_2$node),
      color = "#619CFF",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )
## Interactive plot
plot_interactive <-
  ggplot(dat, aes(node, path, color = virus_type, label = genome)) +
    geom_jitter(width = 0.1) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )
plot_interactive <- ggplotly(plot_interactive)

# Save scatter plots ----
CairoPDF("surya_figure_punctuation_sars_like_r.pdf", width = 6,
         height = 5)
print(scatter_plot)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r.svg", width = 6,
         height = 5)
print(scatter_plot)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_r_color.pdf", width = 6,
         height = 5)
print(scatter_plot_color)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r_color.svg", width = 6,
         height = 5)
print(scatter_plot_color)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_r_color.pdf", width = 6,
         height = 5)
print(scatter_plot_color)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r_color.svg", width = 6,
         height = 5)
print(scatter_plot_color)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_r_color_final.pdf", width = 6,
         height = 5)
print(scatter_plot_color_final)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r_color_final.svg", width = 6,
         height = 5)
print(scatter_plot_color_final)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_type_2group_r.pdf", width = 6,
         height = 5)
print(scatter_plot_type_2)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_type_2group_r.svg", width = 6,
         height = 5)
print(scatter_plot_type_2)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_type_3group_r.pdf", width = 6,
         height = 5)
print(scatter_plot_type_3)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_type_3group_r.svg", width = 6,
         height = 5)
print(scatter_plot_type_3)
graphics.off()
## Interactive plot
saveWidget(
  widget = as_widget(plot_interactive),
  file = "surya_figure_punctuation_sars_like_interactive.html"
)
