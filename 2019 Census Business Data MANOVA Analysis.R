library("mvnormtest")
library("car")
library("readr")
X2019_2018_Census_Business_Data <- read_csv("C:/Users/nbroo/OneDrive/Documents/Data Science Final Group Project/Women In Business Before And After The Pandemic/2019 (2018) Census Business Data.csv")
View(X2019_2018_Census_Business_Data)
#subset the dataframe for proper analysis

keeps = c("NAICS2017", "SEX", "ETH_GROUP", "RACE_GROUP", "VET_GROUP", "RCPPDEMP", "EMP", "RCPPDEMP_S", "EMP_S")
WB2019 = X2019_2018_Census_Business_Data[keeps]
View(WB2019)
#rename columns:
names(WB2019)[names(WB2019)=="NAICS2017"] = "NAICS"
names(WB2019)[names(WB2019)=="SEX"] = "Owners_Sex"
names(WB2019)[names(WB2019)=="ETH_GROUP"] = "Owners_Ethnicity"
names(WB2019)[names(WB2019)=="RACE_GROUP"] = "Owners_Race"
names(WB2019)[names(WB2019)=="VET_GROUP"] = "Vet_Status"
names(WB2019)[names(WB2019)=="RCPPDEMP"] = "Sales"
names(WB2019)[names(WB2019)=="EMP"] = "Employees"
names(WB2019)[names(WB2019)=="RCPPDEMP_S"] = "Sales_Std_Error"
names(WB2019)[names(WB2019)=="EMP_S"] = "Employees_Std_Error"
View(WB2019)

#Filter data to only look at female-owned businesses
WB2019F = filter(WB2019, Owners_Sex %in% c("2"))
View(WB2019F)

#DV = Sales, Employees, NAICS 
#IV = Owners_Sex, Owners_Ethnicity, Oweners_Race, Vet_Status
#Does ethnicity of female owned businesses influence the number of sales and the number of employees?
#Test assumptions: only need to test normality of DV
library("dplyr")
library("rcompanion")
keeps1 = c("Sales", "Employees", "NAICS")
WB2019_2 = WB2019F[keeps1]
View(WB2019_2)
str(WB2019_2$Sales)
str(WB2019_2$Employees) 
str(WB2019_2$NAICS)
#convert to numeric
WB2019_2$Sales2 = as.numeric(WB2019_2$Sales)
WB2019_2$Employees2 = as.numeric(WB2019_2$Employees)
WB2019_2$NAICS2 = as.numeric(WB2019_2$NAICS)
keeps2 = c("Sales2", "Employees2")
WB2019_3 = WB2019_2[keeps2]
WB2019_4 = WB2019_3[1:5000,]
#Format the data as a matrix
WB2019_5 = as.matrix(WB2019_4)

#Test for multivariate normality
#drop any missing values:
WB2019_6 = na.omit(WB2019_5)
#use Wilks-Shapiro test
mshapiro.test(t(WB2019_6))
#p-value is significant since p < 0.05 and therefore violates the assumption of multivariate normality.
#Therefore, this dataset does not meet the assumption for MANOVAs, but for learning purposes continue:

#Test homogeneity of variance:
#Need Sales & Employees in numeric form
WB2019F$Sales_N = as.numeric(WB2019F$Sales)
WB2019F$Employees_N = as.numeric(WB2019F$Employees)
leveneTest(WB2019F$Sales_N, WB2019F$Owners_Race, data = WB2019F)
leveneTest(WB2019F$Employees_N, WB2019F$Owners_Race, data = WB2019F)
#Neither variable met the assumption of homogeneity of variance since both were significant at p-value < 0.05.

#Continue to determine absence of multicollinearity
cor.test(WB2019F$Sales_N, WB2019F$Employees_N, method="pearson", use="complete.obs")
#With a correlation of r = 0.99, absence of multicollinearity is met.

MANOVA = manova(cbind(Sales_N, Employees_N) ~ Owners_Race, data = WB2019F)
summary(MANOVA)
#There is a significant difference in sales and employees in female-owned businesses where ethnicity plays a factor.

#Post Hocs
summary.aov(MANOVA, test = "wilks")
#Post Hocs reveals that there is a significant difference in both the number of sales and the number of employees by ethnicity in female-owned businesses.