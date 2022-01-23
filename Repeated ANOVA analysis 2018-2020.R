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

#Did female-owned businesses survive the pandemic? 

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
#filter df3 to only contain female businesses:
df3_f1 = filter(df3, SEX %in% c("2"))
df3_f2 = filter(df3, SEX %in% c("2.0"))
df3_f3 = filter(df3, SEX %in% c("002"))
df4 = rbind(df3_f1, df3_f2, df3_f3)
DF4 = arrange(df4, YEAR)
View(DF4)
#rename columns:
names(DF4)[names(DF4)=="SEX"] = "Owners_Sex"
names(DF4)[names(DF4)=="ETH_GROUP"] = "Owners_Ethnicity"
names(DF4)[names(DF4)=="RACE_GROUP"] = "Owners_Race"
names(DF4)[names(DF4)=="RCPPDEMP"] = "Sales"
#need sales column to be numeric:
str(DF4$Sales)
DF4$Sales2 = as.numeric(DF4$Sales)
df5 = na.omit(DF4)
View(df5)
#determine the number of rows for each year:
count(df5, YEAR) 
#2017 for rows 1-1506, 2018 for rows 1507-1833, 2019 for rows 1834-1935
#reshape dataframe:
keeps = c("Owners_Sex", "Owners_Ethnicity", "Owners_Race", "YEAR")
df5_T1 = df5[keeps]
df5_T1$repdat = df5$Sales2
#Assign T1 to Sales recorded in 2017 
DF5_T1 = df5_T1[1:1506,]
DF5_T1$contrasts = "T1"
#Assign T2 to Sales recorded in 2019
df5_T2 = df5[keeps]
df5_T2$repdat = df5$Sales2
DF5_T2 = df5_T2[1834:1935,]
DF5_T2$contrasts ="T2"
#Join T1 & T2 dataframes together:
df6 = rbind(DF5_T1, DF5_T2) #prepared to run repeated measures ANOVA

#test assumptions:
#test normality of DV at T1
plotNormalHistogram(DF5_T1$repdat) #positively skewed transform by taking the square root
DF5_T1$repdatSQRT = sqrt(DF5_T1$repdat)
plotNormalHistogram(DF5_T1$repdatSQRT) #slightly better, but transform again by taking log
DF5_T1$repdatLOG = log(DF5_T1$repdat) #slightly better, but check with transform Tukey
DF5_T1$repdatTUK = transformTukey(DF5_T1$repdat, plotit = FALSE)
plotNormalHistogram(DF5_T1$repdatTUK) #better distribution use this form
#test normality of DV at T2 
plotNormalHistogram(DF5_T2$repdat) #positively skewed, transform by taking the square root
DF5_T2$repdatSQRT = sqrt(DF5_T2$repdat)
plotNormalHistogram(DF5_T2$repdatSQRT) #better, but check and transform again by taking the log
DF5_T2$repdatLOG = log(DF5_T2$repdat)
plotNormalHistogram(DF5_T2$repdatLOG) #became negatively skewed, use transform Tukey to find normality
DF5_T2$repdatTUK = transformTukey(DF5_T2$repdat, plotit = FALSE)
plotNormalHistogram(DF5_T2$repdatTUK) #better distribution use this form
#Join new dataframe of T1 & T2 with transformed data:
df7 = rbind(DF5_T1, DF5_T2)

#test homogeneity of variance:
leveneTest(repdatTUK ~ YEAR*contrasts, data=df7)
#p-value is significant and violates this assumption, but continue to the analysis

#Analysis:
RManova = aov(repdat~contrasts+Error(YEAR), df7)
summary(RManova)
