############################################################
# Jonathan Nolan ###########################################
############################################################
# The purpose of this code is to understand how to merge  ##
# two data sets by the data and to fill in missing values ##
# if there is any in the data set.                        ##
############################################################


#-----------------------------------------------------------
# 1. Create your data set
PostData <-structure(list(IndID = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 
                                              3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 5L, 
                                              5L, 5L), .Label = c("P01", "P02", "P03", "P05", "P06", "P07", 
                                                                  "P08", "P09", "P10", "P11", "P12", "P13"), class = "factor"), 
                          Date = structure(c(1299196800, 1299801600, 1299974400, 1300060800, 
                                             1300147200, 1300320000, 1300406400, 1310083200, 1310169600, 
                                             1310515200, 1310774400, 1310947200, 1311033600, 1311292800, 
                                             1311552000, 1323129600, 1323388800, 1323648000, 1323993600, 
                                             1324080000, 1324166400, 1324339200, 1327622400, 1327795200, 
                                             1327881600), class = c("POSIXct", "POSIXt"), tzone = "GMT"), 
                          Event = c(1L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 
                                    0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L), Number = c(2L, 
                                                                                                    2L, 9L, 10L, 1L, 7L, 5L, 9L, 1L, 4L, 5L, 2L, 0L, 1L, 10L, 
                                                                                                    5L, 0L, 6L, 5L, 10L, 9L, 4L, 4L, 8L, 1L), Percent = c(0.39, 
                                                                                                                                                          0.975, 0.795, 0.516, 0.117, 0.093, 0.528, 0.659, 0.308, 0.055, 
                                                                                                                                                          0.185, 0.761, 0.132, 0.676, 0.368, 0.383, 0.272, 0.113, 0.974, 
                                                                                                                                                          0.696, 0.941, 0.751, 0.758, 0.29, 0.15)), .Names = c("IndID", 
                                                                                                                                                                                                               "Date", "Event", "Number", "Percent"), row.names = c(NA, 25L), 
                     class = "data.frame")



#-----------------------------------------------------------
# 1. Create your data set

New_Data <- do.call(rbind,
        by(
          PostData,
          PostData$IndID,
          function(x) {
            out <- merge(
              data.frame(
                IndID=x$IndID[1],
                Date=seq.POSIXt(min(x$Date),max(x$Date),by="1 day")
              ),
              x,
              all.x=TRUE
            )
            out$Event[is.na(out$Event)] <- 0
            out
          }  
        )
)
