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
dbDisconnect(con)

head(actdata)
str(actdata)




