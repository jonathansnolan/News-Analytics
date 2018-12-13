#######################################################
# Jonathan Nolan ######################################
# Data Clean Up First #################################
#######################################################
# OBJECTIVE:

# This will create the data set for a monthly line graph of all the different word lists tones
# and compare each other

# NOTE
# This is similar to figure 2 in Elizabeth Bommes Thesis
##################################################################################
library(data.table)
# This will First be to see how many Total releases are done per each day

# 1. Load the CSV file in to RStudio. 

Data <- read.csv("UK Sample_Final (August 2016).csv")

# 2. Add a "Average Tone Column" and Calculate the average Tone of the 5
Data$AverageTone <- (Data$LIWC_Tone + Data$Diction_Tone + Data$Henry2008_Tone + Data$Henry2006_Tone + Data$LM_Tone)/5

# 3. Seperate in to positive tone
# This accounts for all the average tones that are above 0.5

Positive_Data <- Data[(which(Data$AverageTone >= "0.5")),]


# 4. This cuts down the data to only show the tones and the date
Data <- Positive_Data[,c(23,36,39,42,45,48, 49)]

# 5. this transforms the date into months of the year
Data$Publication.Date..PD. <- as.Date(Data$Publication.Date..PD.)
Data$months <- months(Data$Publication.Date..PD.)

# 6. This shows the years
Data$years <- format(as.Date(Data$Publication.Date..PD., format="%d/%m/%Y"),"%Y")

#7. next step is to get the average tone for each month 

#Note - seperate the years first
#write.csv(Data, file = "TEST.csv")


Data2000 <- Data[(which(Data$years == "2000")),]
Data2001 <- Data[(which(Data$years == "2001")),]
Data2002 <- Data[(which(Data$years == "2002")),]
Data2003 <- Data[(which(Data$years == "2003")),]
Data2004 <- Data[(which(Data$years == "2004")),]
Data2005 <- Data[(which(Data$years == "2005")),]
Data2006 <- Data[(which(Data$years == "2006")),]
Data2007 <- Data[(which(Data$years == "2007")),]
Data2008 <- Data[(which(Data$years == "2008")),]
Data2009 <- Data[(which(Data$years == "2009")),]
Data2010 <- Data[(which(Data$years == "2010")),]
Data2011 <- Data[(which(Data$years == "2011")),]
Data2012 <- Data[(which(Data$years == "2012")),]
Data2013 <- Data[(which(Data$years == "2013")),]
Data2014 <- Data[(which(Data$years == "2014")),]

# 8. Get the mean for the average tones for each data set

AvgPos2000  <- setDT(Data2000)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(AverageTone = mean(AverageTone)), by = c(names(Data2014)[c(8:9)])]

# 9. Merge the data sets should be merged to give the 4 relevant columns now

PanelAvgTone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))


# 10. Get the mean for the LM Tone  for each data set

AvgPos2000  <- setDT(Data2000)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(LM_Tone = mean(LM_Tone)), by = c(names(Data2014)[c(8:9)])]


# 11. Merge the data sets should be merged to give the 4 relevant columns now

PanelLMTone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))

# 12. Get the mean for the Henry 2006 Tone for each data set
AvgPos2000  <- setDT(Data2000)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(Henry2006_Tone = mean(Henry2006_Tone)), by = c(names(Data2014)[c(8:9)])]

# 13. Merge the data sets should be merged to give the 4 relevant columns now


PanelHenry2006Tone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))



# 14. Get the mean for the Henry 2006 Tone for each data set
AvgPos2000  <- setDT(Data2000)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(Henry2008_Tone = mean(Henry2008_Tone)), by = c(names(Data2014)[c(8:9)])]

# 15. Merge the data sets should be merged to give the 4 relevant columns now


PanelHenry2008Tone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))


# 16. Get the mean for the Henry 2006 Tone for each data set
AvgPos2000  <- setDT(Data2000)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(Diction_Tone = mean(Diction_Tone)), by = c(names(Data2014)[c(8:9)])]

# 17. Merge the data sets should be merged to give the 4 relevant columns now


PanelDictionTone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))


# 18. Get the mean for the Henry 2006 Tone for each data set
AvgPos2000  <- setDT(Data2000)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2000)[c(8:9)])]
AvgPos2001  <- setDT(Data2001)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2001)[c(8:9)])]
AvgPos2002  <- setDT(Data2002)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2002)[c(8:9)])]
AvgPos2003  <- setDT(Data2003)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2003)[c(8:9)])]
AvgPos2004  <- setDT(Data2004)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2004)[c(8:9)])]
AvgPos2005  <- setDT(Data2005)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2005)[c(8:9)])]
AvgPos2006  <- setDT(Data2006)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2006)[c(8:9)])]
AvgPos2007  <- setDT(Data2007)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2007)[c(8:9)])]
AvgPos2008  <- setDT(Data2008)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2008)[c(8:9)])]
AvgPos2009  <- setDT(Data2009)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2009)[c(8:9)])]
AvgPos2010  <- setDT(Data2010)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2010)[c(8:9)])]
AvgPos2011  <- setDT(Data2011)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2011)[c(8:9)])]
AvgPos2012  <- setDT(Data2012)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2012)[c(8:9)])]
AvgPos2013  <- setDT(Data2013)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2013)[c(8:9)])]
AvgPos2014  <- setDT(Data2014)[, list(LIWC_Tone = mean(LIWC_Tone)), by = c(names(Data2014)[c(8:9)])]

# 19. Merge the data sets should be merged to give the 4 relevant columns now


PanelLIWCTone <- Reduce(function(x, y) merge(x, y, all=TRUE), list(AvgPos2000, AvgPos2001, AvgPos2002, AvgPos2003, AvgPos2004, AvgPos2005, AvgPos2006, AvgPos2007, AvgPos2008, AvgPos2009, AvgPos2010, AvgPos2011, AvgPos2012, AvgPos2013, AvgPos2014))


# 20. Combine all data sets now

TotalPanel <- Reduce(function(x, y) merge(x, y, all=TRUE), list(PanelAvgTone,PanelDictionTone, PanelHenry2006Tone, PanelHenry2008Tone, PanelLIWCTone, PanelLMTone))

write.csv(TotalPanel, file = "TotalPanel.csv")