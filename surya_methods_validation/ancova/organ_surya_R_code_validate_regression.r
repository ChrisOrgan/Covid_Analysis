# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# library(ape)  # v5.3
library(Cairo)  # v1.5.12
library(ggimage)  # v0.2.8
library(ggplot2)  # v3.3.0
library(ggthemes)  # v4.2.0
library(ggtree)  # v1.14.6
library(nlme)  # v3.1.147
library(phytools)  # v0.7.20


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

# Reorder data frames ----
dat_edit <- dat_edit[match(tree$tip.label, rownames(dat_edit)), ]
dat_edit1 <- dat_edit1[match(tree$tip.label, rownames(dat_edit1)), ]
dat_edit2 <- dat_edit2[match(tree$tip.label, rownames(dat_edit2)), ]
dat_edit3 <- dat_edit3[match(tree$tip.label, rownames(dat_edit3)), ]

# Define variance-covariance matrices ----
vcv_0 <- diag(nrow = length(tree$tip.label))
vcv_1 <- vcv(tree)
## When lambda is unfixed, transform the matrix later after estimating lambda

# Define correlation matrices ----
cor_0 <- corPagel(value = 0.000001, phy = tree, fixed = TRUE)
cor_est <- corPagel(value = 1, phy = tree)  # initial value = 1
cor_1 <- corPagel(value = 1, phy = tree, fixed = TRUE)

# Define variance weights ----
vf <- diag(vcv(tree))

# Fit OLS and PGLS models ----
pgls1 <- gls(
  y ~ x,
  data = dat_edit,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum1 <- summary(pgls1)
res_raw <- as.numeric(pgls1$residuals)
res_null <- as.matrix(dat_edit$y - mean(dat_edit$y))
sse <- as.numeric(t(res_raw) %*% solve(vcv_0) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_0) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum1$sigma^2
sink("organ_surya_R_output_validation_regression_1group_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls1)
cat("\n")
sum1$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls2 <- gls(
  y ~ x,
  data = dat_edit,
  correlation = cor_est,
  weights = varFixed(~vf),
  method = "ML"
)
sum2 <- summary(pgls2)
res_raw <- as.numeric(pgls2$residuals)
pgls_null <- gls(
  y ~ 1,
  data = dat_edit,
  correlation = cor_est,
  weights = varFixed(~vf),
  method = "ML"
)
mean_phylo <- as.numeric(pgls_null$coefficients[1])
res_null <- as.matrix(dat_edit$y - mean_phylo)
## We cannot specify a variance-covariance matrix with a negative lambda
vcv_est <- vcv_0
diag(vcv_est) <- diag(vcv(tree))
sse <- as.numeric(t(res_raw) %*% solve(vcv_est) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_est) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum2$sigma^2
sink("organ_surya_R_output_validation_regression_1group.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls2)
cat("\n")
sum2$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls3 <- gls(
  y ~ x,
  data = dat_edit,
  correlation = cor_1,
  weights = varFixed(~vf),
  method = "ML"
)
sum3 <- summary(pgls3)
res_raw <- as.numeric(pgls3$residuals)
pgls_null <- gls(
  y ~ 1,
  data = dat_edit,
  correlation = cor_1,
  weights = varFixed(~vf),
  method = "ML"
)
mean_phylo <- as.numeric(pgls_null$coefficients[1])
res_null <- as.matrix(dat_edit$y - mean_phylo)
sse <- as.numeric(t(res_raw) %*% solve(vcv_1) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_1) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum3$sigma^2
sink("organ_surya_R_output_validation_regression_1group_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls3)
cat("\n")
sum3$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
dat_edit$group <- as.factor(dat_edit$group)
pgls4 <- gls(
  y ~ x * group,
  data = dat_edit,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum4 <- summary(pgls4)
res_raw <- as.numeric(pgls4$residuals)
res_null <- as.matrix(dat_edit$y - mean(dat_edit$y))
sse <- as.numeric(t(res_raw) %*% solve(vcv_0) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_0) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum4$sigma^2
sink("organ_surya_R_output_validation_regression_3group_arc_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls4)
cat("\n")
sum4$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
dat_edit2 <- dat_edit
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "lepidosaur")
pgls5 <- gls(
  y ~ x * group,
  data = dat_edit2,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum5 <- summary(pgls5)
res_raw <- as.numeric(pgls5$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_0) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_0) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum5$sigma^2
sink("organ_surya_R_output_validation_regression_3group_lep_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls5)
cat("\n")
sum5$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
dat_edit2$group <- relevel(dat_edit2$group, ref = "mammal")
pgls6 <- gls(
  y ~ x * group,
  data = dat_edit2,
  correlation = NULL,
  weights = NULL,
  method = "ML"
)
sum6 <- summary(pgls6)
res_raw <- as.numeric(pgls6$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_0) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_0) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum6$sigma^2
sink("organ_surya_R_output_validation_regression_3group_mam_lambda0.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls6)
cat("\n")
sum6$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
pgls7 <- gls(
  y ~ x * group,
  data = dat_edit,
  correlation = cor_1,
  weights = varFixed(~vf),
  method = "ML"
)
sum7 <- summary(pgls7)
res_raw <- as.numeric(pgls7$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_1) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_1) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum7$sigma^2
sink("organ_surya_R_output_validation_regression_3group_arc_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls7)
cat("\n")
sum7$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "lepidosaur")
pgls8 <- gls(
  y ~ x * group,
  data = dat_edit2,
  correlation = cor_1,
  weights = varFixed(~vf),
  method = "ML"
)
sum8 <- summary(pgls8)
res_raw <- as.numeric(pgls8$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_1) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_1) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum8$sigma^2
sink("organ_surya_R_output_validation_regression_3group_lep_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls8)
cat("\n")
sum8$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
cat("\n")
sink()
dat_edit2$group <- as.factor(dat_edit2$group)
dat_edit2$group <- relevel(dat_edit2$group, ref = "mammal")
pgls9 <- gls(
  y ~ x * group,
  data = dat_edit2,
  correlation = cor_1,
  weights = varFixed(~vf),
  method = "ML"
)
sum9 <- summary(pgls9)
res_raw <- as.numeric(pgls9$residuals)
sse <- as.numeric(t(res_raw) %*% solve(vcv_1) %*% res_raw)
sst <- as.numeric(t(res_null) %*% solve(vcv_1) %*% res_null)
r2 <- 1 - sse/sst
sigma2 <- sum9$sigma^2
sink("organ_surya_R_output_validation_regression_3group_mam_lambda1.txt")
cat("==========\n")
cat("Regression\n")
cat("==========\n\n")
summary(pgls9)
cat("\n")
sum9$tTable
cat("\n")
cat(paste("R-squared = ", r2, "\n", sep = ""))
cat(paste("Variance = ", sigma2, sep = ""))
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
      y = 0.174215 + 0.5847268*min(dat_edit$x),
      yend = 0.174215 + 0.5847268*max(dat_edit$x),
      size = 0.5
    ) +
    geom_segment(
      aes(color = "R\nPagel's lambda = 0\n"),
      x = min(dat_edit$x),
      xend = max(dat_edit$x),
      y = -1.9924521 + 0.5796281*min(dat_edit$x),
      yend = -1.9924521 + 0.5796281*max(dat_edit$x),
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
      y = 1.843233 + 0.4816794*min(dat_arc$x),
      yend = 1.843233 + 0.4816794*max(dat_arc$x),
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
      y = -5.83692536 + 0.63105849*min(dat_lep$x),
      yend = -5.83692536 + 0.63105849*max(dat_lep$x),
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
      y = -1.81440998 + 0.6169228*min(dat_mam$x),
      yend = -1.81440998 + 0.6169228*max(dat_mam$x),
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
      y = 6.5068658 + 0.4221805*min(dat_arc$x),
      yend = 6.5068658 + 0.4221805*max(dat_arc$x),
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
      y = -10.8565532 + 0.7941222*min(dat_lep$x),
      yend = -10.8565532 + 0.7941222*max(dat_lep$x),
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
      y = 0.7099945 + 0.606052*min(dat_mam$x),
      yend = 0.7099945 + 0.606052*max(dat_mam$x),
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
