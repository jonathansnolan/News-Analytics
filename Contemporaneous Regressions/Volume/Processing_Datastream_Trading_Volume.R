#######################################################
# Jonathan Nolan ######################################
# Data Clean Up First #################################
#######################################################
# OBJECTIVE:
# To calculate the detrended log volume

#setwd("")
#options(stringsAsFactors = FALSE)

#------------------------------------------------------
# Load the relevant Dataset
#------------------------------------------------------

#volume = read.csv2("Volume.csv")
volume = read.csv("GE.csv")
volume = volume[,c(1,6)]

#str(volume$Date)
#class(volume$Date)
#volume$date = as.Date(volume$date, format="%y-%m-%d")

#------------------------------------------------------
# Set M - The dimensions of dataset
#------------------------------------------------------

m = dim(volume)[2]


# Log Trading Volume ------------------------------------------------------
volume_log = as.data.frame(cbind(volume$date, log(volume[, 2:m])))




volume$stock = "GE"



t   = 1:dim(volume_log)[1]
t_2 = t^2

model = lm(volume_log ~ t + I(t_2))
sign = round(summary(model)$coefficients[, 4], 4)


#write.csv2(volume_log, "Log_Volume.csv", row.names = FALSE)

# Detrend Log Trading volume_log --------------------------------------------------
stock_names  = as.data.frame(names(volume)[3] )
#stock_names  = as.data.frame(names(volume_log)[-1] )

dates        = as.data.frame(volume[, 1])
names(dates) = "date"

###
stock_names$intercept = ""
stock_names$t         = ""
stock_names$t_2       = ""
###


for(n in 2:dim(volume_log)[1]){
volume_log_tmp  = volume_log[,c(1, n)]
volume_log_tmp  = na.omit(volume_log_tmp)
date        = volume_log_tmp$date
stock_name  = names(volume_log)[n]

t   = 1:dim(volume_log_tmp)[1]
t_2 = t^2

model = lm(volume_log_tmp[, 2] ~ t + t_2)
sign = round(summary(model)$coefficients[, 4], 4)


  stock_names$intercept[n-1] = sign[1]
  stock_names$t[n-1]         = sign[2]
  stock_names$t_2[n-1]       = sign[3]



volume_log_detrend_tmp           = as.data.frame(cbind(date, model$residuals))
names(volume_log_detrend_tmp)    = c("date", stock_name)


if(n == 2){
  volume_log_detrend = merge(x = dates, y = volume_log_detrend_tmp, by="date", all = TRUE)
}else{
  volume_log_detrend = merge(x = volume_log_detrend, y = volume_log_detrend_tmp, by="date", all = TRUE)
}
print(n)
}
#volume_log_detrend = as.data.frame(volume_log_detrend)



#volume_log_detrend[, 2:m] = lapply(volume_log_detrend[, 2:m], as.numeric)
#write.csv2(volume_log_detrend, "volume_log_detrend.csv",   row.names = FALSE)
#write.csv2(stock_names,    "volume_log_detrend_sign.csv", row.names = FALSE)