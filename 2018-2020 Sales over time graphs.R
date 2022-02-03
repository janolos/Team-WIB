library("rcompanion")
library("fastR2")
library("car")
#Import 2018, 2019, & 2020 datasets 
library(readxl)
DF2018 <- read_excel("C:/Users/janol/TEAM WIB FINAL PROJECT/2018 (2017) Census Business Data.xlsx")
View(DF2018)
library(readr)
DF2019<- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2019 (2018) Census Business Data.csv")
View(DF2019)
DF2020 <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2020-2019 Census Business Data.csv")
View(DF2020)

#Combine datasets into one:
library("tidyverse")
df1 = full_join(DF2018, DF2019)
View(df1)
df2 = full_join(df1, DF2020)
View(df2)

#Data Wrangling:
keeps = c("SEX", "ETH_GROUP", "RACE_GROUP", "RCPPDEMP", "YEAR")
df3 = df2[keeps]
View(df3)

#rename columns:
names(df3)[names(df3)=="SEX"] = "Owners_Sex"
names(df3)[names(df3)=="ETH_GROUP"] = "Owners_Ethnicity"
names(df3)[names(df3)=="RACE_GROUP"] = "Owners_Race"
names(df3)[names(df3)=="RCPPDEMP"] = "Sales"

#filter df3 to contain both male and female businesses:
df3_f1 = filter(df3, Owners_Sex %in% c("2"))
df3_f2 = filter(df3, Owners_Sex %in% c("2.0"))
df3_f3 = filter(df3, Owners_Sex %in% c("002"))
df3_m1 = filter(df3, Owners_Sex %in% c("3"))
df3_m2 = filter(df3, Owners_Sex %in% c("3.0"))
df3_m3 = filter(df3, Owners_Sex %in% c("003"))
df4 = rbind(df3_f1, df3_f2, df3_f3, df3_m1, df3_m2, df3_m3)
DF4 = arrange(df4, YEAR)
View(DF4)

#need sales column to be numeric:
str(DF4$Sales)
DF4$Sales2 = as.numeric(DF4$Sales)
df5 = na.omit(DF4)
View(df5)

#determine if there is a linear relationship in sales amongst female-owned businesses:
library(ggplot2)
ggplot(df5) + geom_line(aes(x=YEAR, y = Sales2, color = Owners_Sex))
ggplot(df5) + geom_point(aes(x=YEAR, y = Sales2, color = Owners_Sex)) + ylab("Sales($)") + xlab("Year") + ggtitle("Female- & Male-Owned Businesses Sales Over Time")