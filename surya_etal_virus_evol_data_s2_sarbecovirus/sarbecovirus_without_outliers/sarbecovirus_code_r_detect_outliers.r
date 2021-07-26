# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(MASS)


# Read data ----
dat <- read.table(
  "sarbecovirus_data.txt",
  sep = "\t",
  header = TRUE,
  row.names = 1
)
dat <- dat[, -4]

# Detect outliers ----
output75 <- cov.mcd(dat, quantile.used = nrow(dat) * 0.75)
mhmcd75 <- mahalanobis(dat, output75$center, output75$cov)
alpha <- 0.01
cutoff <- qchisq(p = 1 - alpha, df = 3)
outliers <- names(which(mhmcd75 > cutoff))

# Write outliers to a text file ----
write.table(
  outliers,
  file = "sarbecovirus_data_outliers.txt",
  quote = FALSE,
  sep = "\n",
  row.names = FALSE,
  col.names = FALSE
)
