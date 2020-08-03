# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


# Load and prepare data ----
dat <- read.table("surya_wduplicates_R_data_path_lengths.txt", sep = "\t")
colnames(dat) <- c("genome", "path")

# Detect outliers ----
q1 <- as.numeric(quantile(dat$path)[2])
q3 <- as.numeric(quantile(dat$path)[4])
iqr <- q3 - q1
thresh1 <- q1 - 1.5*iqr
thresh3 <- q3 + 1.5*iqr
out1 <- dat[dat$path < thresh1, ]
out3 <- dat[dat$path > thresh3, ]
out1 <- out1$genome
out3 <- out3$genome
## as.character(out1)
## character(0)
## as.character(out3)
##  [1] "hCoV-19/Bangladesh/DNAS_CPH_436/2020|EPI_ISL_445217|2020-04-28|Asia"
##  [2] "hCoV-19/Bangladesh/DNAS_CPH_467/2020|EPI_ISL_445213|2020-04-28|Asia"
##  [3] "hCov-19/Bangladesh/DU_50761|EPI_ISL_450842|2020-05-06|Asia"
##  [4] "hCoV-19/Bangladesh/NIB_01/2020|EPI_ISL_447904|2020-05-11|Asia"
##  [5] "hCoV-19/England/OXON-AC6AA/2020|EPI_ISL_448475|2020-04-07|Europe"
##  [6] "hCoV-19/Philippines/PGC04/2020|EPI_ISL_434556|2020-03-26|Asia"
##  [7] "hCoV-19/Poland/Pom6/2020|EPI_ISL_451647|2020-04-23|Europe"
##  [8] "hCoV-19/Turkey/6224-Ankara1034/2020|EPI_ISL_417413|2020-03-17|Europe"
##  [9] "hCoV-19/Turkey/VETAL-_AHM1/2020|EPI_ISL_435057|2020-04-09|Europe"
## [10] "hCoV-19/USA/NY-PV09457/2020|EPI_ISL_450131|2020-03-19|NorthAmerica"
## [11] "hCoV-19/USA/VA-DCLS-0083/2020|EPI_ISL_429981|2020-04-03|NorthAmerica"
## [12] "hCoV-19/USA/VA-DCLS-0186/2020|EPI_ISL_437402|2020-04-07|NorthAmerica"
## [13] "hCoV-19/USA/VI-CDC-3884/2020|EPI_ISL_450805|2020-04-06|NorthAmerica"
## [14] "hCoV-19/USA/WA-UW-4749/2020|EPI_ISL_429620|2020-03-28|NorthAmerica"
write.table(
  out3,
  file = "surya_wduplicates_R_output_outliers.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
