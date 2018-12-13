# Load the relevant packages
library(TSA)

# Load the relevant data
data(hours)
hours

# Plot the data
plot(hours, type='l', ylab='Month hours')
q <- season(hours)
points(y=hours, x = time(hours), pch=as.vector(q))

# time()
# this function creates the vector of times at which a time series was sampled.

# Load the relevant data
data(wages)
plot(wages, type='o', ylab='wages per hour')


#linear model
wages.lm = lm(wages~time(wages))
summary(wages.lm) #r square seems perfect

plot(y=rstandard(wages.lm), x=as.vector(time(wages)), type = 'o')


#Quadratic model trend
wages.qm = lm(wages ~ time(wages) + I(time(wages)^2))
summary(wages.qm)

#time series plot of the standardized residuals
plot(y=rstandard(wages.qm), x=as.vector(time(wages)), type = 'o')

