# Setting working space
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
rm(list=ls())
sessionInfo()

library(RPostgreSQL)
library(data.table)





## PostgreSQL connection
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
drv <- dbDriver("PostgreSQL") # Establish connection to PoststgreSQL using RPostgreSQL
con <- dbConnect(drv, dbname="bear_db",host="eurodeer2.fmach.it", port=5432, 
                 user="*****", password="*****")
saving_dir <- "/home/andreacorra/Desktop/"





# ACCELEROMETER data loading
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# code used derives from http://shinezhou9.github.io/RepData_PeerAssessment1/ 
actdata <- as.data.table(
  dbGetQuery(con,"SELECT * FROM main.activity_data_animals
                  WHERE activity_validity_code = 1 AND
                  activity_sensor_mode_code = 1;"))
actdata$unique_id <- paste(actdata$animals_id, actdata$activity_sensors_id, sep = "_")
dbDisconnect(con)

head(actdata)
str(actdata)






require(zoo)
require(zoocat)

actdata

act1 <- zoo(actdata$act_1)
act2 <- zoo(actdata$act_2)
rollcor(act1, act2, width = 9, show = FALSE, method = 'kendall')



