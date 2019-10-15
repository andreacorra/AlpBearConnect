# Setting working space
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
rm(list=ls())
sessionInfo()

library(RPostgreSQL)
library(lubridate)
library(ggplot2)
library(gridExtra)
library(scales)
library(data.table)





## PostgreSQL connection
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
drv <- dbDriver("PostgreSQL") # Establish connection to PoststgreSQL using RPostgreSQL
con <- dbConnect(drv, dbname="bear_db",host="eurodeer2.fmach.it", port=5432, 
                 user="*****", password="*****")






# ACCELEROMETER data exploration
