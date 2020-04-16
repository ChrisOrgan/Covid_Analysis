# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
dat$node <- dat$node + 1  # This addition prevents log-transforming zero below

# Detect the node-density artifact ----
power_regression <- lm(log(path) ~ log(node), data = dat)
delta <- 1 / as.numeric(power_regression$coefficients[2])
sink("surya_R_output_node_density_artifact.txt")
cat("=================\n")
cat("Node-Density Test\n")
cat("=================\n")
summary(power_regression)
cat(paste("Delta = ", round(delta, 2), sep = ""))
cat("\n")
sink()
