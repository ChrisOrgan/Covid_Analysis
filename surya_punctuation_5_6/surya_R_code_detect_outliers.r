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
## as.character(out1)
## character(0)
## as.character(out3)
write.table(
  out3$genome,
  file = "surya_R_output_outliers.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
