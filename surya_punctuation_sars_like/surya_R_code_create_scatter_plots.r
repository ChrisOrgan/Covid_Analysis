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
out <- c("TW3", "TW1", "CUHK_AG03", "TW8", "TW7", "GDH_BJH01", "GZ0401",
         "GZ0402", "PC4_136", "Sweden/01/2020", "Nepal/61/2020",
         "Wuhan/WIV05/2019", "Wuhan/IVDC-HB-04/2020", "Wuhan/WIV04/2019",
         "Wuhan/IVDC-HB-01/2019", "Japan/KY-V-029/2020",
         "Wuhan/IPBCAMS-WH-01/2019", "USA/IL1/2020", "USA/AZ1/2020",
         "USA/TX1/2020")
meta_edit <- meta[!meta$Strain %in% out, ]
dat <- dat[match(meta_edit$Strain, dat$genome), ]
dat <- cbind(dat, meta_edit$virus.type)
colnames(dat)[4] <- "virus_type"
dat$virus_type <- as.character(dat$virus_type)
dat$virus_type[dat$genome == "civet007" | dat$genome == "civet010"] <-
  "SARS-like CoV"
dat$virus_type[dat$genome == "Tor2"] <- "SARS-CoV-1"
dat$virus_type <- as.factor(dat$virus_type)
dat_outliers <- read.table("surya_outliers.txt")
colnames(dat_outliers) <- c("outlier")
dat_edit <- dat[!dat$genome %in% as.character(dat_outliers$outlier), ]

# Plot scatter plots ----
plot_type <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_point() +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(x = "\nNode count", y = "Total path length (substitutions/site)\n")
plot_reg <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.143 + 0.0012114*min(dat$node),
      yend = 0.143 + 0.0012114*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (substitutions/site)\n")
plot_reg_out <-
  ggplot(dat_edit, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1407 + 0.00099491*min(dat$node),
      yend = 0.1407 + 0.00099491*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(x = "\nNode count", y = "Total path length (substitutions/site)\n")

# Save scatter plots ----
CairoPDF("surya_figure_type_sars_like.pdf", width = 6, height = 5)
print(plot_type)
graphics.off()
CairoSVG("surya_figure_type_sars_like.svg", width = 6, height = 5)
print(plot_type)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like.pdf", width = 6, height = 5)
print(plot_reg)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like.svg", width = 6, height = 5)
print(plot_reg)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_no_outliers.pdf", width = 6,
         height = 5)
print(plot_reg_out)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_no_outliers.svg", width = 6,
         height = 5)
print(plot_reg_out)
graphics.off()
