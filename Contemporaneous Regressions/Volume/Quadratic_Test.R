#######################################################
# Jonathan Nolan ######################################
# Data Clean Up First #################################
#######################################################
# OBJECTIVE:
# To calculate the detrended log volume

#setwd("")
#options(stringsAsFactors = FALSE)
library(tidyr)
library(dplyr)

#------------------------------------------------------
# Load the relevant Dataset
#------------------------------------------------------

volume = read.csv("GE.csv")

#------------------------------------------------------
# Cut Date set to show just Volume and Date
#------------------------------------------------------

volume = volume[,c(1,7)]

#------------------------------------------------------
# Create Dates Dataset, where missing dates will be 
# filled in
#------------------------------------------------------

Dates <- volume$date
Dates <- as.Date(Dates)
volume$date <- Dates

#------------------------------------------------------
# Complete Dates Dataset
#------------------------------------------------------

#NOTE: 
# CODE MIGHT NOT BE NEEDED BUT STILL HANDY TO KEEP

#Com_Dates = data.frame(date= seq(min(volume$date), max(volume$date), by=1))
#complete <- merge (Com_Dates, volume, by.x = "date", all.x = T)

#######################################################
# ROUTE 1 #############################################
#######################################################

#NOTE:
# THIS WILL USE A QUADRATICE TIME TREND FUNCTION
# WITH DATA FROM AVERAGED PER MONTH

#------------------------------------------------------
# Add columns that display the year and month to data
#------------------------------------------------------

volume$months <- months(volume$date)
volume$years  <- format(as.Date(volume$date, format="%d/%m/%Y"),"%Y")

#------------------------------------------------------
# Seperate the data by year
#------------------------------------------------------

Data2000 <- volume[(which(volume$years == "2000")),]
Data2001 <- volume[(which(volume$years == "2001")),]
Data2002 <- volume[(which(volume$years == "2002")),]
Data2003 <- volume[(which(volume$years == "2003")),]
Data2004 <- volume[(which(volume$years == "2004")),]
Data2005 <- volume[(which(volume$years == "2005")),]
Data2006 <- volume[(which(volume$years == "2006")),]
Data2007 <- volume[(which(volume$years == "2007")),]
Data2008 <- volume[(which(volume$years == "2008")),]
Data2009 <- volume[(which(volume$years == "2009")),]
Data2010 <- volume[(which(volume$years == "2010")),]
Data2011 <- volume[(which(volume$years == "2011")),]
Data2012 <- volume[(which(volume$years == "2012")),]

#------------------------------------------------------
# Get the mean for the average tones for each data set
#------------------------------------------------------

library(data.table)
Avg2000  <- setDT(Data2000)[, list(AverageVolume = mean(Volume)), by = c(names(Data2000)[c(3:4)])]
Avg2001  <- setDT(Data2001)[, list(AverageVolume = mean(Volume)), by = c(names(Data2001)[c(3:4)])]
Avg2002  <- setDT(Data2002)[, list(AverageVolume = mean(Volume)), by = c(names(Data2002)[c(3:4)])]
Avg2003  <- setDT(Data2003)[, list(AverageVolume = mean(Volume)), by = c(names(Data2003)[c(3:4)])]
Avg2004  <- setDT(Data2004)[, list(AverageVolume = mean(Volume)), by = c(names(Data2004)[c(3:4)])]
Avg2005  <- setDT(Data2005)[, list(AverageVolume = mean(Volume)), by = c(names(Data2005)[c(3:4)])]
Avg2006  <- setDT(Data2006)[, list(AverageVolume = mean(Volume)), by = c(names(Data2006)[c(3:4)])]
Avg2007  <- setDT(Data2007)[, list(AverageVolume = mean(Volume)), by = c(names(Data2007)[c(3:4)])]
Avg2008  <- setDT(Data2008)[, list(AverageVolume = mean(Volume)), by = c(names(Data2008)[c(3:4)])]
Avg2009  <- setDT(Data2009)[, list(AverageVolume = mean(Volume)), by = c(names(Data2009)[c(3:4)])]
Avg2010  <- setDT(Data2010)[, list(AverageVolume = mean(Volume)), by = c(names(Data2010)[c(3:4)])]
Avg2011  <- setDT(Data2011)[, list(AverageVolume = mean(Volume)), by = c(names(Data2011)[c(3:4)])]
Avg2012  <- setDT(Data2012)[, list(AverageVolume = mean(Volume)), by = c(names(Data2012)[c(3:4)])]



PanelAvgVolume <- Reduce(function(x, y) merge(x, y, all=TRUE), list(Avg2000, Avg2001, Avg2002, Avg2003, Avg2004, Avg2005, Avg2006, Avg2007, Avg2008, Avg2009, Avg2010, Avg2011, Avg2012))




#------------------------------------------------------
# Create Log Volume Dataset
#------------------------------------------------------

Log_volume <- log(PanelAvgVolume[,3])

#------------------------------------------------------
# Transform Log Volume Dataset into a time series
#------------------------------------------------------

Log_volume <-ts(Log_volume, start = c(2000), frequency = 12)


#------------------------------------------------------
# Create the quadratic Model
#------------------------------------------------------

#t   = 1:dim(Dates)
#t_2 = t^2


model = lm(Log_volume ~ time(Log_volume) + time(Log_volume)^2)
summary(model)

#------------------------------------------------------
# Create the residuals dataset
#------------------------------------------------------

residuals <- model$residuals



plot(y=rstandard(model), x=as.vector(time(Log_volume)), type = 'o')

Vol_detren <- as.data.frame(Dates)
Vol_detren$Residuals <- residuals


#print(Vol_detren)

#######################################################
# ROUTE 2 #############################################
#######################################################

#NOTE:
# THIS WILL USE A QUADRATICE TIME TREND FUNCTION
# WITH DATA as Normal - not averaged



Log_volume <- log(volume[,2])
plot(Log_volume, type='o', ylab='wages per hour')

#------------------------------------------------------
# Transform Log Volume Dataset into a time series
#------------------------------------------------------

Log_volume <-ts(Log_volume, frequency = 252, start = 2000)


#t   = 1:dim(Dates)
#t_2 = t^2


model = lm(Log_volume ~ time(Log_volume) + time(Log_volume)^2)
summary(model)

plot(y=rstandard(model), x=as.vector(time(Log_volume)), type = 'o')

residuals <- model$residuals

Final <- data.frame(volume$date)
Final$residuals <- residuals
Final$LogVol <- log(volume[,2])
write.csv(Final, file = "DetrendedVol.csv")
