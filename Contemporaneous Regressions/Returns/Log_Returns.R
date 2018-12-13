#######################################################
# Jonathan Nolan ######################################
# Data Clean Up First #################################
#######################################################
# OBJECTIVE:
# To calculate the log returns of the SPX

#------------------------------------------------------
# Load the relevant Dataset
#------------------------------------------------------

GE = read.csv("GE.csv")

#------------------------------------------------------
# Calculate Log Returns
#------------------------------------------------------

n <- length(GE$Close);
GEReturns <- log(GE$Close[-1]/GE$Close[-n])
GEReturns <- GEReturns*100

#------------------------------------------------------
# Create Dataset of Dates and Log Returns
#------------------------------------------------------

Dates <- GE$date
Dates <- data.frame(Dates)
Dates <- Dates[2:3268,]
Dates <- data.frame(Dates)

LogReturns <- Dates
LogReturns$GEReturns <- GEReturns

#------------------------------------------------------
# Write CSV file containing Date and Log Returns
#------------------------------------------------------

write.csv(LogReturns, file = "GE_Returns.csv")

#NOTE:
# Have to change the column name in LogReturns Still to SPX Returns