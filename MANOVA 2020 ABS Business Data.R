library("mvnormtest")
library("car")
library(readr)
X2020_2019_Census_Business_Data <- read_csv("C:/Users/janol/TEAM WIB FINAL PROJECT/2020-2019 Census Business Data.csv")
View(X2020_2019_Census_Business_Data)
#subset the dataframe for proper analysis

keeps = c("NAICS2017", "SEX", "ETH_GROUP", "RACE_GROUP", "VET_GROUP", "RCPPDEMP", "EMP", "RCPPDEMP_S", "EMP_S")
WB2020 = X2020_2019_Census_Business_Data[keeps]
View(WB2020)
#rename columns:
names(WB2020)[names(WB2020)=="NAICS2017"] = "NAICS"
names(WB2020)[names(WB2020)=="SEX"] = "Owners_Sex"
names(WB2020)[names(WB2020)=="ETH_GROUP"] = "Owners_Ethnicity"
names(WB2020)[names(WB2020)=="RACE_GROUP"] = "Owners_Race"
names(WB2020)[names(WB2020)=="VET_GROUP"] = "Vet_Status"
names(WB2020)[names(WB2020)=="RCPPDEMP"] = "Sales"
names(WB2020)[names(WB2020)=="EMP"] = "Employees"
names(WB2020)[names(WB2020)=="RCPPDEMP_S"] = "Sales_Std_Error"
names(WB2020)[names(WB2020)=="EMP_S"] = "Employees_Std_Error"
#Filter data to only look at female-owned businesses
WB2020_F = filter(WB2020, Owners_Sex %in% c("002"))
View(WB2020_F)

#DV = Sales, Employees, NAICS 
#IV = Owners_Sex, Owners_Ethnicity, Oweners_Race, Vet_Status
#Does ethnicity of female owned businesses influence the number of sales and the number of employees?
#Test assumptions: only need to test normality of DV
library("dplyr")
library("rcompanion")
keeps1 = c("Sales", "Employees", "NAICS")
WB2020_2 = WB2020_F[keeps1]
View(WB2020_2)
str(WB2020_2$Sales)
str(WB2020_2$Employees) 
str(WB2020_2$NAICS)
#convert to numeric
WB2020_2$Sales2 = as.numeric(WB2020_2$Sales)
WB2020_2$Employees2 = as.numeric(WB2020_2$Employees)
WB2020_2$NAICS2 = as.numeric(WB2020_2$NAICS)
keeps2 = c("Sales2", "Employees2")
WB2020_3 = WB2020_2[keeps2]
WB2020_4 = WB2020_3[1:5000,]
#Format the data as a matrix
WB2020_5 = as.matrix(WB2020_4)

#Test for multivariate normality
#drop any missing values:
WB2020_6 = na.omit(WB2020_5)
#use Wilks-Shapiro test
mshapiro.test(t(WB2020_6))
#p-value is significant since p < 0.05 and therefore violates the assumption of multivariate normality.
#Therefore, this dataset does not meet the assumption for MANOVAs, but for learning purposes continue:

#Test homogeneity of variance:
#Need Sales & Employees in numeric form
WB2020_F$Sales_N = as.numeric(WB2020_F$Sales)
WB2020_F$Employees_N = as.numeric(WB2020_F$Employees)
leveneTest(WB2020_F$Sales_N, WB2020_F$Owners_Race, data = WB2020_F)
leveneTest(WB2020_F$Employees_N, WB2020_F$Owners_Race, data = WB2020_F)
#Neither variable met the assumption of homogeneity of variance since both were significant at p-value < 0.05.

#Continue to determine absence of multicollinearity
cor.test(WB2020_F$Sales_N, WB2020_F$Employees_N, method="pearson", use="complete.obs")
#With a correlation of r = 0.97, absence of multicollinearity is met.

MANOVA = manova(cbind(Sales_N, Employees_N) ~ Owners_Race, data = WB2020_F)
summary(MANOVA)
#There is a significant difference in sales and employees in female-owned businesses where ethnicity plays a factor.

#Post Hocs
summary.aov(MANOVA, test = "wilks")
#Post Hocs reveals that there is a significant difference in both the number of sales and the number of employees by ethnicity in female-owned businesses.
