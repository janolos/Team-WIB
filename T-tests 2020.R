library("rcompanion")
library("fastR2")
library("car")
library(readr)
DF2020 <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2020-2019 Census Business Data.csv")
View(DF2020)

#Subset 2020 include: NAICS code, Owners sex, Sales
keeps = c("NAICS2017", "SEX", "ETH_GROUP", "RACE_GROUP", "RCPPDEMP")
df2020 = DF2020[keeps]
names(df2020)[names(df2020)=="SEX"] = "Owners_Sex"
names(df2020)[names(df2020)=="NAICS2017"] = "NAICS Code"
names(df2020)[names(df2020)=="ETH_GROUP"] = "Ethnicity"
names(df2020)[names(df2020)=="RACE_GROUP"] = "Race"
names(df2020)[names(df2020)=="RCPPDEMP"] = "Sales"

#Convert sales to numeric values
str(df2020$Sales)
df2020$Sales2 = as.numeric(df2020$Sales)
df2020_1 = na.omit(df2020)
View(df2020_1) 

#Filter df2020_1 to include both male- and female-owned businesses
df2020_2w = filter(df2020_1, Owners_Sex %in% c("002"))
df2020_2m = filter(df2020_1, Owners_Sex %in% c("003"))
df2020_2 = rbind(df2020_2w, df2020_2m)
View(df2020_2)

#Independent t-test:
#How were sales affected in 2020 when comparing male-owned businesses vs. female-owned businesses?
SalesM = t.test(df2020_2m$Sales2, df2020_2w$Sales2, althernative="two-sided", var.equal=FALSE)
SalesM #p-value is significant and therefore the mean differences are significant
mean(df2020_2m$Sales2) #$468,772,666
mean(df2020_2w$Sales2) #$88,486,354
ggplot(df2020_2) + geom_boxplot(aes(x= Owners_Sex, y = Sales2)) + scale_y_log10()

#Check linear regression in sales vs. race and/or sales vs. ethnicity:
library(ggplot2)
Sales_Race = ggplot(df2020, aes(x = Race, y = Sales2))
Sales_Race + geom_point() + scale_y_log10() #no linear relationship
Sales_Race + geom_boxplot() + scale_y_log10()
ggplot(df2020_1, aes(Race))+geom_bar() 
#There were more businesses that were owned by a white, Caucasian person in 2020. 
#The second dominating race were black, African-American owners. 
ES = ggplot(df2020, aes(x=Ethnicity, y=Sales2))
ES + geom_point() #no linear relationship
ES + geom_boxplot() + scale_y_log10()
ggplot(df2020_1, aes(Ethnicity))+geom_bar()
#Majority of businesses were non-Hispanics and the second most owned businesses were Hispanic owners. 

#Check linear regressions related to male-owned vs. female-owned vs. equally male/female-owned businesses:
SS = ggplot(df2020_1, aes(x=Owners_Sex, y = Sales2))
SS + geom_point() #There is no linear relationship between Sales and Owners_Sex.
SS + geom_boxplot() + scale_y_log10()
ggplot(df2020_1, aes(Owners_Sex))+geom_bar() #There were more male-owned businesses in 2020. 
