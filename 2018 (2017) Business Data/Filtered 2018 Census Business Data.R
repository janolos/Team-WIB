library("rcompanion")
library("fastR2")
library("car")
library(readr)
DF2018 <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2018 (2017) Census Business Data Updated.csv")
View(DF2018)

#Subset DF2018, include: NAICS code, Owners sex, Sales
keeps = c("NAICS2017", "SEX", "RCPPDEMP")
df1 = DF2018[keeps]
names(df1)[names(df1)=="SEX"] = "Owners_Sex"
names(df1)[names(df1)=="NAICS2017"] = "NAICS Code"
names(df1)[names(df1)=="RCPPDEMP"] = "Sales"
View(df1)

#Convert sales to numeric values
str(df1$Sales)
df1$Sales = as.numeric(df1$Sales)
df2 = na.omit(df1)
View(df2)
