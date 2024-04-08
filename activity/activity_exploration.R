# Setting working space
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
rm(list=ls())
sessionInfo()

library(RPostgreSQL)
library(lubridate)
library(ggplot2)
library(gridExtra)
library(scales)
library(data.table)
library(dplyr)
library(hms)




## PostgreSQL connection
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
drv <- dbDriver("PostgreSQL") # Establish connection to PoststgreSQL 
con <- dbConnect(drv, dbname="bear_db",host="eurodeer2.fmach.it", port=5432, 
                 user="*****", password="****")





# ACCELEROMETER data loading
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# code used derives from http://shinezhou9.github.io/RepData_PeerAssessment1/ 
actdata <- as.data.table(
  dbGetQuery(con,"SELECT * FROM main.activity_data_animals
                  WHERE activity_validity_code = 1 AND
                  activity_sensor_mode_code = 1;"))
dbDisconnect(con)

head(actdata)
str(actdata)






# Data Processing // Daily activity pattern 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

## Set interval at which accelerometer data were recorded 
actdata <-
  actdata %>%
  rowwise() %>% 
  mutate(act_mean = mean(c(act_1, act_2))) %>%
  select(animals_code, acquisition_time, act_mean) %>%
  mutate(interval = format(acquisition_time, '%H:%M')) %>%
  arrange(interval) %>%
  mutate(interval = as.factor(interval))


## Calculate mean and median total activity per time interval
t_pattern <- split(actdata, actdata$interval) 
average_act <- sapply(t_pattern, function(x) mean(x$act_mean, na.rm = TRUE))
median_act <- sapply(t_pattern, function(x) median(x$act_mean, na.rm = TRUE))


## Set timeserie for later plotting (date is meaningless)
start <- strptime("1990-07-21 00:00:00 UTC", "%Y-%m-%d %H:%M:%S")
end <- strptime("1990-07-21 23:55:00 UTC", "%Y-%m-%d %H:%M:%S")
time_series <-
  seq.POSIXt(as.POSIXct(start), as.POSIXct(end), units = "seconds", by = 300)


## Average activity
avg_daily_act <- data.frame(time = time_series, ave_steps = average_act)
p1 <-
  ggplot(avg_daily_act, aes(x = time, y = ave_steps)) +
  geom_line(colour = "firebrick3", linewidth = .7) +
  labs(x = "hour", y = "Activity", title = "Average Daily Activity Pattern") +
  theme_minimal() +
  scale_x_datetime(breaks = '2 hours', date_labels = '%T')


## Median activity
med_daily_act <- data.frame(time = time_series, ave_steps = median_act)
p2 <-
  ggplot(med_daily_act, aes(x = time, y = ave_steps)) +
  geom_line(colour = "dodgerblue3", linewidth = .7) +
  labs(x = "hour", y = "Activity", title = "Median Daily Activity Pattern") +
  theme_minimal() +
  scale_x_datetime(breaks = '2 hours', date_labels = '%T')


grid_1 <- grid.arrange(p1, p2, nrow = 2)
ggsave("daily_act_bear.png", path = "C:/Users/corradinia/Documents", 
       grid_1, width = 30, height = 25, units = "cm")

