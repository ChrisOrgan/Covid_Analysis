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
plot1 <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      aes(color = "BayesTraits\nPagel's lambda = 0.000001\n"),
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.149356850726 + 0.001652281586*min(dat$node),
      yend = 0.149356850726 + 0.001652281586*max(dat$node),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R (ape + nlme)\nPagel's lambda = 0.000001\n"),
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.15942588 + 0.00075407*min(dat$node),
      yend = 0.15942588 + 0.00075407*max(dat$node),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R (ape + nlme)\nPagel's lambda = 0\n"),
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1594259185 + 0.0007540561*min(dat$node),
      yend = 0.1594259185 + 0.0007540561*max(dat$node),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R (non-phylo; base lm)"),
      x = min(dat$node),
      xend = max(dat$node),
      y = 0.1594259 + 0.0007541*min(dat$node),
      yend = 0.1594259 + 0.0007541*max(dat$node),
      size = 0.5
    ) +
    scale_colour_manual(values = c("blue", "purple", "pink", "red")) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(x = "\nNode count", y = "Total path length (substitutions/site)\n")
plot3 <-
  ggplot(dat, aes(node, path, color = virus_type)) +
    geom_point() +
    geom_segment(
      aes(linetype = "BayesTraits\nPagel's lambda = 0.000001\n"),
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.163436789178 + -0.000047608669*min(dat_3_1$node),
      yend = 0.163436789178 + -0.000047608669*max(dat_3_1$node),
      color = "#F8766D",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "BayesTraits\nPagel's lambda = 0.000001\n"),
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.183153106976 + -0.000047608669*min(dat_3_2$node),
      yend = 0.183153106976 + -0.000047608669*max(dat_3_2$node),
      color = "#00BA38",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "BayesTraits\nPagel's lambda = 0.000001\n"),
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.161958602289 + -0.001722129017*min(dat_2_2$node),
      yend = 0.161958602289 + -0.001722129017*max(dat_2_2$node),
      color = "#619CFF",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0.000001\n"),
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.1633889 + -0.00004252583*min(dat_3_1$node),
      yend = 0.1633889 + -0.00004252583*max(dat_3_1$node),
      color = "#F8766D",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0.000001\n"),
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.18310568 + -0.00004252583*min(dat_3_2$node),
      yend = 0.18310568 + -0.00004252583*max(dat_3_2$node),
      color = "#00BA38",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0.000001\n"),
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.17452632 + -0.00312699783*min(dat_2_2$node),
      yend = 0.17452632 + -0.00312699783*max(dat_2_2$node),
      color = "#619CFF",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0\n"),
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.1633888 + -0.00004252586*min(dat_3_1$node),
      yend = 0.1633888 + -0.00004252586*max(dat_3_1$node),
      color = "#F8766D",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0\n"),
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.18310592 + -0.00004252586*min(dat_3_2$node),
      yend = 0.18310592 + -0.00004252586*max(dat_3_2$node),
      color = "#00BA38",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (ape + nlme)\nPagel's lambda = 0\n"),
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.17452655 + -0.00312703886*min(dat_2_2$node),
      yend = 0.17452655 + -0.00312703886*max(dat_2_2$node),
      color = "#619CFF",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (non-phylo; base lm)"),
      x = min(dat_3_1$node),
      xend = max(dat_3_1$node),
      y = 0.16338878 + -0.00004253*min(dat_3_1$node),
      yend = 0.16338878 + -0.00004253*max(dat_3_1$node),
      color = "#F8766D",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (non-phylo; base lm)"),
      x = min(dat_3_2$node),
      xend = max(dat_3_2$node),
      y = 0.1831059 + -0.00004253*min(dat_3_2$node),
      yend = 0.1831059 + -0.00004253*max(dat_3_2$node),
      color = "#00BA38",
      size = 0.5
    ) +
    geom_segment(
      aes(linetype = "R (non-phylo; base lm)"),
      x = min(dat_2_2$node),
      xend = max(dat_2_2$node),
      y = 0.17452653 + -0.00312704*min(dat_2_2$node),
      yend = 0.17452653 + -0.00312704*max(dat_2_2$node),
      color = "#619CFF",
      size = 0.5
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(
      x = "\nNode count",
      y = "Total path length (substitutions/site)\n",
      color = NULL
    )

# Save scatter plots ----
CairoPDF("surya_figure_punctuation_sars_like_r_lambda0.pdf", width = 6.535,
         height = 5)
print(plot1)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r_lambda0.svg", width = 6.535,
         height = 5)
print(plot1)
graphics.off()
CairoPDF("surya_figure_punctuation_sars_like_r_lambda0_3group.pdf",
         width = 6.535, height = 5)
print(plot3)
graphics.off()
CairoSVG("surya_figure_punctuation_sars_like_r_lambda0_3group.svg",
         width = 6.535, height = 5)
print(plot3)
graphics.off()
