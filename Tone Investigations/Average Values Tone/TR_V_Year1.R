#######################################################
# Jonathan Nolan
# Data Clean Up First
#######################################################
library(ggplot2)

# This will First be to see how many Total releases are done per each day

# 1. Load the CSV file in to RStudio. 

Data <- read.csv("UK Sample_Final (August 2016).csv")

# 2. Add a "Average Tone Column" and Calculate the average Tone of the 5
Data$AverageTone <- (Data$LIWC_Tone + Data$Diction_Tone + Data$Henry2008_Tone + Data$Henry2006_Tone + Data$LM_Tone)/5

# 3. This cuts down the data and transforms the date into days of the week
Data <- Data[,c(23,49)]
Data$Publication.Date..PD. <- as.Date(Data$Publication.Date..PD.)

#Data$DayOfWeek <- weekdays(Data$Publication.Date..PD.)
#Data$months <- months(Data$Publication.Date..PD.)
year <- Data$Publication.Date..PD.
year <- data.frame((substring(year,1,4)))
Data$years <- year


# 4. this code counts how many months they are
count2000<- length(which(Data$years == "2000"))
count2001<- length(which(Data$years == "2001"))
count2002<- length(which(Data$years == "2002"))
count2003<- length(which(Data$years == "2003"))
count2004<- length(which(Data$years == "2004"))
count2005<- length(which(Data$years == "2005"))
count2006<- length(which(Data$years == "2006"))
count2007<- length(which(Data$years == "2007"))
count2008<- length(which(Data$years == "2008"))
count2009<- length(which(Data$years == "2009"))
count2010<- length(which(Data$years == "2010"))
count2011<- length(which(Data$years == "2011"))
count2012<- length(which(Data$years == "2012"))


count2013<- length(which(Data$years == "2013"))
count2014<- length(which(Data$years == "2014"))
# 5. now to put the data in to dataset

#months <- c("January","February","March","April","May","June","July","August","September","October","November","December")
years <- c(2000:2012)

Total_Releases <- c(count2000,count2001,count2002,count2003,count2004,count2005,count2006,count2007,count2008,count2009,count2010,count2011,count2012)

Number <- (1:13)
Graph <- data.frame(years, Total_Releases,Number)

str(Graph)
#6. Plotly will be used to put this in to a bar chart
Graph$years <- factor(Graph$years, levels = Graph$years)
#Visualization 5


# plotting a bar chart for comparing the total sales against the day of the week
ggplot(Graph, aes(y = Graph$Total_Releases, x = Graph$years)) +
  geom_bar(stat = "identity", fill = "tomato", color = "black") + 
  labs(y="Total Sources", x = "Years", main = "Number of days open by Day of Week")

X <- data.frame(Total_Releases)

