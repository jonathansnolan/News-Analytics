#######################################################
# Jonathan Nolan
# Data Clean Up
# This code will read the original excel sheet provided by John Garvey
# Then it will filter through the unnecessary files
#######################################################

#------------------------------------------------------
# 1. Load the CSV file in to RStudio. 

Data <- read.csv("Final_Data.csv")




# 12. Seperate them more for futher examination
PR_LIWC <- Data$PR_LIWC_Tone
PR_DIC <- Data$PR_DIC_Tone
PR_H06 <- Data$PR_H06_Tone
PR_H08 <- Data$PR_H08_Tone
PR_LM <- Data$PR_LM_Tone
PR_AVG <- Data$PR_AVG_Tone


MA_LIWC <- Data$MA_LIWC_Tone
MA_DIC <- Data$MA_DIC_Tone
MA_H06 <- Data$MA_H06_Tone
MA_H08 <- Data$MA_H08_Tone
MA_LM <- Data$MA_LM_Tone
MA_AVG <- Data$MA_AVG_Tone

# 5. Now Begin Statistics

#------------------------------------------------------
# 1. PR_LIWC
mean(PR_LIWC)
sd(PR_LIWC)
median(PR_LIWC)
quantile(PR_LIWC)

#------------------------------------------------------
# 2. PR_DIC
mean(PR_DIC)
sd(PR_DIC)
median(PR_DIC)
quantile(PR_DIC)

#------------------------------------------------------
# 3. PR_H06
mean(PR_H06)
sd(PR_H06)
median(PR_H06)
quantile(PR_H06)

#------------------------------------------------------
# 4. PR_H08
mean(PR_H08)
sd(PR_H08)
median(PR_H08)
quantile(PR_H08)

#------------------------------------------------------
# 5. PR_LM
mean(PR_LM)
sd(PR_LM)
median(PR_LM)
quantile(PR_LM)

#------------------------------------------------------
# 6. PR_AVG
mean(PR_AVG)
sd(PR_AVG)
median(PR_AVG)
quantile(PR_AVG)

#------------------------------------------------------
# 7. PR_LIWC
mean(MA_LIWC)
sd(MA_LIWC)
median(MA_LIWC)
quantile(MA_LIWC)

#------------------------------------------------------
# 8. MA_DIC
mean(MA_DIC)
sd(MA_DIC)
median(MA_DIC)
quantile(MA_DIC)

#------------------------------------------------------
# 9. MA_H06
mean(MA_H06)
sd(MA_H06)
median(MA_H06)
quantile(MA_H06)

#------------------------------------------------------
# 10. MA_H08
mean(MA_H08)
sd(MA_H08)
median(MA_H08)
quantile(MA_H08)

#------------------------------------------------------
# 11. MA_LM
mean(MA_LM)
sd(MA_LM)
median(MA_LM)
quantile(MA_LM)

#------------------------------------------------------
# 12. MA_AVG
mean(MA_AVG)
sd(MA_AVG)
median(MA_AVG)
quantile(MA_AVG)


