##########################################
# Jonathan Nolan
# NOTE:
# The purpose of this code is to calculate
# The median value of PR by year quarter
##########################################

#-----------------------------------------
# 1. Load your Dataset
Data <- read.csv("Data.csv")

#-----------------------------------------
# 2. Split up the data set by years initially

Data2000 <- Data[(which(Data$Year == "2000")),]
Data2001 <- Data[(which(Data$Year == "2001")),]
Data2002 <- Data[(which(Data$Year == "2002")),]
Data2003 <- Data[(which(Data$Year == "2003")),]
Data2004 <- Data[(which(Data$Year == "2004")),]
Data2005 <- Data[(which(Data$Year == "2005")),]
Data2006 <- Data[(which(Data$Year == "2006")),]
Data2007 <- Data[(which(Data$Year == "2007")),]
Data2008 <- Data[(which(Data$Year == "2008")),]
Data2009 <- Data[(which(Data$Year == "2009")),]
Data2010 <- Data[(which(Data$Year == "2010")),]
Data2011 <- Data[(which(Data$Year == "2011")),]
Data2012 <- Data[(which(Data$Year == "2012")),]

#-----------------------------------------
# 3. Split up and get all the Quarterly Values

#-------------------------------------------
#2000
Data2000_Q1 <- Data2000[(which(Data2000$Months == c("1","2","3"))),]
Data2000_Q2 <- Data2000[(which(Data2000$Months == c("4","5","6"))),]
Data2000_Q3 <- Data2000[(which(Data2000$Months == c("7","8","9"))),]
Data2000_Q4 <- Data2000[(which(Data2000$Months == c("10","11","12"))),]

Q1_2000 <- median(Data2000_Q1$PR_AVG_Tone)
Q2_2000 <- median(Data2000_Q2$PR_AVG_Tone)
Q3_2000 <- median(Data2000_Q3$PR_AVG_Tone)
Q4_2000 <- median(Data2000_Q4$PR_AVG_Tone)

#-------------------------------------------
#2001
Data2001_Q1 <- Data2001[(which(Data2001$Months == c("1","2","3"))),]
Data2001_Q2 <- Data2001[(which(Data2001$Months == c("4","5","6"))),]
Data2001_Q3 <- Data2001[(which(Data2001$Months == c("7","8","9"))),]
Data2001_Q4 <- Data2001[(which(Data2001$Months == c("10","11","12"))),]

Q1_2001 <- median(Data2001_Q1$PR_AVG_Tone)
Q2_2001 <- median(Data2001_Q2$PR_AVG_Tone)
Q3_2001 <- median(Data2001_Q3$PR_AVG_Tone)
Q4_2001 <- median(Data2001_Q4$PR_AVG_Tone)

#-------------------------------------------
#2002
Data2002_Q1 <- Data2002[(which(Data2002$Months == c("1","2","3"))),]
Data2002_Q2 <- Data2002[(which(Data2002$Months == c("4","5","6"))),]
Data2002_Q3 <- Data2002[(which(Data2002$Months == c("7","8","9"))),]
Data2002_Q4 <- Data2002[(which(Data2002$Months == c("10","11","12"))),]

Q1_2002 <- median(Data2002_Q1$PR_AVG_Tone)
Q2_2002 <- median(Data2002_Q2$PR_AVG_Tone)
Q3_2002 <- median(Data2002_Q3$PR_AVG_Tone)
Q4_2002 <- median(Data2002_Q4$PR_AVG_Tone)

#-------------------------------------------
#2003
Data2003_Q1 <- Data2003[(which(Data2003$Months == c("1","2","3"))),]
Data2003_Q2 <- Data2003[(which(Data2003$Months == c("4","5","6"))),]
Data2003_Q3 <- Data2003[(which(Data2003$Months == c("7","8","9"))),]
Data2003_Q4 <- Data2003[(which(Data2003$Months == c("10","11","12"))),]

Q1_2003 <- median(Data2003_Q1$PR_AVG_Tone)
Q2_2003 <- median(Data2003_Q2$PR_AVG_Tone)
Q3_2003 <- median(Data2003_Q3$PR_AVG_Tone)
Q4_2003 <- median(Data2003_Q4$PR_AVG_Tone)

#-------------------------------------------
#2004
Data2004_Q1 <- Data2004[(which(Data2004$Months == c("1","2","3"))),]
Data2004_Q2 <- Data2004[(which(Data2004$Months == c("4","5","6"))),]
Data2004_Q3 <- Data2004[(which(Data2004$Months == c("7","8","9"))),]
Data2004_Q4 <- Data2004[(which(Data2004$Months == c("10","11","12"))),]

Q1_2004 <- median(Data2004_Q1$PR_AVG_Tone)
Q2_2004 <- median(Data2004_Q2$PR_AVG_Tone)
Q3_2004 <- median(Data2004_Q3$PR_AVG_Tone)
Q4_2004 <- median(Data2004_Q4$PR_AVG_Tone)

#-------------------------------------------
#2005
Data2005_Q1 <- Data2005[(which(Data2005$Months == c("1","2","3"))),]
Data2005_Q2 <- Data2005[(which(Data2005$Months == c("4","5","6"))),]
Data2005_Q3 <- Data2005[(which(Data2005$Months == c("7","8","9"))),]
Data2005_Q4 <- Data2005[(which(Data2005$Months == c("10","11","12"))),]

Q1_2005 <- median(Data2005_Q1$PR_AVG_Tone)
Q2_2005 <- median(Data2005_Q2$PR_AVG_Tone)
Q3_2005 <- median(Data2005_Q3$PR_AVG_Tone)
Q4_2005 <- median(Data2005_Q4$PR_AVG_Tone)

#-------------------------------------------
#2006
Data2006_Q1 <- Data2006[(which(Data2006$Months == c("1","2","3"))),]
Data2006_Q2 <- Data2006[(which(Data2006$Months == c("4","5","6"))),]
Data2006_Q3 <- Data2006[(which(Data2006$Months == c("7","8","9"))),]
Data2006_Q4 <- Data2006[(which(Data2006$Months == c("10","11","12"))),]

Q1_2006 <- median(Data2006_Q1$PR_AVG_Tone)
Q2_2006 <- median(Data2006_Q2$PR_AVG_Tone)
Q3_2006 <- median(Data2006_Q3$PR_AVG_Tone)
Q4_2006 <- median(Data2006_Q4$PR_AVG_Tone)

#-------------------------------------------
#2007
Data2007_Q1 <- Data2007[(which(Data2007$Months == c("1","2","3"))),]
Data2007_Q2 <- Data2007[(which(Data2007$Months == c("4","5","6"))),]
Data2007_Q3 <- Data2007[(which(Data2007$Months == c("7","8","9"))),]
Data2007_Q4 <- Data2007[(which(Data2007$Months == c("10","11","12"))),]

Q1_2007 <- median(Data2007_Q1$PR_AVG_Tone)
Q2_2007 <- median(Data2007_Q2$PR_AVG_Tone)
Q3_2007 <- median(Data2007_Q3$PR_AVG_Tone)
Q4_2007 <- median(Data2007_Q4$PR_AVG_Tone)

#-------------------------------------------
#2008
Data2008_Q1 <- Data2008[(which(Data2008$Months == c("1","2","3"))),]
Data2008_Q2 <- Data2008[(which(Data2008$Months == c("4","5","6"))),]
Data2008_Q3 <- Data2008[(which(Data2008$Months == c("7","8","9"))),]
Data2008_Q4 <- Data2008[(which(Data2008$Months == c("10","11","12"))),]

Q1_2008 <- median(Data2008_Q1$PR_AVG_Tone)
Q2_2008 <- median(Data2008_Q2$PR_AVG_Tone)
Q3_2008 <- median(Data2008_Q3$PR_AVG_Tone)
Q4_2008 <- median(Data2008_Q4$PR_AVG_Tone)

#-------------------------------------------
#2009
Data2009_Q1 <- Data2009[(which(Data2009$Months == c("1","2","3"))),]
Data2009_Q2 <- Data2009[(which(Data2009$Months == c("4","5","6"))),]
Data2009_Q3 <- Data2009[(which(Data2009$Months == c("7","8","9"))),]
Data2009_Q4 <- Data2009[(which(Data2009$Months == c("10","11","12"))),]

Q1_2009 <- median(Data2009_Q1$PR_AVG_Tone)
Q2_2009 <- median(Data2009_Q2$PR_AVG_Tone)
Q3_2009 <- median(Data2009_Q3$PR_AVG_Tone)
Q4_2009 <- median(Data2009_Q4$PR_AVG_Tone)

#-------------------------------------------
#2010
Data2010_Q1 <- Data2010[(which(Data2010$Months == c("1","2","3"))),]
Data2010_Q2 <- Data2010[(which(Data2010$Months == c("4","5","6"))),]
Data2010_Q3 <- Data2010[(which(Data2010$Months == c("7","8","9"))),]
Data2010_Q4 <- Data2010[(which(Data2010$Months == c("10","11","12"))),]

Q1_2010 <- median(Data2010_Q1$PR_AVG_Tone)
Q2_2010 <- median(Data2010_Q2$PR_AVG_Tone)
Q3_2010 <- median(Data2010_Q3$PR_AVG_Tone)
Q4_2010 <- median(Data2010_Q4$PR_AVG_Tone)

#-------------------------------------------
#2011
Data2011_Q1 <- Data2011[(which(Data2011$Months == c("1","2","3"))),]
Data2011_Q2 <- Data2011[(which(Data2011$Months == c("4","5","6"))),]
Data2011_Q3 <- Data2011[(which(Data2011$Months == c("7","8","9"))),]
Data2011_Q4 <- Data2011[(which(Data2011$Months == c("10","11","12"))),]

Q1_2011 <- median(Data2011_Q1$PR_AVG_Tone)
Q2_2011 <- median(Data2011_Q2$PR_AVG_Tone)
Q3_2011 <- median(Data2011_Q3$PR_AVG_Tone)
Q4_2011 <- median(Data2011_Q4$PR_AVG_Tone)

#-------------------------------------------
#2012
Data2012_Q1 <- Data2012[(which(Data2012$Months == c("1","2","3"))),]
Data2012_Q2 <- Data2012[(which(Data2012$Months == c("4","5","6"))),]
Data2012_Q3 <- Data2012[(which(Data2012$Months == c("7","8","9"))),]
Data2012_Q4 <- Data2012[(which(Data2012$Months == c("10","11","12"))),]

Q1_2012 <- median(Data2012_Q1$PR_AVG_Tone)
Q2_2012 <- median(Data2012_Q2$PR_AVG_Tone)
Q3_2012 <- median(Data2012_Q3$PR_AVG_Tone)
Q4_2012 <- median(Data2012_Q4$PR_AVG_Tone)

###################################################################
#-------------------------------------------
# join them by year now

Qs_2000 <- as.data.frame(c(Q1_2000,Q2_2000,Q3_2000,Q4_2000))
Qs_2001 <- as.data.frame(c(Q1_2001,Q2_2001,Q3_2001,Q4_2001))
Qs_2002 <- as.data.frame(c(Q1_2002,Q2_2002,Q3_2002,Q4_2002))
Qs_2003 <- as.data.frame(c(Q1_2003,Q2_2003,Q3_2003,Q4_2003))
Qs_2004 <- as.data.frame(c(Q1_2004,Q2_2004,Q3_2004,Q4_2004))
Qs_2005 <- as.data.frame(c(Q1_2005,Q2_2005,Q3_2005,Q4_2005))
Qs_2006 <- as.data.frame(c(Q1_2006,Q2_2006,Q3_2006,Q4_2006))
Qs_2007 <- as.data.frame(c(Q1_2007,Q2_2007,Q3_2007,Q4_2007))
Qs_2008 <- as.data.frame(c(Q1_2008,Q2_2008,Q3_2008,Q4_2008))
Qs_2009 <- as.data.frame(c(Q1_2009,Q2_2009,Q3_2009,Q4_2009))
Qs_2010 <- as.data.frame(c(Q1_2010,Q2_2010,Q3_2010,Q4_2010))
Qs_2011 <- as.data.frame(c(Q1_2011,Q2_2011,Q3_2011,Q4_2011))
Qs_2012 <- as.data.frame(c(Q1_2012,Q2_2012,Q3_2012,Q4_2012))


#-------------------------------------------
# Rename the columns "Median
names(Qs_2000) <- "Median"
names(Qs_2001) <- "Median"
names(Qs_2002) <- "Median"
names(Qs_2003) <- "Median"
names(Qs_2004) <- "Median"
names(Qs_2005) <- "Median"
names(Qs_2006) <- "Median"
names(Qs_2007) <- "Median"
names(Qs_2008) <- "Median"
names(Qs_2009) <- "Median"
names(Qs_2010) <- "Median"
names(Qs_2011) <- "Median"
names(Qs_2012) <- "Median"


Total_Qs <- Reduce(function(x, y) merge(x, y, all=TRUE), list(Qs_2000, Qs_2001, Qs_2002, Qs_2003, Qs_2004, Qs_2005, Qs_2006, Qs_2007, Qs_2008, Qs_2009, Qs_2010, Qs_2011, Qs_2012))

write.csv(Total_Qs, file = "QuarterlyMedians.csv")