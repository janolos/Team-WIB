library("rcompanion")
library("fastR2")
library("car")
library(readr)
DF2019 <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2019 (2018) Census Business Data Updated.csv")
View(DF2019)

#Subset 2019 include: NAICS code, Owners sex, Sales
keeps = c("NAICS2017", "SECTOR", "SEX", "RCPPDEMP")
DF1 = DF2019[keeps]
names(DF1)[names(DF1)=="SEX"] = "Owners_Sex"
names(DF1)[names(DF1)=="NAICS2017"] = "NAICS Code"
names(DF1)[names(DF1)=="RCPPDEMP"] = "Sales"
names(DF1)[names(DF1)=="SECTOR"] = "Econ. Sector Code"
View(DF1)

#Convert sales to numeric values
str(DF1$Sales)
DF1$Sales2 = as.numeric(DF1$Sales)
DF2 = na.omit(DF1)
View(DF2) #Note that Sales only applies to NAICS with 0 codes.