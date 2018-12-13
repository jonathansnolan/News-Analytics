#######################################################
# Jonathan Nolan
#
# OBJECTIVE
# This will calculate volatility according to Bommes
# It is based on the formula presented by 
# Garman and Klauss (1980)
#######################################################

# 1. Load the Data
Data <- read.csv("GE.csv")
Test <- read.csv("GE.csv")

# 2. set the values of u, d and c
Data$u <- log(Data$High) - log(Data$Low)
Data$d <- log(Data$Low) - log(Data$Open)
Data$c <- log(Data$Close) - log(Data$Open)

# 3. Valculate the Volatility
Data$Volatility <- (0.511*((Data$u-Data$d)^2)) - (0.019*((Data$c*(Data$u+Data$d))-(2*(as.numeric(as.character(Data$u))*as.numeric(as.character(Data$d)))))) - 0.838*((Data$c)^2)

Volatility <- Data[,c(1,11)]

write.csv(Volatility, file = "Volatility.csv")