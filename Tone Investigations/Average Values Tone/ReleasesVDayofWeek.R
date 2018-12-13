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
Data$DayOfWeek <- weekdays(Data$Publication.Date..PD.)

# 4. this code counts how many mondays they are
countMonday <- length(which(Data$DayOfWeek == "Monday")) 
countTuesday <- length(which(Data$DayOfWeek == "Tuesday")) 
countWednesday <- length(which(Data$DayOfWeek == "Wednesday")) 
countThursday <- length(which(Data$DayOfWeek == "Thursday")) 
countFriday <- length(which(Data$DayOfWeek == "Friday")) 
countSaturday <- length(which(Data$DayOfWeek == "Saturday")) 
countSunday <- length(which(Data$DayOfWeek == "Sunday")) 

# 5. now to put the data in to dataset

Days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
Total_Releases <- c(countMonday,countTuesday,countWednesday,countThursday,countFriday,countSaturday, countSunday)
Number <- (1:7)
Graph <- data.frame(Days, Total_Releases,Number)

str(Graph)
#6. Plotly will be used to put this in to a bar chart
Graph$Days <- factor(Graph$Days, levels = Graph$Days)
#Visualization 5


# plotting a bar chart for comparing the total sales against the day of the week
ggplot(Graph, aes(y = Graph$Total_Releases, x = Graph$Days)) +
  geom_bar(stat = "identity", fill = "tomato", color = "black") + 
  labs(y="Total Sources", x = "Day of the week", main = "Number of days open by Day of Week")

