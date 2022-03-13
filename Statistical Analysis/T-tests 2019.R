library("rcompanion")
library("fastR2")
library("car")
library("tidyr")
library("dplyr")
library("car")
library("ggplot2")
library(readr)
B2019 <- read_csv("C:/Users/nbroo/OneDrive/Documents/Data Science Final Group Project/Women In Business Before And After The Pandemic/2019 (2018) Census Business Data-2.csv")
View(B2019)

#Subset 2019 include: NAICS code, Owners sex, Sales
keeps = c("NAICS2017", "SEX", "ETH_GROUP", "RACE_GROUP", "RCPPDEMP")
b2019 = B2019[keeps]
names(b2019)[names(b2019)=="SEX"] = "Owners_Sex"
names(b2019)[names(b2019)=="NAICS2017"] = "NAICS Code"
names(b2019)[names(b2019)=="ETH_GROUP"] = "Ethnicity"
names(b2019)[names(b2019)=="RACE_GROUP"] = "Race"
names(b2019)[names(b2019)=="RCPPDEMP"] = "Sales"


#Convert sales to numeric values

str(b2019$Sales)
b2019$Sales2 = as.numeric(b2019$Sales)
b2019_1 = na.omit(b2019)
View(b2019_1) 

#Filter b2019_1 to include both male- and female-owned businesses
b2019_1w = filter(b2019_1, Owners_Sex %in% c("2", 2 ))
b2019_1m = filter(b2019_1, Owners_Sex %in% c("3", 3))
b2019_2 = rbind(b2019_1w, b2019_1m)
View(b2019_2)

#Independent t-test:
#How were sales affected in 2020 when comparing male-owned businesses vs. female-owned businesses?
SalesM = t.test(b2019_1m$Sales2, b2019_1w$Sales2, althernative="two-sided", var.equal=FALSE)
SalesM #p-value is significant and therefore the mean differences are significant
mean(b2019_1m$Sales2) 
#$1,259,860,253
mean(b2019_1w$Sales2) 
#$223,874,815
ggplot(b2019_2) + geom_boxplot(aes(x= Owners_Sex, y = Sales2)) + scale_y_log10()


#Check linear regression in sales vs. race 
Sales_Race = ggplot(b2019, aes(x = Race, y = Sales2))
Sales_Race + geom_point() + scale_y_log10() #no linear relationship
Sales_Race + geom_boxplot() + scale_y_log10()
ggplot(b2019_1, aes(Race))+geom_bar() 

#There were more businesses that were owned by a white, Caucasian person in 2019. 
#The second dominating race were black, African-American owners. 

# Check linear regression in sales vs. ethnicity:
ES = ggplot(b2019, aes(x=Ethnicity, y=Sales2))
ES + geom_point() #no linear relationship
ES + geom_boxplot() + scale_y_log10()
ggplot(b2019_1, aes(Ethnicity))+geom_bar()
#Majority of businesses were non-Hispanics and the second most owned businesses were Hispanic owners.

#Check linear regressions related to male-owned vs. female-owned vs. equally male/female-owned businesses:
SS = ggplot(b2019, aes(x=Owners_Sex, y = Sales2))
SS + geom_point() #There is no linear relationship between Sales and Owners_Sex.
SS + geom_boxplot() + scale_y_log10()
ggplot(b2019_1, aes(Owners_Sex))+geom_bar() #There were more male-owned businesses in 2019.Followed by equally male/female owned businesses.