# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggplot2)
library(ggthemes)


# Read and prepare data ----
punc_v2 <- round(0.1249086, 3)  # SARS-CoV-2
punc_v1 <- round(0.2659079, 3)  # SARS-CoV-1
dbic_v2 <- 837.5
dbic_v1 <- -2.8
setwd("sars_cov_2_subsampling")
punc_v2_1000 <- read.table("sars_cov_2_subsampling_output_r_all_punc_contrib.txt")
dbic_v2_1000 <- read.table("sars_cov_2_subsampling_output_r_all_dbic.txt")
setwd("..")
setwd("sars_cov_2_subsampling_sars_cov_1_continent")
punc_v2_1000_con <- read.table("sars_cov_2_subsampling_sars_cov_1_con_output_r_all_punc_contrib.txt")
dbic_v2_1000_con <- read.table("sars_cov_2_subsampling_sars_cov_1_con_output_r_all_dbic.txt")
setwd("..")
setwd("sars_cov_2_subsampling_42")
punc_v2_42 <- read.table("sars_cov_2_subsampling_42_output_r_all_punc_contrib.txt")
dbic_v2_42 <- read.table("sars_cov_2_subsampling_42_output_r_all_dbic.txt")
setwd("..")
setwd("sars_cov_2_subsampling_sars_cov_1_continent_42")
punc_v2_42_con <- read.table("sars_cov_2_subsampling_sars_cov_1_con_42_output_r_all_punc_contrib.txt")
dbic_v2_42_con <- read.table("sars_cov_2_subsampling_sars_cov_1_con_42_output_r_all_dbic.txt")
setwd("..")
dat <- data.frame(
  punc_v2_1000 = punc_v2_1000$V1,
  dbic_v2_1000 = dbic_v2_1000$V1,
  punc_v2_1000_con = punc_v2_1000_con$V1,
  dbic_v2_1000_con = dbic_v2_1000_con$V1,
  punc_v2_42 = punc_v2_42$V1,
  dbic_v2_42 = dbic_v2_42$V1,
  punc_v2_42_con = punc_v2_42_con$V1,
  dbic_v2_42_con = dbic_v2_42_con$V1
)

# Plot the distributions of delta-BIC and the proportion of the total tree
#   length attributable to the punctuational effect ----
plot_punc_v2_1000 <-
  ggplot(data = dat, aes(x = punc_v2_1000)) +
    coord_cartesian(xlim = c(0, 0.75), ylim = c(0, 75)) +
    geom_density(fill = "#F8766D", color = "#F8766D") +
    geom_segment(
      x = punc_v2,
      xend = punc_v2,
      y = 0,
      yend = 73,
      linetype = "solid",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v2, y = 76, size = 8/.pt, label = "SARS-CoV-2") +
    geom_segment(
      x = punc_v1,
      xend = punc_v1,
      y = 0,
      yend = 73,
      linetype = "dashed",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v1, y = 76, size = 8/.pt, label = "SARS-CoV-1") +
    annotate("text", x = 0.5, y = 35, size = 8/.pt, label = "95% CI = [0.108, 0.141]") +
    annotate("text", x = 0, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 0.75, y = 0, size = 8/.pt, label = "") +
    scale_x_continuous(breaks = c(0, punc_v2, punc_v1, 0.5, 0.75)) +
    scale_y_continuous(breaks = c(0, 25, 50, 75)) +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(1A) Subsampling 1,000 genomes 1,000 times",
      subtitle = "Simple random sampling\n",
      x = "\nProportion of total tree length\nattributable to the punctuational effect",
      y = "Density\n"
    )
plot_dbic_v2_1000 <-
  ggplot(data = dat, aes(x = dbic_v2_1000)) +
    coord_cartesian(xlim = c(-5, 125), ylim = c(0, 0.1)) +
    geom_density(fill = "#F8766D", color = "#F8766D") +
    annotate("text", x = -5, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 125, y = 0, size = 8/.pt, label = "") +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(1B) Subsampling 1,000 genomes 1,000 times",
      subtitle = "Simple random sampling\n",
      x = "\nSupport for the punctuational model\n(BIC of null model - BIC of punctuational model)",
      y = "Density\n"
    )
plot_punc_v2_1000_con <-
  ggplot(data = dat, aes(x = punc_v2_1000_con)) +
    coord_cartesian(xlim = c(0, 0.75), ylim = c(0, 75)) +
    geom_density(fill = "#7CAE00", color = "#7CAE00") +
    geom_segment(
      x = punc_v2,
      xend = punc_v2,
      y = 0,
      yend = 73,
      linetype = "solid",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v2, y = 76, size = 8/.pt, label = "SARS-CoV-2") +
    geom_segment(
      x = punc_v1,
      xend = punc_v1,
      y = 0,
      yend = 73,
      linetype = "dashed",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v1, y = 76, size = 8/.pt, label = "SARS-CoV-1") +
    annotate("text", x = 0.5, y = 35, size = 8/.pt, label = "95% CI = [0.117, 0.140]") +
    annotate("text", x = 0, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 0.75, y = 0, size = 8/.pt, label = "") +
    scale_x_continuous(breaks = c(0, punc_v2, punc_v1, 0.5, 0.75)) +
    scale_y_continuous(breaks = c(0, 25, 50, 75)) +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(2A) Subsampling 1,000 genomes 1,000 times",
      subtitle = "Using SARS-CoV-1 by-continent sampling proportion\n",
      x = "\nProportion of total tree length\nattributable to the punctuational effect",
      y = "Density\n"
    )
plot_dbic_v2_1000_con <-
  ggplot(data = dat, aes(x = dbic_v2_1000_con)) +
    coord_cartesian(xlim = c(-5, 125), ylim = c(0, 0.1)) +
    geom_density(fill = "#7CAE00", color = "#7CAE00") +
    annotate("text", x = -5, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 125, y = 0, size = 8/.pt, label = "") +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(2B) Subsampling 1,000 genomes 1,000 times",
      subtitle = "Using SARS-CoV-1 by-continent sampling proportion\n",
      x = "\nSupport for the punctuational model\n(BIC of null model - BIC of punctuational model)",
      y = "Density\n"
    )
plot_punc_v2_42 <-
  ggplot(data = dat, aes(x = punc_v2_42)) +
    coord_cartesian(xlim = c(0, 0.75), ylim = c(0, 75)) +
    geom_density(fill = "#00BFC4", color = "#00BFC4") +
    geom_segment(
      x = punc_v2,
      xend = punc_v2,
      y = 0,
      yend = 73,
      linetype = "solid",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v2, y = 76, size = 8/.pt, label = "SARS-CoV-2") +
    geom_segment(
      x = punc_v1,
      xend = punc_v1,
      y = 0,
      yend = 73,
      linetype = "dashed",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v1, y = 76, size = 8/.pt, label = "SARS-CoV-1") +
    annotate("text", x = 0.5, y = 35, size = 8/.pt, label = "95% CI = [0.110, 0.518]") +
    annotate("text", x = 0, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 0.75, y = 0, size = 8/.pt, label = "") +
    scale_x_continuous(breaks = c(0, punc_v2, punc_v1, 0.5, 0.75)) +
    scale_y_continuous(breaks = c(0, 25, 50, 75)) +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(3A) Subsampling 42 genomes 1,000 times",
      subtitle = "Simple random sampling\n",
      x = "\nProportion of total tree length\nattributable to the punctuational effect",
      y = "Density\n"
    )
plot_dbic_v2_42 <-
  ggplot(data = dat, aes(x = dbic_v2_42)) +
    coord_cartesian(xlim = c(-5, 125), ylim = c(0, 0.1)) +
    geom_density(fill = "#00BFC4", color = "#00BFC4") +
    annotate("text", x = -5, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 125, y = 0, size = 8/.pt, label = "") +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(3B) Subsampling 42 genomes 1,000 times",
      subtitle = "Simple random sampling\n",
      x = "\nSupport for the punctuational model\n(BIC of null model - BIC of punctuational model)",
      y = "Density\n"
    )
plot_punc_v2_42_con <-
  ggplot(data = dat, aes(x = punc_v2_42_con)) +
    coord_cartesian(xlim = c(0, 0.75), ylim = c(0, 75)) +
    geom_density(fill = "#C77CFF", color = "#C77CFF") +
    geom_segment(
      x = punc_v2,
      xend = punc_v2,
      y = 0,
      yend = 73,
      linetype = "solid",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v2, y = 76, size = 8/.pt, label = "SARS-CoV-2") +
    geom_segment(
      x = punc_v1,
      xend = punc_v1,
      y = 0,
      yend = 73,
      linetype = "dashed",
      color = "black",
      linewidth = 0.5
    ) +
    annotate("text", x = punc_v1, y = 76, size = 8/.pt, label = "SARS-CoV-1") +
    annotate("text", x = 0.5, y = 35, size = 8/.pt, label = "95% CI = [0.140, 0.542]") +
    annotate("text", x = 0, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 0.75, y = 0, size = 8/.pt, label = "") +
    scale_x_continuous(breaks = c(0, punc_v2, punc_v1, 0.5, 0.75)) +
    scale_y_continuous(breaks = c(0, 25, 50, 75)) +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(4A) Subsampling 42 genomes 1,000 times",
      subtitle = "Using SARS-CoV-1 by-continent sampling proportion\n",
      x = "\nProportion of total tree length\nattributable to the punctuational effect",
      y = "Density\n"
    )
plot_dbic_v2_42_con <-
  ggplot(data = dat, aes(x = dbic_v2_42_con)) +
    coord_cartesian(xlim = c(-5, 125), ylim = c(0, 0.1)) +
    geom_density(fill = "#C77CFF", color = "#C77CFF") +
    annotate("text", x = -5, y = 0, size = 8/.pt, label = "") +
    annotate("text", x = 125, y = 0, size = 8/.pt, label = "") +
    theme_tufte(base_size = 8, base_family = "Arial", ticks = FALSE) +
    labs(
      title = "(4B) Subsampling 42 genomes 1,000 times",
      subtitle = "Using SARS-CoV-1 by-continent sampling proportion\n",
      x = "\nSupport for the punctuational model\n(BIC of null model - BIC of punctuational model)",
      y = "Density\n"
    )

# Save scatter plots ----
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_punc_1000.svg",
  width = 4.75,
  height = 2.94
)
print(plot_punc_v2_1000)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_dbic_1000.svg",
  width = 4.75,
  height = 2.94
)
print(plot_dbic_v2_1000)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_punc_1000_con.svg",
  width = 4.75,
  height = 2.94
)
print(plot_punc_v2_1000_con)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_dbic_1000_con.svg",
  width = 4.75,
  height = 2.94
)
print(plot_dbic_v2_1000_con)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_punc_42.svg",
  width = 4.75,
  height = 2.94
)
print(plot_punc_v2_42)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_dbic_42.svg",
  width = 4.75,
  height = 2.94
)
print(plot_dbic_v2_42)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_punc_42_con.svg",
  width = 4.75,
  height = 2.94
)
print(plot_punc_v2_42_con)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_subsampling_sars_cov_1_dbic_42_con.svg",
  width = 4.75,
  height = 2.94
)
print(plot_dbic_v2_42_con)
graphics.off()
