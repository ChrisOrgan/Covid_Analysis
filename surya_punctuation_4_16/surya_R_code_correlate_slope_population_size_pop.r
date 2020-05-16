# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5-12
library(ggplot2)  # v3.3.0
library(ggrepel)  # v0.8.2
library(ggthemes)  # v4.2.0


# Calculate, load, and write data ----
continent <- c("Africa", "Asia", "Europe", "North America", "Oceania",
               "South America")
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
slope <- NULL
## Africa
x <- min(dat_africa$node)
xend <- max(dat_africa$node)
y <- 13.201109271227 + -0.367840886867*min(dat_africa$node) +
     -0.00000000401*1340598113 +
     0.000000000273*min(dat_africa$node)*1340598113
yend <- 13.201109271227 + -0.367840886867*max(dat_africa$node) +
        -0.00000000401*1340598113 +
        0.000000000273*max(dat_africa$node)*1340598113
slope[1] <- (yend-y) / (xend-x)
## Asia
x <- min(dat_asia$node)
xend <- max(dat_asia$node)
y <- 13.201109271227 + -0.367840886867*min(dat_asia$node) +
     -0.00000000401*4641054786 +
     0.000000000273*min(dat_asia$node)*4641054786
yend <- 13.201109271227 + -0.367840886867*max(dat_asia$node) +
        -0.00000000401*4641054786 +
        0.000000000273*max(dat_asia$node)*4641054786
slope[2] <- (yend-y) / (xend-x)
## Europe
x <- min(dat_europe$node)
xend <- max(dat_europe$node)
y <- 13.201109271227 + -0.367840886867*min(dat_europe$node) +
     -0.00000000401*747636045 +
     0.000000000273*min(dat_europe$node)*747636045
yend <- 13.201109271227 + -0.367840886867*max(dat_europe$node) +
        -0.00000000401*747636045 + 
        0.000000000273*max(dat_europe$node)*747636045
slope[3] <- (yend-y) / (xend-x)
## North America
x <- min(dat_namerica$node)
xend <- max(dat_namerica$node)
y <- 13.201109271227 + -0.367840886867*min(dat_namerica$node) +
     -0.00000000401*368092846 +
     0.000000000273*min(dat_namerica$node)*368092846
yend <- 13.201109271227 + -0.367840886867*max(dat_namerica$node) +
        -0.00000000401*368092846 + 
        0.000000000273*max(dat_namerica$node)*368092846
slope[4] <- (yend-y) / (xend-x)
## Oceania
x <- min(dat_oceania$node)
xend <- max(dat_oceania$node)
y <- 13.201109271227 + -0.367840886867*min(dat_oceania$node) +
     -0.00000000401*42677809 +
     0.000000000273*min(dat_oceania$node)*42677809
yend <- 13.201109271227 + -0.367840886867*max(dat_oceania$node) +
        -0.00000000401*42677809 + 
        0.000000000273*max(dat_oceania$node)*42677809
slope[5] <- (yend-y) / (xend-x)
## South America
x <- min(dat_samerica$node)
xend <- max(dat_samerica$node)
y <- 13.201109271227 + -0.367840886867*min(dat_samerica$node) +
     -0.00000000401*653739130 +
     0.000000000273*min(dat_samerica$node)*653739130
yend <- 13.201109271227 + -0.367840886867*max(dat_samerica$node) +
        -0.00000000401*653739130 + 
        0.000000000273*max(dat_samerica$node)*653739130
slope[6] <- (yend-y) / (xend-x)
pop_size <-c(1340598113, 4641054786, 747636045, 368092846, 42677809, 653739130)
dat <- data.frame(continent, slope, pop_size)

# Test correlation ----
sink("surya_R_output_correlation_slope_population_size_pop.txt")
cat("==========================\n")
cat("Kendall's Rank Correlation\n")
cat("==========================\n\n")
cor.test(
  x = dat$pop_size,
  y = dat$slope,
  alternative = "greater",
  method = "kendall"
)
sink()

# Create scatter plot ----
plot_corr <-
  ggplot(dat, aes(pop_size / 10^-9, slope, label = continent)) +
    geom_segment(
      x = 0,
      xend = max(dat$pop_size) / 10^-9,
      y = 0,
      yend = 0,
      color = "gray80",
      size = 0.25,
      linetype = "dashed"
    ) +
    geom_smooth(color = "gray25", size = 0.5, method = "lm", se = FALSE) +
    geom_point(color = "gray50") +
    geom_text_repel(
      segment.color = "gray90",
      color = "gray",
      size = 1.85,
      family = "Arial"
    ) +
    theme_tufte(base_size = 10, base_family = "Arial", ticks = FALSE) +
    labs(
      x = "\nPopulation Size (billion individuals)",
      y = "Slope (total path lengths ~ node count)\n"
    )

# Save scatter plot ----
CairoPS("surya_figure_correlation_pop.ps", width = 3.2675, height = 3.2675)
print(plot_corr)
graphics.off()
