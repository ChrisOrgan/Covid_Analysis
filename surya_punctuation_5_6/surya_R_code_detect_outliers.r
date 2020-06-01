# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")

# Detect outliers ----
q1 <- as.numeric(quantile(dat$path)[2])
q3 <- as.numeric(quantile(dat$path)[4])
iqr <- q3 - q1
thresh1 <- q1 - 3*iqr
thresh3 <- q3 + 3*iqr
out1 <- dat[dat$path < thresh1, ]
out3 <- dat[dat$path > thresh3, ]
sink("surya_R_output_outliers.txt")
cat("==============================\n")
cat("Outliers (Lower [Outer] Fence)\n")
cat("==============================\n\n")
as.character(out1$genome)
cat("\n==============================\n")
cat("Outliers (Upper [Outer] Fence)\n")
cat("==============================\n\n")
as.character(out3$genome)
sink()
