
########################################## Panel Data Modelling ######################################

rm(list = ls())

library(data.table)
#---------------------------------------------
# 1. Loading data

Data <- read.csv("Final_Data.csv")


Data <- Data[,c(1:3,6,12)]



#------------------------------------------------------
# 2. Add Columns with Weekdays, Months and Years

#Days
Data$Days <- weekdays(as.Date(Data$Date))

#Months
Data$Months <- month(as.Date(Data$Date))

#Years
year <- Data$Date
year <- data.frame((substring(year,1,4)))
Data$Years <- year


write.csv(Data, file = "Data.csv")

company <- Data$Company.Name
company <- as.numeric(company)
View(company)
write.csv(company, file = "company.csv")

#---------------------------------------------
# 3. Loading Plm package 
library(plm)
attach(Data)

#---------------------------------------------
# 3. Set ID as Factor

Data$Company.Name <- as.factor(factor(Data$Company.Name))

View(Data)

##################################
#### PREVIOUS ####################
#Ross$DayOfWeek = as.factor(factor(Ross$DayOfWeek))
#View(Ross)
##################################

#---------------------------------------------
# 4. Identifying Dependent and Independent Variables

# Dependent variable
Y <- cbind(MA_AVG_Tone)

#Independent Variables
X <- cbind(PR_AVG_Tone) 

#---------------------------------------------
# 5. Set data as panel data - Setting ID as id

pdata <- pdata.frame(Data, index= c("Company.Name","Date"))

##################################
#### PREVIOUS ####################
#pdata <- plm.data(Ross, index=c("Store","Date"))
##################################


#---------------------------------------------
# 6. Descriptive statistics   
summary(Y)
summary(X)


#################################################### 


#---------------------------------------------
# 7. Pooled OLS estimator
pooling <- plm(Y ~ X, data=pdata, model= "pooling")
summary(pooling)



#---------------------------------------------
# 9. Fixed effects or within estimator 
fixed <- plm(Y ~ X, data=pdata, model= "within")
summary(fixed)




################################################# Random effects estimator #################################################
random <- plm(Y ~ X, data=pdata, model= "random")
summary(random)




################################################# LM test for random effects versus OLS ####################################
plmtest(pooling)
# p<0.05 i.e. Random effect is consistent

################################################ LM test for fixed effects versus OLS ######################################
pFtest(fixed, pooling) 
# p<0.05 fixed model model is more consitent

############################################### Hausman test for fixed versus random effects model #########################
phtest(random, fixed)
# p<0.05 i.e. fixed effect model is better 

############################################### pcd test to check whether errors have serial correlation ###################
pcdtest(fixed, test = c("cd"))
# p>0.05 i.e. errors don't have serial correlation


# Fixed 
# Calculating alpha (individual specific effect) for every individual after averaging out the time effect
Ability_Stores = data.frame(Store_Id = integer(0),Alpha = numeric()) # Data frame to capture alpha values
a = c() # Null vector to use in loop
for (i in 1:1115)
{
  x = Rossman[Rossman$Store==i,]
  a[i] = mean(x$Sales) - 8.454* mean(x$Customers) - 947.56*mean(x$Promo) + 26.821*mean(x$DayOfWeek) + 196.64*mean(as.numeric(x$StateHoliday)) - 118.24*mean(as.numeric(x$Open)) # Equation for alpha value calculation
  Ability_Stores[i,1] = i
  Ability_Stores[i,2] = a[i]
}
View(Ability_Stores) # View Data frame

