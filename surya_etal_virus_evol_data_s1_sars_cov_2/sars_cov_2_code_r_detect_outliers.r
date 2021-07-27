# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


# Read data ----
dat <- read.table("sars_cov_2_data.txt", sep = "\t", header = TRUE)

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
### character(0)
## as.character(out3)
###  [1] "hCoV-19/Australia/VIC753/2020|EPI_ISL_427030|2020-03-30|Oceania"
###  [2] "hCoV-19/England/BIRM-5E2EF/2020|EPI_ISL_444283|2020-04-16|Europe"
###  [3] "hCoV-19/England/CAMB-1AA2E3/2020|EPI_ISL_443676|2020-04-17|Europe"
###  [4] "hCoV-19/England/CAMB-1AC15D/2020|EPI_ISL_444377|2020-04-28|Europe"
###  [5] "hCoV-19/England/CAMB-1AD189/2020|EPI_ISL_447973|2020-04-29|Europe"
###  [6] "hCoV-19/England/CAMB-7C096/2020|EPI_ISL_433988|2020-04-13|Europe"
###  [7] "hCoV-19/England/CAMB-8224C/2020|EPI_ISL_443452|2020-04-14|Europe"
###  [8] "hCoV-19/England/CAMB-83797/2020|EPI_ISL_443446|2020-04-15|Europe"
###  [9] "hCoV-19/England/CAMB-8465D/2020|EPI_ISL_438745|2020-04-26|Europe"
### [10] "hCoV-19/Malaysia/190300/2020|EPI_ISL_417920|2020-03-22|Asia"
### [11] "hCoV-19/Poland/Pom13/2020|EPI_ISL_451654|2020-05-04|Europe"
### [12] "hCoV-19/Poland/Pom2/2020|EPI_ISL_450746|2020-05-08|Europe"
### [13] "hCoV-19/Scotland/EDB146/2020|EPI_ISL_425915|2020-03-23|Europe"
### [14] "hCoV-19/South_Africa/R02606/2020|EPI_ISL_435058|2020-03-11|Africa"
### [15] "hCoV-19/Taiwan/TSGH-32/2020|EPI_ISL_447591|2020-03-20|Asia"
### [16] "hCoV-19/Turkey/6224-Ankara1034/2020|EPI_ISL_417413|2020-03-17|Europe"
### [17] "hCoV-19/Uganda/UG014/2020|EPI_ISL_451196|2020-03-25|Africa"
### [18] "hCoV-19/USA/ID-UW-4100/2020|EPI_ISL_427168|2020-03-29|NorthAmerica"
### [19] "hCoV-19/USA/ID-UW-4462/2020|EPI_ISL_427171|2020-03-29|NorthAmerica"
### [20] "hCoV-19/USA/VA-DCLS-0083/2020|EPI_ISL_429981|2020-04-03|NorthAmerica"
### [21] "hCoV-19/USA/WA-UW-4130/2020|EPI_ISL_427244|2020-03-31|NorthAmerica"
### [22] "hCoV-19/Wales/PHWC-2A422/2020|EPI_ISL_445567|2020-04-06|Europe"
### [23] "hCoV-19/Wales/PHWC-2B1C0/2020|EPI_ISL_432378|2020-04-08|Europe"
### [24] "hCoV-19/Wales/PHWC-31BAB/2020|EPI_ISL_446538|2020-04-12|Europe"
