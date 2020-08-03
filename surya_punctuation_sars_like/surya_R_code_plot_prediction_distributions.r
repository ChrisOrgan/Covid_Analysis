# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.2


# Load and prepare data ----
genome <- c("pangolin/Guangxi/P1E/2017", "pangolin/Guangxi/P4L/2017",
            "pangolin/Guangxi/P5E/2017", "pangolin/Guangxi/P5L/2017")
path <- c(0.22717139, 0.22714557, 0.22717925, 0.22686664)
dat <- data.frame(genome, path)
# dat
setwd("BayesTraits_output")
dat_dist <- read.table(
  "surya_BayesTraits_output_prediction_trace.txt",
  header = TRUE,
  sep = "\t",
)
setwd("..")
dat_dist <- dat_dist[, c(14:17)]
genome_names <- dat$genome
genome_names <- gsub("/", "_", genome_names)
colnames(dat_dist) <- genome_names
# head(dat_dist)

# Plot distributions ----
plot1 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P1E_2017)) +
    xlim(min(dat_dist), max(dat_dist)) +
    ylim(0, 30) +
    geom_segment(x = 0.22717139, xend = 0.22717139, y = 0, yend = 26) +
    annotate("text", x = 0.22717139, y = 29, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P1E/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot2 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P4L_2017)) +
    xlim(min(dat_dist), max(dat_dist)) +
    ylim(0, 30) +
    geom_segment(x = 0.22714557, xend = 0.22714557, y = 0, yend = 26) +
    annotate("text", x = 0.22714557, y = 29, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P4L/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot3 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P5E_2017)) +
    xlim(min(dat_dist), max(dat_dist)) +
    ylim(0, 30) +
    geom_segment(x = 0.22717925, xend = 0.22717925, y = 0, yend = 26) +
    annotate("text", x = 0.22717925, y = 29, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P5E/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot4 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P5L_2017)) +
    xlim(min(dat_dist), max(dat_dist)) +
    ylim(0, 30) +
    geom_segment(x = 0.22686664, xend = 0.22686664, y = 0, yend = 26) +
    annotate("text", x = 0.22686664, y = 29, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P5L/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )

# Save scatter plots ----
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P1E.pdf", width = 6.535,
         height = 4.089)
print(plot1)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P1E.svg", width = 6.535,
         height = 4.089)
print(plot1)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P4L.pdf", width = 6.535,
         height = 4.089)
print(plot2)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P4L.svg", width = 6.535,
         height = 4.089)
print(plot2)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P5E.pdf", width = 6.535,
         height = 4.089)
print(plot3)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P5E.svg", width = 6.535,
         height = 4.089)
print(plot3)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P5L.pdf", width = 6.535,
         height = 4.089)
print(plot4)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P5L.svg", width = 6.535,
         height = 4.089)
print(plot4)
graphics.off()
