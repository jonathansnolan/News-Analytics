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


#------------------------------------------------------
# 5. We want to split the data up by weeks
#library(data.table)
#PressRelease$Weeks <- week(as.Date(PressRelease$Date))
#
#Panel$years  <- format(as.Date(Panel$Date, format="%d/%m/%Y"),"%Y")

#------------------------------------------------------
# 6. Will need to create MA and PR as want to sort out the "TYPE"
# Filter the data to Determine if Press Release or a Media Release

PressRelease <- Data[(which(Data$Press.Release.Dummy == 1)),] #Press Release
MediaArticle <- Data[(which(Data$Press.Release.Dummy != 1)),] #Media Release

#------------------------------------------------------
#######################################################
# 7. NOTE: 
# We need to rename the tones to seperate them from MA and PR
#######################################################

#------------------------------------------------------
# Average Tone
PressRelease$PR_AVG_Tone <- PressRelease$AverageTone 
MediaArticle$MA_AVG_Tone <- MediaArticle$AverageTone 

#------------------------------------------------------
# LM
PressRelease$PR_LM_Tone <- PressRelease$LM_Tone
MediaArticle$MA_LM_Tone <- MediaArticle$LM_Tone 

#------------------------------------------------------
# LIWC

PressRelease$PR_LIWC_Tone <- PressRelease$LIWC_Tone
MediaArticle$MA_LIWC_Tone <- MediaArticle$LIWC_Tone

#------------------------------------------------------
# Diction
PressRelease$PR_DIC_Tone <- PressRelease$Diction_Tone
MediaArticle$MA_DIC_Tone <- MediaArticle$Diction_Tone 
#------------------------------------------------------
# Henry 06
PressRelease$PR_H06_Tone <- PressRelease$Henry2006_Tone
MediaArticle$MA_H06_Tone <- MediaArticle$Henry2006_Tone

#------------------------------------------------------
# Henry 08
PressRelease$PR_H08_Tone <- PressRelease$Henry2008_Tone
MediaArticle$MA_H08_Tone <- MediaArticle$Henry2008_Tone 


#------------------------------------------------------
# 8. We now need to trim this data up to make it presentable

PressRelease <- PressRelease[,c(1, 9:15)]
MediaArticle <- MediaArticle[,c(1, 9:15)]

#------------------------------------------------------
# 9. As there can be more than one release per day,
# we need to take the average tone.
# Further more we also need the company.

PR_AVG <- aggregate(PressRelease[, c(3:8)], list(PressRelease$Company.Name, PressRelease$Date), mean)
MA_AVG <- aggregate(MediaArticle[, c(3:8)], list(MediaArticle$Company.Name, MediaArticle$Date), mean)


#------------------------------------------------------
# 10. First we need to clean up these new data frames
# to ensure they have the correct names

PR_AVG$Company.Name <- PR_AVG$Group.1
PR_AVG$Date <- PR_AVG$Group.2
PR_AVG <- PR_AVG[,c(3:10)]

MA_AVG$Company.Name <- MA_AVG$Group.1
MA_AVG$Date <- MA_AVG$Group.2
MA_AVG <- MA_AVG[,c(3:10)]

#------------------------------------------------------
# 11. Merging the data sets

Final_Data <- merge(PR_AVG,MA_AVG, by = c('Company.Name','Date'))

write.csv(Final_Data, file = "Final_Data.csv")


# 12. Seperate them more for futher examination
PR_LIWC <- Final_Data$PR_LIWC_Tone
PR_DIC <- Final_Data$PR_DIC_Tone
PR_H06 <- Final_Data$PR_H06_Tone
PR_H08 <- Final_Data$PR_H08_Tone
PR_LM <- Final_Data$PR_LM_Tone
PR_AVG <- Final_Data$PR_AVG_Tone


MA_LIWC <- Final_Data$MA_LIWC_Tone
MA_DIC <- Final_Data$MA_DIC_Tone
MA_H06 <- Final_Data$MA_H06_Tone
MA_H08 <- Final_Data$MA_H08_Tone
MA_LM <- Final_Data$MA_LM_Tone
MA_AVG <- Final_Data$MA_AVG_Tone

# 5. Now Begin the Pearson Correlations

#########################
# 1. 12
cor.test(PR_LIWC, PR_LIWC)
cor.test(PR_LIWC, PR_DIC)
cor.test(PR_LIWC, PR_H06)
cor.test(PR_LIWC, PR_H08)
cor.test(PR_LIWC, PR_LM)
cor.test(PR_LIWC, PR_AVG)
cor.test(PR_LIWC, MA_LIWC)
cor.test(PR_LIWC, MA_DIC)
cor.test(PR_LIWC, MA_H06)
cor.test(PR_LIWC, MA_H08)
cor.test(PR_LIWC, MA_LM)
cor.test(PR_LIWC, MA_AVG)

# 2. 11
cor.test(PR_DIC, PR_DIC)
cor.test(PR_DIC, PR_H06)
cor.test(PR_DIC, PR_H08)
cor.test(PR_DIC, PR_LM)
cor.test(PR_DIC, PR_AVG)
cor.test(PR_DIC, MA_LIWC)
cor.test(PR_DIC, MA_DIC)
cor.test(PR_DIC, MA_H06)
cor.test(PR_DIC, MA_H08)
cor.test(PR_DIC, MA_LM)
cor.test(PR_DIC, MA_AVG)

# 3. 10
cor.test(PR_H06, PR_H06)
cor.test(PR_H06, PR_H08)
cor.test(PR_H06, PR_LM)
cor.test(PR_H06, PR_AVG)
cor.test(PR_H06, MA_LIWC)
cor.test(PR_H06, MA_DIC)
cor.test(PR_H06, MA_H06)
cor.test(PR_H06, MA_H08)
cor.test(PR_H06, MA_LM)
cor.test(PR_H06, MA_AVG)

#4. 9
cor.test(PR_H08, PR_H08)
cor.test(PR_H08, PR_LM)
cor.test(PR_H08, PR_AVG)
cor.test(PR_H08, MA_LIWC)
cor.test(PR_H08, MA_DIC)
cor.test(PR_H08, MA_H06)
cor.test(PR_H08, MA_H08)
cor.test(PR_H08, MA_LM)
cor.test(PR_H08, MA_AVG)

#5. 8
cor.test(PR_LM, PR_LM)
cor.test(PR_LM, PR_AVG)
cor.test(PR_LM, MA_LIWC)
cor.test(PR_LM, MA_DIC)
cor.test(PR_LM, MA_H06)
cor.test(PR_LM, MA_H08)
cor.test(PR_LM, MA_LM)
cor.test(PR_LM, MA_AVG)

#6. 7
cor.test(PR_AVG, PR_AVG)
cor.test(PR_AVG, MA_LIWC)
cor.test(PR_AVG, MA_DIC)
cor.test(PR_AVG, MA_H06)
cor.test(PR_AVG, MA_H08)
cor.test(PR_AVG, MA_LM)
cor.test(PR_AVG, MA_AVG)


#7. 6
cor.test(MA_LIWC, MA_LIWC)
cor.test(MA_LIWC, MA_DIC)
cor.test(MA_LIWC, MA_H06)
cor.test(MA_LIWC, MA_H08)
cor.test(MA_LIWC, MA_LM)
cor.test(MA_LIWC, MA_AVG)


#8. 5
cor.test(MA_DIC, MA_DIC)
cor.test(MA_DIC, MA_H06)
cor.test(MA_DIC, MA_H08)
cor.test(MA_DIC, MA_LM)
cor.test(MA_DIC, MA_AVG)


#9. 4
cor.test(MA_H06, MA_H06)
cor.test(MA_H06, MA_H08)
cor.test(MA_H06, MA_LM)
cor.test(MA_H06, MA_AVG)

#10. 3
cor.test(MA_H08, MA_H08)
cor.test(MA_H08, MA_LM)
cor.test(MA_H08, MA_AVG)

#11. 2
cor.test(MA_LM, MA_LM)
cor.test(MA_LM, MA_AVG)

#12. 1
cor.test(MA_AVG, MA_AVG)

