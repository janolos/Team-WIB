library("mvnormtest")
library("car")
library(readr)
X2020_2019_Census_Business_Data <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2020-2019 Census Business Data.csv")
View(X2020_2019_Census_Business_Data)
#subset the dataframe for proper analysis

keeps = c("SEX", "ETH_GROUP", "RACE_GROUP", "VET_GROUP", "RCPPDEMP", "EMP", "RCPPDEMP_S", "EMP_S")
WB2020 = X2020_2019_Census_Business_Data[keeps]
View(WB2020)
#rename columns:
names(WB2020)[names(WB2020)=="SEX"] = "Owners_Sex"
names(WB2020)[names(WB2020)=="ETH_GROUP"] = "Owners_Ethnicity"
names(WB2020)[names(WB2020)=="RACE_GROUP"] = "Owners_Race"
names(WB2020)[names(WB2020)=="VET_GROUP"] = "Vet_Status"
names(WB2020)[names(WB2020)=="RCPPDEMP"] = "Sales"
names(WB2020)[names(WB2020)=="EMP"] = "Employees"
names(WB2020)[names(WB2020)=="RCPPDEMP_S"] = "Sales_Std_Error"
names(WB2020)[names(WB2020)=="EMP_S"] = "Employees_Std_Error"

#DV = Sales, Employees 
#IV = Owners_Sex, Owners_Ethnicity
#Test assumptions: only need to test normality of DV
library("dplyr")
library("rcompanion")
keeps1 = c("Sales", "Employees")
WB2020_2 = WB2020[keeps1]
View(WB2020_2)
str(WB2020_2$Sales)
str(WB2020_2$Employees) #convert to numeric
WB2020_2$Employees = as.numeric(WB2020_2$Employees)

