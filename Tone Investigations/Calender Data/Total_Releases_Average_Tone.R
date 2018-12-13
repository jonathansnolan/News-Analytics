#######################################################
# Jonathan Nolan
# Data Clean Up
# This code will read the original excel sheet provided by John Garvey
# Then it will filter through the unnecessary files
#######################################################

#------------------------------------------------------
# 1. Load the CSV file in to RStudio. 

Data <- read.csv("UK Sample_Final (August 2016).csv")

#------------------------------------------------------
# 2. Add a "Average Tone Column" and Calculate the average Tone of the 5

Data$AverageTone <- (Data$LIWC_Tone + Data$Diction_Tone + Data$Henry2008_Tone + Data$Henry2006_Tone + Data$LM_Tone)/5

#------------------------------------------------------
# 3. Trim this data to only inlcude the following
# Company Name
# Press Release Dummy
# Publication Date
Data <- Data[,c(3,7,23,36,39,42,45,48,49)]

#------------------------------------------------------
# 4. Rename Publication Date to Date
Data$Date <- Data$Publication.Date..PD.

Data <- Data[,c(1:2, 4:10)]
Data <- Data[,c(2,8,9)]


#------------------------------------------------------
# 5. Seperate in to Press Releases and Media Articles

PressRelease <- Data[(which(Data$Press.Release.Dummy == 1)),] #Press Release
MediaArticle <- Data[(which(Data$Press.Release.Dummy != 1)),] #Media Release

#------------------------------------------------------
# 5. We want to split the data up by days

library(data.table)
Data$Days <- weekdays(as.Date(Data$Date))
PressRelease$Days <- weekdays(as.Date(PressRelease$Date))
MediaArticle$Days <- weekdays(as.Date(MediaArticle$Date))

#------------------------------------------------------
# 6. We then want to split the data up by months

Data$Months <- month(as.Date(Data$Date))
PressRelease$Months <- month(as.Date(PressRelease$Date))
MediaArticle$Months <- month(as.Date(MediaArticle$Date))

#------------------------------------------------------
# 7. We then want to split the data up by years

year <- Data$Date
year <- data.frame((substring(year,1,4)))

# NOTE:
# We have to create year csv files and add them in manually to the data
write.csv(Data, file = "TR_YearToBeAdded.csv")
write.csv(year, file = "TotalReleasesYear.csv")

#------------------------------------------------------
# 8. Load the data set with the year now 

Data <- read.csv("TR_YearAdded.csv")


#------------------------------------------------------
# 8. Load the data set with the year now 

PressRelease <- Data[(which(Data$Press.Release.Dummy == 1)),] #Press Release
MediaArticle <- Data[(which(Data$Press.Release.Dummy != 1)),] #Media Release


#------------------------------------------------------
# 8. We can then find the average values per days of the week

Data_Day <- aggregate(Data[, c(3)], list(Data$Days), mean)
MA_Day <- aggregate(MediaArticle[, c(3)], list(MediaArticle$Days), mean)
PR_Day <- aggregate(PressRelease[, c(3)], list(PressRelease$Days), mean)

#------------------------------------------------------
# 9. We can then find the average values per months of the year

Data_Month <- aggregate(Data[, c(3)], list(Data$Months), mean)
MA_Month <- aggregate(MediaArticle[, c(3)], list(MediaArticle$Months), mean)
PR_Month <- aggregate(PressRelease[, c(3)], list(PressRelease$Months), mean)



#------------------------------------------------------
# 10. We can then find the average values per year

Data_Year <- aggregate(Data[, c(3)], list(Data$Year), mean)
MA_Year <- aggregate(MediaArticle[, c(3)], list(MediaArticle$Year), mean)
PR_Year <- aggregate(PressRelease[, c(3)], list(PressRelease$Year), mean)
