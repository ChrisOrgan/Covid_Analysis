# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(Cairo)
library(ggplot2)
library(ggthemes)
library(lubridate)
library(svglite)


# Read data ----
dat <- read.table("sars_cov_2_data.txt", sep = "\t", header = TRUE)
dat_con_africa <- dat[dat$continent == "Africa", ]
dat_con_asia <- dat[dat$continent == "Asia", ]
dat_con_europe <- dat[dat$continent == "Europe", ]
dat_con_namerica <- dat[dat$continent == "North America", ]
dat_con_oceania <- dat[dat$continent == "Oceania", ]
dat_con_samerica <- dat[dat$continent == "South America", ]
date_bounds <- seq(from = min(dat$time), to = max(dat$time), length.out = 7)
date_bounds_ymd <- date_decimal(decimal = date_bounds)
dates <- data.frame(date_bounds, date_bounds_ymd)
## dates
###   date_bounds     date_bounds_ymd
### 1    2019.978 2019-12-23 23:59:59
### 2    2020.042 2020-01-16 11:33:41
### 3    2020.107 2020-02-08 23:38:57
### 4    2020.171 2020-03-03 11:44:13
### 5    2020.235 2020-03-26 23:49:28
### 6    2020.299 2020-04-19 11:54:44
### 7    2020.363 2020-05-12 23:59:59
dat_time_1 <- dat[dat$time <= date_bounds[2], ]
dat_time_2 <- dat[dat$time > date_bounds[2] & dat$time <= date_bounds[3], ]
dat_time_3 <- dat[dat$time > date_bounds[3] & dat$time <= date_bounds[4], ]
dat_time_4 <- dat[dat$time > date_bounds[4] & dat$time <= date_bounds[5], ]
dat_time_5 <- dat[dat$time > date_bounds[5] & dat$time <= date_bounds[6], ]
dat_time_6 <- dat[dat$time > date_bounds[6] & dat$time <= date_bounds[7], ]

# Plot regressions ----
## Global
plot_reg <-
  ggplot(dat, aes(x = time, y = path, color = node)) +
    geom_point(size = 0.75) +
    ### Phylogenetic fit lines
    #### geom_segment(
    ####   x = min(dat$time),
    ####   xend = max(dat$time),
    ####   y = -0.09365752 + 0.00004637*min(dat$time) +
    ####       0.00000226*quantile(dat$node, 0.25),  # at the 25th percentile
    ####   yend = -0.09365752 + 0.00004637*max(dat$time) +
    ####          0.00000226*quantile(dat$node, 0.25),  # at the 25th percentile
    ####   color = "gray75",
    ####   size = 0.5,
    ####   linetype = "dashed"
    #### ) +
    #### geom_segment(
    ####   x = min(dat$time),
    ####   xend = max(dat$time),
    ####   y = -0.09365752 + 0.00004637*min(dat$time) +
    ####       0.00000226*median(dat$node),  # at the median
    ####   yend = -0.09365752 + 0.00004637*max(dat$time) +
    ####          0.00000226*median(dat$node),  # at the median
    ####   color = "gray50",
    ####   size = 0.5,
    ####   linetype = "dashed"
    #### ) +
    #### geom_segment(
    ####   x = min(dat$time),
    ####   xend = max(dat$time),
    ####   y = -0.09365752 + 0.00004637*min(dat$time) +
    ####       0.00000226*quantile(dat$node, 0.75),  # at the 75th percentile
    ####   yend = -0.09365752 + 0.00004637*max(dat$time) +
    ####          0.00000226*quantile(dat$node, 0.75),  # at the 75th percentile
    ####   color = "gray25",
    ####   size = 0.5,
    ####   linetype = "dashed"
    #### ) +
    geom_smooth(method = "lm", se = FALSE, color = "black", size = 0.5) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time (decimal year)",
      y = "Root-to-tip divergence (subs/site)\n",
      color = "Node\ncount"
    )
## Continents
plot_reg_africa <-
  ggplot(dat_con_africa, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "Africa"
    )
plot_reg_asia <-
  ggplot(dat_con_asia, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "Asia"
    )
plot_reg_europe <-
  ggplot(dat_con_europe, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "Europe"
    )
plot_reg_namerica <-
  ggplot(dat_con_namerica, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "North America"
    )
plot_reg_oceania <-
  ggplot(dat_con_oceania, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "Oceania"
    )
plot_reg_samerica <-
  ggplot(dat_con_samerica, aes(x = time, y = path, color = node)) +
    coord_cartesian(
      xlim = c(min(dat$time), max(dat$time)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75) +
    scale_colour_gradient(low = "gray90", high = "gray10") +
    guides(colour = guide_colourbar(barwidth = 0.25, ticks = FALSE)) +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nSampling time",
      y = "Root-to-tip divergence\n",
      color = "Node\ncount",
      title = "South America"
    )
## Time
plot_reg_time_1 <-
  ggplot(dat_time_1, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "December 2019 - January 2020"
    )
plot_reg_time_2 <-
  ggplot(dat_time_2, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "January 2020 - February 2020"
    )
plot_reg_time_3 <-
  ggplot(dat_time_3, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "February 2020 - March 2020"
    )
plot_reg_time_4 <-
  ggplot(dat_time_4, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "March 2020 - March 2020"
    )
plot_reg_time_5 <-
  ggplot(dat_time_5, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "March 2020 - April 2020"
    )
plot_reg_time_6 <-
  ggplot(dat_time_6, aes(x = node, y = path)) +
    coord_cartesian(
      xlim = c(min(dat$node), max(dat$node)),
      ylim = c(min(dat$path), max(dat$path))
    ) +
    geom_point(size = 0.75, color = "dark gray") +
    theme_tufte(base_size = 14, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nNode count",
      y = "Root-to-tip divergence\n",
      subtitle = "April 2020 - May 2020"
    )

# Save scatter plots ----
## Global
CairoPDF(
  file = "sars_cov_2_figure_regression_path_time_node.pdf",
  width = 4.75,
  height = 2.94
)
print(plot_reg)
graphics.off()
## Continents
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_africa.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_africa)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_asia.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_asia)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_europe.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_europe)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_namerica.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_namerica)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_oceania.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_oceania)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_continent_samerica.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_samerica)
graphics.off()
## Time
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_1.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_1)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_2.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_2)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_3.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_3)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_4.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_4)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_5.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_5)
graphics.off()
CairoSVG(
  file = "sars_cov_2_figure_regression_path_time_node_thru_time_6.svg",
  width = 4.75,
  height = 2.94
)
print(plot_reg_time_6)
graphics.off()
