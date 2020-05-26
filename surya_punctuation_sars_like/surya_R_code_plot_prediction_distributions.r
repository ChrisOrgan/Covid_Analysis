# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.2


# Load and prepare data ----
genome <- c("pangolin/Guangxi/P1E/2017", "pangolin/Guangxi/P5L/2017",
            "pangolin/Guangxi/P4L/2017", "pangolin/Guangxi/P5E/2017",
            "pangolin/Guangdong/1/2020", "pangolin/Guangdong/P2S/2019",
            "bat/Yunnan/RaTG13/2013")
path <- c(0.2272, 0.2269, 0.2271, 0.2272, 0.1917, 0.1916, 0.1855)
dat <- data.frame(genome, path)
# dat
dat_dist <- read.table(
  "surya_BayesTraits_output_prediction_3group_estimates_trace.txt",
  header = TRUE,
  sep = "\t",
)
dat_dist <- dat_dist[, -c(1:19, 27)]
genome_names <- dat$genome
genome_names <- gsub("/", "_", genome_names)
colnames(dat_dist) <- genome_names
# head(dat_dist)

# Plot distributions ----
plot1 <-
  ggplot(dat_dist, aes(bat_Yunnan_RaTG13_2013)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.1855, xend = 0.1855, y = 0, yend = 53) +
    annotate("text", x = 0.1855, y = 60, label = "0.186\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("bat/Yunnan/RaTG13/2013")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot2 <-
  ggplot(dat_dist, aes(pangolin_Guangdong_1_2020)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.1917, xend = 0.1917, y = 0, yend = 53) +
    annotate("text", x = 0.1917, y = 60, label = "0.192\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangdong/1/2020")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot3 <-
  ggplot(dat_dist, aes(pangolin_Guangdong_P2S_2019)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.1916, xend = 0.1916, y = 0, yend = 53) +
    annotate("text", x = 0.1916, y = 60, label = "0.192\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangdong/P2S/2019")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot4 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P1E_2017)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.2272, xend = 0.2272, y = 0, yend = 70) +
    annotate("text", x = 0.2272, y = 77, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P1E/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot5 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P4L_2017)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.2271, xend = 0.2271, y = 0, yend = 60) +
    annotate("text", x = 0.2271, y = 67, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P4L/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot6 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P5E_2017)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.2272, xend = 0.2272, y = 0, yend = 55) +
    annotate("text", x = 0.2272, y = 62, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P5E/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )
plot7 <-
  ggplot(dat_dist, aes(pangolin_Guangxi_P5L_2017)) +
    xlim(min(dat_dist), 0.235) +
    ylim(0, 80) +
    geom_segment(x = 0.2269, xend = 0.2269, y = 0, yend = 60) +
    annotate("text", x = 0.2269, y = 67, label = "0.227\n(actual)") +
    geom_density(color = "grey40") +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = bquote(bold("pangolin/Guangxi/P5L/2017")),
      x = "\nPosterior predictions: Total path length (mutations)",
      y = NULL
    )

# Save scatter plots ----
CairoPDF("surya_figure_distribution_bat_Yunnan_RaTG13.pdf", width = 6.535,
         height = 4.089)
print(plot1)
graphics.off()
CairoSVG("surya_figure_distribution_bat_Yunnan_RaTG13.svg", width = 6.535,
         height = 4.089)
print(plot1)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangdong_1.pdf", width = 6.535,
         height = 4.089)
print(plot2)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangdong_1.svg", width = 6.535,
         height = 4.089)
print(plot2)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangdong_P2S.pdf", width = 6.535,
         height = 4.089)
print(plot3)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangdong_P2S.svg", width = 6.535,
         height = 4.089)
print(plot3)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P1E.pdf", width = 6.535,
         height = 4.089)
print(plot4)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P1E.svg", width = 6.535,
         height = 4.089)
print(plot4)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P4L.pdf", width = 6.535,
         height = 4.089)
print(plot5)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P4L.svg", width = 6.535,
         height = 4.089)
print(plot5)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P5E.pdf", width = 6.535,
         height = 4.089)
print(plot6)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P5E.svg", width = 6.535,
         height = 4.089)
print(plot6)
graphics.off()
CairoPDF("surya_figure_distribution_pangolin_Guangxi_P5L.pdf", width = 6.535,
         height = 4.089)
print(plot7)
graphics.off()
CairoSVG("surya_figure_distribution_pangolin_Guangxi_P5L.svg", width = 6.535,
         height = 4.089)
print(plot7)
graphics.off()
