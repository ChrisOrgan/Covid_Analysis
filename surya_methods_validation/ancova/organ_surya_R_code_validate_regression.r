# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5-12
library(ggimage)  # v0.2.8
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(ggtree)  # v1.14.6
library(nlme)  # v3.1-147
library(phytools)  # v0.7-20


# Load and edit data ----
dat <- read.table("organ_data_validation_regression.txt", sep = "\t")
dat_edit <- dat
colnames(dat_edit) <- c("species", "y", "x", "x2")
rownames(dat_edit) <- dat_edit$species
dat_edit <- dat_edit[, -c(1, 4)]
group <- c("archosaur", "archosaur", "lepidosaur", "lepidosaur", "mammal",
           "mammal", "archosaur", "lepidosaur", "archosaur", "mammal",
           "archosaur", "archosaur", "lepidosaur", "archosaur", "mammal",
           "mammal", "archosaur", "mammal", "mammal", "lepidosaur", "mammal",
           "archosaur", "lepidosaur", "lepidosaur", "lepidosaur", "archosaur",
           "archosaur")
dat_edit$group <- group
dat_tree <- dat
dat_tree$group <- group
dat_arc <- dat_edit[dat_edit$group == "archosaur", ]
dat_lep <- dat_edit[dat_edit$group == "lepidosaur", ]
dat_mam <- dat_edit[dat_edit$group == "mammal", ]
## Reference group: archosaur
dat_edit1 <- dat_edit
dat_edit1$dummy_lep <- ifelse(grepl("lepidosaur", dat_edit1$group), 1, 0)
dat_edit1$int_lep <- dat_edit1$x * dat_edit1$dummy_lep
dat_edit1$dummy_mam <- ifelse(grepl("mammal", dat_edit1$group), 1, 0)
dat_edit1$int_mam <- dat_edit1$x * dat_edit1$dummy_mam
## Reference group: lepidosaur
dat_edit2 <- dat_edit
dat_edit2$dummy_arc <- ifelse(grepl("archosaur", dat_edit2$group), 1, 0)
dat_edit2$int_arc <- dat_edit2$x * dat_edit2$dummy_arc
dat_edit2$dummy_mam <- ifelse(grepl("mammal", dat_edit2$group), 1, 0)
dat_edit2$int_mam <- dat_edit2$x * dat_edit2$dummy_mam
## Reference group: mammal
dat_edit3 <- dat_edit
dat_edit3$dummy_arc <- ifelse(grepl("archosaur", dat_edit3$group), 1, 0)
dat_edit3$int_arc <- dat_edit3$x * dat_edit3$dummy_arc
dat_edit3$dummy_lep <- ifelse(grepl("lepidosaur", dat_edit3$group), 1, 0)
dat_edit3$int_lep <- dat_edit3$x * dat_edit3$dummy_lep

# Write dataframes ----
write.table(
  dat_edit[, c(1:2)],
  file = "organ_surya_BayesTraits_data_validation_regression_1group.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)
write.table(
  dat_edit1[, -3],
  file = "organ_surya_BayesTraits_data_validation_regression_3group_arc.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)
write.table(
  dat_edit2[, -3],
  file = "organ_surya_BayesTraits_data_validation_regression_3group_lep.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)
write.table(
  dat_edit3[, -3],
  file = "organ_surya_BayesTraits_data_validation_regression_3group_mam.txt",
  quote = FALSE,
  sep = "\t",
  col.names = FALSE
)

# Read tree ----
tree <- read.newick(file = "organ_tree_validation.tre")

# Write tree in the NEXUS format ----
writeNexus(tree = tree, file = "organ_surya_tree_validation_v2.nex")

# Plot tree ----
plot_tree <-
  ggtree(tr = tree) %<+% dat_tree +
    xlim(0, 1) +
    geom_tiplab(offset = 0.025) +
    geom_tippoint(aes(color = group)) +
    theme_tree2(legend = "right", legend.title = element_blank()) +
    labs(caption = "substitutions/site")

# Save tree plot ----
CairoPDF("organ_surya_figure_validation_tree.pdf", width = 5, height = 5)
print(plot_tree)
graphics.off()

# Define correlation matrices ----
vcv_0 <- corPagel(value = 0.000001, phy = tree, fixed = TRUE)
vcv_est <- corPagel(value = 0, phy = tree)  # defauult value = 0
vcv_1 <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Fit GLS and PGLS models ----
pgls1 <- gls(y ~ x, data = dat_edit, correlation = vcv_0)
sum1 <- summary(pgls1)
beta0 <- as.numeric(pgls1$coefficients[1])
beta1 <- as.numeric(pgls1$coefficients[2])
p_val <- sum1$tTable[8]
sse <- sum(pgls1$residuals^2)
sst <- sum((dat_edit$y - mean(dat_edit$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum1$sigma^2
bic <- sum1$BIC
sink("organ_surya_R_output_validation_regression_1group_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls1)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
pgls2 <- gls(y ~ x, data = dat_edit, correlation = vcv_est)
sum2 <- summary(pgls2)
beta0 <- as.numeric(pgls2$coefficients[1])
beta1 <- as.numeric(pgls2$coefficients[2])
p_val <- sum2$tTable[8]
sse <- sum(pgls2$residuals^2)
sst <- sum((dat_edit$y - mean(dat_edit$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum2$sigma^2
bic <- sum2$BIC
sink("organ_surya_R_output_validation_regression_1group.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls2)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
pgls3 <- gls(y ~ x, data = dat_edit, correlation = vcv_1)
sum3 <- summary(pgls3)
beta0 <- as.numeric(pgls3$coefficients[1])
beta1 <- as.numeric(pgls3$coefficients[2])
p_val <- sum3$tTable[8]
sse <- sum(pgls3$residuals^2)
sst <- sum((dat_edit$y - mean(dat_edit$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum3$sigma^2
bic <- sum3$BIC
sink("organ_surya_R_output_validation_regression_1group_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls3)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
dat_edit$group <- as.factor(dat_edit$group)
pgls4 <- gls(y ~ x * group, data = dat_edit, correlation = vcv_0)
sum4 <- summary(pgls4)
beta0 <- as.numeric(pgls4$coefficients[1])
beta1 <- as.numeric(pgls4$coefficients[2])
beta2 <- as.numeric(pgls4$coefficients[3])
beta3 <- as.numeric(pgls4$coefficients[4])
beta4 <- as.numeric(pgls4$coefficients[5])
beta5 <- as.numeric(pgls4$coefficients[6])
p_val <- sum4$tTable[20]
sse <- sum(pgls4$residuals^2)
sst <- sum((dat_edit$y - mean(dat_edit$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum4$sigma^2
bic <- sum4$BIC
sink("organ_surya_R_output_validation_regression_3group_arc_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls4)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: archosaur) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
dat_edit2 <- dat_edit
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "lepidosaur")
pgls5 <- gls(y ~ x * group, data = dat_edit2, correlation = vcv_0)
sum5 <- summary(pgls5)
beta0 <- as.numeric(pgls5$coefficients[1])
beta1 <- as.numeric(pgls5$coefficients[2])
beta2 <- as.numeric(pgls5$coefficients[3])
beta3 <- as.numeric(pgls5$coefficients[4])
beta4 <- as.numeric(pgls5$coefficients[5])
beta5 <- as.numeric(pgls5$coefficients[6])
p_val <- sum5$tTable[20]
sse <- sum(pgls5$residuals^2)
sst <- sum((dat_edit2$y - mean(dat_edit2$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum5$sigma^2
bic <- sum5$BIC
sink("organ_surya_R_output_validation_regression_3group_lep_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls5)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: lepidosaur) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
dat_edit2$group <- relevel(dat_edit2$group, ref = "mammal")
pgls6 <- gls(y ~ x * group, data = dat_edit2, correlation = vcv_0)
sum6 <- summary(pgls6)
beta0 <- as.numeric(pgls6$coefficients[1])
beta1 <- as.numeric(pgls6$coefficients[2])
beta2 <- as.numeric(pgls6$coefficients[3])
beta3 <- as.numeric(pgls6$coefficients[4])
beta4 <- as.numeric(pgls6$coefficients[5])
beta5 <- as.numeric(pgls6$coefficients[6])
p_val <- sum6$tTable[20]
sse <- sum(pgls6$residuals^2)
sst <- sum((dat_edit2$y - mean(dat_edit2$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum6$sigma^2
bic <- sum6$BIC
sink("organ_surya_R_output_validation_regression_3group_mam_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls6)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: mammal) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
pgls7 <- gls(y ~ x * group, data = dat_edit, correlation = vcv_1)
sum7 <- summary(pgls7)
beta0 <- as.numeric(pgls7$coefficients[1])
beta1 <- as.numeric(pgls7$coefficients[2])
beta2 <- as.numeric(pgls7$coefficients[3])
beta3 <- as.numeric(pgls7$coefficients[4])
beta4 <- as.numeric(pgls7$coefficients[5])
beta5 <- as.numeric(pgls7$coefficients[6])
p_val <- sum7$tTable[20]
sse <- sum(pgls7$residuals^2)
sst <- sum((dat_edit$y - mean(dat_edit$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum7$sigma^2
bic <- sum7$BIC
sink("organ_surya_R_output_validation_regression_3group_arc_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls7)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: archosaur) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "lepidosaur")
pgls8 <- gls(y ~ x * group, data = dat_edit2, correlation = vcv_1)
sum8 <- summary(pgls8)
beta0 <- as.numeric(pgls8$coefficients[1])
beta1 <- as.numeric(pgls8$coefficients[2])
beta2 <- as.numeric(pgls8$coefficients[3])
beta3 <- as.numeric(pgls8$coefficients[4])
beta4 <- as.numeric(pgls8$coefficients[5])
beta5 <- as.numeric(pgls8$coefficients[6])
p_val <- sum8$tTable[20]
sse <- sum(pgls8$residuals^2)
sst <- sum((dat_edit2$y - mean(dat_edit2$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum8$sigma^2
bic <- sum8$BIC
sink("organ_surya_R_output_validation_regression_3group_lep_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls8)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: lepidosaur) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "mammal")
pgls9 <- gls(y ~ x * group, data = dat_edit2, correlation = vcv_1)
sum9 <- summary(pgls9)
beta0 <- as.numeric(pgls9$coefficients[1])
beta1 <- as.numeric(pgls9$coefficients[2])
beta2 <- as.numeric(pgls9$coefficients[3])
beta3 <- as.numeric(pgls9$coefficients[4])
beta4 <- as.numeric(pgls9$coefficients[5])
beta5 <- as.numeric(pgls9$coefficients[6])
p_val <- sum9$tTable[20]
sse <- sum(pgls9$residuals^2)
sst <- sum((dat_edit2$y - mean(dat_edit2$y))^2)
r2 <- 1 - sse/sst
sigma2 <- sum9$sigma^2
bic <- sum9$BIC
sink("organ_surya_R_output_validation_regression_3group_mam_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls9)
cat("\n")
cat(paste("Intercept = ", round(beta0, 3), "\n", sep = ""))
cat(paste("Slope (ref: mammal) = ", round(beta1, 3), "\n", sep = ""))
cat(paste("P-value (slope) = ", p_val, "\n", sep = ""))
cat(paste("R-squared = ", round(r2, 3), "\n", sep = ""))
cat(paste("Variance = ", round(sigma2, 3), "\n", sep = ""))
cat(paste("BIC = ", round(bic, 3), sep = ""))
cat("\n")
sink()

# Plot regression scatter plots ----
plot_pgls1 <-
  ggplot(dat_edit, aes(x, y)) +
    geom_point(color = "gray") +
    geom_segment(
      aes(color = "BayesTraits\nPagel's lambda = 1\n"),
      x = min(dat_edit$x),
      xend = max(dat_edit$x),
      y = 0.174214968762 + 0.584726757123*min(dat_edit$x),
      yend = 0.174214968762 + 0.584726757123*max(dat_edit$x),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "BayesTraits\nPagel's lambda = 0\n"),
      x = min(dat_edit$x),
      xend = max(dat_edit$x),
      y = -1.464572737412 + 0.576356017299*min(dat_edit$x),
      yend = -1.464572737412 + 0.576356017299*max(dat_edit$x),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R\nPagel's lambda = 1\n"),
      x = min(dat_edit$x),
      xend = max(dat_edit$x),
      y = -2.643534 + 0.6182929*min(dat_edit$x),
      yend = -2.643534 + 0.6182929*max(dat_edit$x),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R\nPagel's lambda = 0\n"),
      x = min(dat_edit$x),
      xend = max(dat_edit$x),
      y = -1.9924498 + 0.5796281*min(dat_edit$x),
      yend = -1.9924498 + 0.5796281*max(dat_edit$x),
      size = 0.5
    ) +
    scale_colour_manual(values = c("light blue", "blue", "pink", "red")) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      axis.title.y = element_text(angle = 0, vjust = 0.5),
      legend.title = element_blank()
    ) +
    labs(x = "\nx", y = "y    ")
plot_pgls3_lambda0 <-
  ggplot(dat_edit, aes(x, y, color = group)) +
    geom_point(alpha = 0.5) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_arc$x),
      xend = max(dat_arc$x),
      y = 2.297701116575 + 0.47846900691*min(dat_arc$x),
      yend = 2.297701116575 + 0.47846900691*max(dat_arc$x),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_arc$x),
      xend = max(dat_arc$x),
      y = 1.843236 + 0.481679*min(dat_arc$x),
      yend = 1.843236 + 0.481679*max(dat_arc$x),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_lep$x),
      xend = max(dat_lep$x),
      y = -5.695801798344 + 0.649642654045*min(dat_lep$x),
      yend = -5.695801798344 + 0.649642654045*max(dat_lep$x),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_lep$x),
      xend = max(dat_lep$x),
      y = -5.83692 + 0.631059*min(dat_lep$x),
      yend = -5.83692 + 0.631059*max(dat_lep$x),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_mam$x),
      xend = max(dat_mam$x),
      y = -1.828691512934 + 0.630794780946*min(dat_mam$x),
      yend = -1.828691512934 + 0.630794780946*max(dat_mam$x),
      color = "#619CFF",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_mam$x),
      xend = max(dat_mam$x),
      y = -1.814409 + 0.616923*min(dat_mam$x),
      yend = -1.814409 + 0.616923*max(dat_mam$x),
      color = "#619CFF",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      axis.title.y = element_text(angle = 0, vjust = 0.5),
      legend.title = element_blank()
    ) +
    labs(subtitle = "Pagel's Lambda = 0.000001", x = "\nx", y = "y    ")
plot_pgls3_lambda1 <-
  ggplot(dat_edit, aes(x, y, color = group)) +
    geom_point(alpha = 0.5) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_arc$x),
      xend = max(dat_arc$x),
      y = 6.506865765444 + 0.422180497768*min(dat_arc$x),
      yend = 6.506865765444 + 0.422180497768*max(dat_arc$x),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_arc$x),
      xend = max(dat_arc$x),
      y = 6.93841 + 0.422717*min(dat_arc$x),
      yend = 6.93841 + 0.422717*max(dat_arc$x),
      color = "#F8766D",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_lep$x),
      xend = max(dat_lep$x),
      y = -10.856553236939 + 0.794122232591*min(dat_lep$x),
      yend = -10.856553236939 + 0.794122232591*max(dat_lep$x),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_lep$x),
      xend = max(dat_lep$x),
      y = -13.024234 + 0.802878*min(dat_lep$x),
      yend = -13.024234 + 0.802878*max(dat_lep$x),
      color = "#00BA38",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "BayesTraits"),
      x = min(dat_mam$x),
      xend = max(dat_mam$x),
      y = 0.709994501247 + 0.606051973119*min(dat_mam$x),
      yend = 0.709994501247 + 0.606051973119*max(dat_mam$x),
      color = "#619CFF",
      size = 1
    ) +
    geom_segment(
      aes(linetype = "R"),
      x = min(dat_mam$x),
      xend = max(dat_mam$x),
      y = -1.711673 + 0.599237*min(dat_mam$x),
      yend = -1.711673 + 0.599237*max(dat_mam$x),
      color = "#619CFF",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      axis.title.y = element_text(angle = 0, vjust = 0.5),
      legend.title = element_blank()
    ) +
    labs(subtitle = "Pagel's Lambda = 1", x = "\nx", y = "y    ")

# Save regression scatter plots ----
CairoPDF("organ_surya_figure_validation_regression_1group.pdf", width = 6,
         height = 5)
print(plot_pgls1)
graphics.off()
CairoPDF("organ_surya_figure_validation_regression_3group_lambda0.pdf",
         width = 6, height = 5)
print(plot_pgls3_lambda0)
graphics.off()
CairoPDF("organ_surya_figure_validation_regression_3group_lambda1.pdf",
         width = 6, height = 5)
print(plot_pgls3_lambda1)
graphics.off()
