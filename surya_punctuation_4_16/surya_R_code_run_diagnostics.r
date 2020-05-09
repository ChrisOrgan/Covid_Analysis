# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ggExtra)  # v0.9
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(svglite)  # v1.2.3


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat$fitted_values <- 8.37994550358 + -0.06281616049*dat$node
dat$residuals <- dat$path - dat$fitted_values
meta <- read.delim(
  "nextstrain_ncov_global_metadata.tsv",
  header = TRUE,
  sep = "\t"
)
dat <- dat[match(meta$Strain, dat$genome), ]
dat <- cbind(dat, meta$Region)
colnames(dat)[6] <- "continent"
dat_region <- dat
dat_region[dat_region$continent == "Africa", ]$fitted_values <-
  7.399117120309 + 0.244231555262 *
  dat_region[dat_region$continent == "Africa", ]$node
dat_region[dat_region$continent == "Asia", ]$fitted_values <-
  -2.392610646453 + 0.811741351289 *
  dat_region[dat_region$continent == "Asia", ]$node
dat_region[dat_region$continent == "Europe", ]$fitted_values <-
  13.239131460533 + -0.359224246134 *
  dat_region[dat_region$continent == "Europe", ]$node
dat_region[dat_region$continent == "North America", ]$fitted_values <-
  2.874872765671 + 0.274321504554 *
  dat_region[dat_region$continent == "North America", ]$node
dat_region[dat_region$continent == "Oceania", ]$fitted_values <-
  22.058314121794 + -0.992735546963 *
  dat_region[dat_region$continent == "Oceania", ]$node
dat_region[dat_region$continent == "South America", ]$fitted_values <-
  38.583500810899 + -4.448433729704 *
  dat_region[dat_region$continent == "South America", ]$node
dat_region$residuals <- dat_region$path - dat_region$fitted_values
dat_pop <- dat
dat_pop[dat_pop$continent == "Africa", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "Africa", ]$node +
  -0.00000000401*1340598113 +
  0.000000000273*dat_pop[dat_pop$continent == "Africa", ]$node*1340598113
dat_pop[dat_pop$continent == "Asia", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "Asia", ]$node +
  -0.00000000401*4641054786 +
  0.000000000273*dat_pop[dat_pop$continent == "Asia", ]$node*4641054786
dat_pop[dat_pop$continent == "Europe", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "Europe", ]$node +
  -0.00000000401*747636045 +
  0.000000000273*dat_pop[dat_pop$continent == "Europe", ]$node*747636045
dat_pop[dat_pop$continent == "North America", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "North America", ]$node +
  -0.00000000401*368092846 +
  0.000000000273*dat_pop[dat_pop$continent == "North America", ]$node*368092846
dat_pop[dat_pop$continent == "Oceania", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "Oceania", ]$node +
  -0.00000000401*42677809 +
  0.000000000273*dat_pop[dat_pop$continent == "Oceania", ]$node*42677809
dat_pop[dat_pop$continent == "South America", ]$fitted_values <-
  13.201109271227 +
  -0.367840886867*dat_pop[dat_pop$continent == "South America", ]$node +
  -0.00000000401*653739130 +
  0.000000000273*dat_pop[dat_pop$continent == "South America", ]$node*653739130
dat_pop$residuals <- dat_pop$path - dat_pop$fitted_values
dat_rate <- read.table(
  "surya_BayesTraits_data_rate_path_lengths_nodes.txt",
  sep = "\t"
)
colnames(dat_rate) <- c("genome", "path", "node")
dat_rate$fitted_values <- 367.834030128746 + 4.550054972442*dat_rate$node
dat_rate$residuals <- dat_rate$path - dat_rate$fitted_values

# Plot marginal histogram scatter plots of residuals ----
plot_diag <-
  ggplot(dat, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_region <-
  ggplot(dat_region, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_region_color <-
  ggplot(dat_region, aes(fitted_values, residuals, color = continent)) +
    geom_point(size = 0.5) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.title = element_blank(),
      legend.position = "bottom"
    ) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_pop <-
  ggplot(dat_pop, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_pop_color <-
  ggplot(dat_pop, aes(fitted_values, residuals, color = continent)) +
    geom_point(size = 0.5) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.title = element_blank(),
      legend.position = "bottom"
    ) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag_rate <-
  ggplot(dat_rate, aes(fitted_values, residuals)) +
    geom_point(color = "gray", size = 0.5) +
    geom_smooth(
      color = "red",
      size = 1,
      method = "loess",
      se = FALSE
    ) +
    scale_y_reverse() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nFitted Values", y = "Residuals\n")
plot_diag <- ggMarginal(plot_diag, type = "density", margins = "y", size = 1.75)
plot_diag_region <- ggMarginal(
  plot_diag_region,
  type = "density",
  margins = "y",
  size = 1.75
)
plot_diag_region_color <- ggMarginal(
  plot_diag_region_color,
  type = "density",
  margins = "y",
  size = 4
)
plot_diag_pop <- ggMarginal(
  plot_diag_pop,
  type = "density",
  margins = "y",
  size = 1.75
)
plot_diag_pop_color <- ggMarginal(
  plot_diag_pop_color,
  type = "density",
  margins = "y",
  size = 4
)
plot_diag_rate <- ggMarginal(
  plot_diag_rate,
  type = "density",
  margins = "y",
  size = 1.75
)

# Save diagnostic plots ----
ggsave("surya_figure_punctuation_diagnostics.pdf", width = 3.2675,
       height = 3.2675, device = cairo_pdf, plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_diagnostics.svg", width = 3.2675,
       height = 3.2675, plot_diag)
graphics.off()
ggsave("surya_figure_punctuation_region_diagnostics.pdf", width = 3.2675,
       height = 3.2675, device = cairo_pdf, plot_diag_region)
graphics.off()
ggsave("surya_figure_punctuation_region_diagnostics.svg", width = 3.2675,
       height = 3.2675, plot_diag_region)
graphics.off()
ggsave("surya_figure_punctuation_region_diagnostics_color.pdf", width = 6.535,
       height = 4.089, device = cairo_pdf, plot_diag_region_color)
graphics.off()
ggsave("surya_figure_punctuation_region_diagnostics_color.svg", width = 6.535,
       height = 4.089, plot_diag_region_color)
graphics.off()
ggsave("surya_figure_punctuation_pop_diagnostics.pdf", width = 3.2675,
       height = 3.2675, device = cairo_pdf, plot_diag_pop)
graphics.off()
ggsave("surya_figure_punctuation_pop_diagnostics.svg", width = 3.2675,
       height = 3.2675, plot_diag_pop)
graphics.off()
ggsave("surya_figure_punctuation_pop_diagnostics_color.pdf", width = 6.535,
       height = 4.089, device = cairo_pdf, plot_diag_pop_color)
graphics.off()
ggsave("surya_figure_punctuation_pop_diagnostics_color.svg", width = 6.535,
       height = 4.089, plot_diag_pop_color)
graphics.off()
ggsave("surya_figure_punctuation_rate_diagnostics.pdf", width = 3.2675,
       height = 3.2675, device = cairo_pdf, plot_diag_rate)
graphics.off()
ggsave("surya_figure_punctuation_rate_diagnostics.svg", width = 3.2675,
       height = 3.2675, plot_diag_rate)
graphics.off()

# Check normality using the Shapiro-Wilk test ----
sink("surya_R_output_normality.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat$residuals)
sink()
sink("surya_R_output_normality_region.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat_region$residuals)
sink()
sink("surya_R_output_normality_pop.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat_pop$residuals)
sink()
sink("surya_R_output_normality_rate.txt")
cat("==============\n")
cat("Normality Test\n")
cat("==============\n\n")
shapiro.test(dat_rate$residuals)
sink()
