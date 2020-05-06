# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
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
      y = 0.146969004873 + 0.000004397314*min(dat$node),
      yend = 0.146969004873 + 0.000004397314*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths (substitution / site)\n",
      x = "\nNumber of Nodes",
      y = NULL
    )
scatter_plot_host <-
  ggplot(dat, aes(node, path, color = host)) +
    geom_point() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      subtitle = "Total Path Lengths (substitution / site)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
scatter_plot_type <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_point() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      subtitle = "Total Path Lengths (substitution / site)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
scatter_plot_type_2 <-
  ggplot(dat, aes(node, path, color = virus_type_2)) +
    geom_jitter(alpha = 0.25, width = 0.1) +
    geom_segment(
      x = min(dat_2_1$node),
      xend = max(dat_2_1$node),
      y = 0.154389623748 + 0.000003757299*min(dat_2_1$node),
      yend = 0.154389623748 + 0.000003757299*max(dat_2_1$node),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.146626089174 + -0.000001008934*min(dat_2_2$node),
      yend = 0.146626089174 + -0.000001008934*max(dat_2_2$node),
      color = "#00BFC4",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      subtitle = "Total Path Lengths (substitution / site)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
scatter_plot_type_3 <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_jitter(alpha = 0.25, width = 0.1) +
    geom_segment(
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.168571547064 + 0.000003246251*min(dat_3_1$node),
      yend = 0.168571547064 + 0.000003246251*max(dat_3_1$node),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.145898256089 + 0.000003246251*min(dat_3_2$node),
      yend = 0.145898256089 + 0.000003246251*max(dat_3_2$node),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.143382790828 + 0.001125181986*min(dat_2_2$node),
      yend = 0.143382790828 + 0.001125181986*max(dat_2_2$node),
      color = "#619CFF",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "horizontal",
      legend.position = "bottom"
    ) +
    labs(
      subtitle = "Total Path Lengths (substitution / site)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )

# Save scatter plots ----
CairoPDF("surya_figure_punctuation_sars_like.pdf", width = 5,
         height = 4)
print(scatter_plot)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like.svg", width = 5,
         height = 4)
print(scatter_plot)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_host.pdf", width = 5,
         height = 4)
print(scatter_plot_host)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_host.svg", width = 5,
         height = 4)
print(scatter_plot_host)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_type.pdf", width = 5,
         height = 4)
print(scatter_plot_type)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_type_2group.pdf", width = 5,
         height = 4)
print(scatter_plot_type_2)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_type_2group.svg", width = 5,
         height = 4)
print(scatter_plot_type_2)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_type_3group.pdf", width = 5,
         height = 4)
print(scatter_plot_type_3)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_type_3group.svg", width = 5,
         height = 4)
print(scatter_plot_type_3)
graphics.off()
