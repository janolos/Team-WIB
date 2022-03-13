library("mvnormtest")
library("car")
library(readxl)
X2018_2017_Census_Business_Data <- read_excel("C:/Users/janol/TEAM WIB FINAL PROJECT/2018 (2017) Census Business Data.xlsx")
View(X2018_2017_Census_Business_Data)

#subset dataframe for analysis
keeps = c("SEX", "ETH_GROUP", "RACE_GROUP", "RCPPDEMP", "EMP", "RCPPDEMP_S", "EMP_S")
WB2018 = X2018_2017_Census_Business_Data[keeps]
View(WB2018)
#rename columns:
names(WB2018)[names(WB2018)=="SEX"] = "Owners_Sex"
names(WB2018)[names(WB2018)=="ETH_GROUP"] = "Owners_Ethnicity"
names(WB2018)[names(WB2018)=="RACE_GROUP"] = "Owners_Race"
names(WB2018)[names(WB2018)=="RCPPDEMP"] = "Sales"
names(WB2018)[names(WB2018)=="EMP"] = "Employees"
names(WB2018)[names(WB2018)=="RCPPDEMP_S"] = "Sales_Std_Error"
names(WB2018)[names(WB2018)=="EMP_S"] = "Employees_Std_Error"
#Filter data to only look at female-owned businesses
WB2018_F = filter(WB2018, Owners_Sex == "2.0")
View(WB2018_F)

#DV = Sales, Employees, NAICS 
#Does race of female owned businesses influence the number of sales and the number of employees?
#Test assumptions: only need to test normality of DV
library("dplyr")
library("rcompanion")
keeps1 = c("Sales", "Employees")
WB2018_2 = WB2018_F[keeps1]
View(WB2018_2)
str(WB2018_2$Sales)
str(WB2018_2$Employees) #convert to numeric for both columns
WB2018_2$SalesN = as.numeric(WB2018_2$Sales)
WB2018_2$EmployeesN = as.numeric(WB2018_2$Employees)
keeps2 = c("SalesN", "EmployeesN")
WB2018_3 = WB2018_2[keeps2]
WB2018_4 = WB2018_3[1:5000,]
#format data into a matrix:
WB2018_5 = as.matrix(WB2018_4)

#Test for multivariate normality
#drop any missing values:
WB2018_6 = na.omit(WB2018_5)
#use Wilks-Shapiro test
mshapiro.test(t(WB2018_6))
#p-value is significant since p < 0.05 and therefore violates the assumption of multivariate normality.
#Therefore, this dataset does not meet the assumption for MANOVAs, but for learning purposes continue:

#Test homogeneity of variance:
#Need Sales & Employees in numeric form
WB2018_F$SalesN = as.numeric(WB2018_F$Sales)
WB2018_F$EmployeesN = as.numeric(WB2018_F$Employees)
WB2018_F2 = na.omit(WB2018_F)
leveneTest(WB2018_F2$SalesN, WB2018_F2$Owners_Race, data = WB2018_F2)
leveneTest(WB2018_F2$EmployeesN, WB2018_F2$Owners_Race, data = WB2018_F2)
#leveneTest not working because Owners_Race only has one factor: 0.0
#Tried with Owners_Ethnicity, same issue only has one factor: 1.0

#Continue to determine absence of multicollinearity
cor.test(WB2018_F2$SalesN, WB2018_F2$EmployeesN, method="pearson", use="complete.obs")
#With a correlation of r = 0.99, absence of multicollinearity is met.

MANOVA = manova(cbind(SalesN, EmployeesN) ~ Owners_Race, data = WB2018_F2)
summary(MANOVA)
#There is a significant difference between number of sales and number of employees where race plays a factor; however, 
#cannot take these results effectively since it did not meet the assumptions for MANOVA, but will look at post hocs.

#Post Hocs
summary.aov(MANOVA, test = "wilks")
#Post Hocs reveals that there is a significant difference in both the number of sales and the number of employees by race in female-owned businesses.
