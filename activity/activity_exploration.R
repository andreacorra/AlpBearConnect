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
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# code used derives from http://shinezhou9.github.io/RepData_PeerAssessment1/ 
actdata <- as.data.table(
  dbGetQuery(con,"SELECT * FROM main.activity_data_animals
                  WHERE activity_validity_code = 1 AND
                  activity_sensor_mode_code = 1;")) 
head(actdata)
str(actdata)


# Data Processing // Daily activity pattern 
## Set interval at which accelerometer data were recorded 
# rounded_time <- round_date(actdata$acquisition_time, unit = "5 minutes")
actdata$interval <- as.factor(format(actdata$acquisition_time, '%H:%M'))


## Calculate mean and median total activity per time interval
t_pattern <- split(actdata, actdata$interval) 
average_act <- sapply(t_pattern, function(x) mean(x$act_1, na.rm = TRUE))
median_act <- sapply(t_pattern, function(x) median(x$act_1, na.rm = TRUE))


## Set timeserie for later plotting (date is meaningless)
start <- strptime("1990-07-21 00:00:00 UTC", "%Y-%m-%d %H:%M:%S")
end <- strptime("1990-07-21 23:55:00 UTC", "%Y-%m-%d %H:%M:%S")
time_series <-
  seq.POSIXt(as.POSIXct(start), as.POSIXct(end), units = "seconds", by = 300)


## Average activity 
avg_daily_act <- data.frame(time = time_series, ave_steps = average_act)
avg_p_day <- ggplot(avg_daily_act, aes(x = time, y = ave_steps))
p1 <-
  avg_p_day +
  geom_line(colour = "firebrick3", size = .7) +
  labs(x = "hour", y = "Activity", title = "Average Daily Activity Pattern") +
  scale_x_datetime(labels = date_format("%H:%M"), minor_breaks = NULL)


## Median activity
med_daily_act <- data.frame(time = time_series, ave_steps = median_act)
med_p_day <- ggplot(med_daily_act, aes(x = time, y = ave_steps))
p2 <-
  med_p_day +
  geom_line(colour = "dodgerblue3", size = .7) +
  labs(x = "hour", y = "Activity", title = "Median Daily Activity Pattern") +
  scale_x_datetime(labels = date_format("%H:%M"), minor_breaks = NULL)


## Arranging plots together
grid_1 <- grid.arrange(p1, p2, nrow = 2)
ggsave("daily_act_bear.png", path = "/home/andreacorra/Desktop/", grid_1,
       width = 35, height = 20, units = "cm")




# Data Processing // weekly activity pattern
## Set interval at which accelerometer data were recorded 
actdata$interval_w <- week(actdata$acquisition_time)


## Calculate mean and median total activity per time interval
t_pattern_w <- split(actdata, actdata$interval_w) 
average_act_w <- sapply(t_pattern_w, function(x) mean(x$act_1, na.rm = TRUE))
median_act_w <- sapply(t_pattern_w, function(x) median(x$act_1, na.rm = TRUE))


## Average activity 
avg_weekly_act <- data.frame(time = c(1:53), ave_steps = average_act_w)
avg_p_week <- ggplot(avg_weekly_act, aes(x = time, y = ave_steps))
p3 <-
  avg_p_week +
  geom_line(colour = "darkorchid3", size = .7) +
  labs(x = "week", y = "Activity", title = "Average Weekly Activity Pattern") +
  geom_text(x=2, y=55, label="Winter", size = 7) +  
  geom_vline(xintercept = 9, linetype="dashed") +
  geom_text(x=12, y=55, label="Spring", size = 7) +
  geom_vline(xintercept = 22, linetype="dashed") +
  geom_text(x=32, y=55, label="Summer", size = 7) +
  geom_vline(xintercept = 35, linetype="dashed") +
  geom_text(x=38, y=55, label="Fall", size = 7) +
  geom_vline(xintercept = 48, linetype="dashed") +
  geom_text(x=51, y=55, label="Winter", size = 7)


## Median activity
med_weekly_act <- data.frame(time = c(1:53), ave_steps = median_act_w)
med_p_week <- ggplot(med_weekly_act, aes(x = time, y = ave_steps))
p4 <-
  med_p_week +
  geom_line(colour = "darkslategray4", size = .7) +
  labs(x = "week", y = "Activity", title = "Median Weekly Activity Pattern") +
  geom_text(x=2, y=61, label="Winter", size = 7) +  
  geom_vline(xintercept = 9, linetype="dashed") +
  geom_text(x=12, y=61, label="Spring", size = 7) +
  geom_vline(xintercept = 22, linetype="dashed") +
  geom_text(x=25, y=61, label="Summer", size = 7) +
  geom_vline(xintercept = 35, linetype="dashed") +
  geom_text(x=38, y=61, label="Fall", size = 7) +
  geom_vline(xintercept = 48, linetype="dashed") +
  geom_text(x=51, y=61, label="Winter", size = 7)


## Arranging plots together
grid_2 <- grid.arrange(p3, p4, nrow = 2)
ggsave("weekly_act_bear.png", path = "/home/andreacorra/Desktop/", grid_2,
       width = 35, height = 20, units = "cm")




# Data Processing // Weekly activity pattern 
## Set interval at which accelerometer data were recorded 
actdata$interval_y <- yday(actdata$acquisition_time)


## Calculate mean and median total activity per time interval
t_pattern_y <- split(actdata, actdata$interval_y) 
average_act_y <- sapply(t_pattern_y, function(x) mean(x$act_1, na.rm = TRUE))
median_act_y <- sapply(t_pattern_y, function(x) median(x$act_1, na.rm = TRUE))


## Average activity 
avg_yearly_act <- data.frame(time = c(1:365), ave_steps = average_act_y)
avg_p_year <- ggplot(avg_yearly_act, aes(x = time, y = ave_steps))

yy <- 81
lt <- "dashed"

p5 <-
  avg_p_year +
  geom_line(colour = "darkorchid3", size = .7) +
  labs(x= "day of the year", y= "Activity", title= "Average Yearly Activity Pattern") +
  geom_text(x=15,  y=yy, label="Jan", size=7)+ geom_vline(xintercept=31,  linetype=lt) +
  geom_text(x=44,  y=yy, label="Feb", size=7)+ geom_vline(xintercept=60,  linetype=lt) +
  geom_text(x=75,  y=yy, label="Mar", size=7)+ geom_vline(xintercept=91,  linetype=lt) +
  geom_text(x=105, y=yy, label="Apr", size=7)+ geom_vline(xintercept=121, linetype=lt) +
  geom_text(x=136, y=yy, label="May", size=7)+ geom_vline(xintercept=152, linetype=lt) +
  geom_text(x=166, y=yy, label="Jun", size=7)+ geom_vline(xintercept=182, linetype=lt) +
  geom_text(x=197, y=yy, label="Jul", size=7)+ geom_vline(xintercept=213, linetype=lt) +
  geom_text(x=228, y=yy, label="Aug", size=7)+ geom_vline(xintercept=244, linetype=lt) +
  geom_text(x=258, y=yy, label="Sep", size=7)+ geom_vline(xintercept=274, linetype=lt) +
  geom_text(x=289, y=yy, label="Oct", size=7)+ geom_vline(xintercept=305, linetype=lt) +
  geom_text(x=319, y=yy, label="Nov", size=7)+ geom_vline(xintercept=335, linetype=lt) +
  geom_text(x=350, y=yy, label="Dec", size=7)+ geom_vline(xintercept=365, linetype=lt)


## Median activity
med_yearly_act <- data.frame(time = c(1:365), ave_steps = median_act_y)
med_p_year <- ggplot(med_yearly_act, aes(x = time, y = ave_steps))

yz <- 90

p6 <-
  med_p_year +
  geom_line(colour = "darkslategray4", size = .7) +
  labs(x = "day of the year", y = "Activity", title = "Median Yearly Activity Pattern") +
  geom_text(x=15,  y=yz, label="Jan", size=7)+ geom_vline(xintercept=31,  linetype=lt) +
  geom_text(x=44,  y=yz, label="Feb", size=7)+ geom_vline(xintercept=60,  linetype=lt) +
  geom_text(x=75,  y=yz, label="Mar", size=7)+ geom_vline(xintercept=91,  linetype=lt) +
  geom_text(x=105, y=yz, label="Apr", size=7)+ geom_vline(xintercept=121, linetype=lt) +
  geom_text(x=136, y=yz, label="May", size=7)+ geom_vline(xintercept=152, linetype=lt) +
  geom_text(x=166, y=yz, label="Jun", size=7)+ geom_vline(xintercept=182, linetype=lt) +
  geom_text(x=197, y=yz, label="Jul", size=7)+ geom_vline(xintercept=213, linetype=lt) +
  geom_text(x=228, y=yz, label="Aug", size=7)+ geom_vline(xintercept=244, linetype=lt) +
  geom_text(x=258, y=yz, label="Sep", size=7)+ geom_vline(xintercept=274, linetype=lt) +
  geom_text(x=289, y=yz, label="Oct", size=7)+ geom_vline(xintercept=305, linetype=lt) +
  geom_text(x=319, y=yz, label="Nov", size=7)+ geom_vline(xintercept=335, linetype=lt) +
  geom_text(x=350, y=yz, label="Dec", size=7)+ geom_vline(xintercept=365, linetype=lt)


## Arranging plots together
grid_3 <- grid.arrange(p5, p6, nrow = 2)
ggsave("yearly_act_bear.png", path = "/home/andreacorra/Desktop/", grid_3,
       width = 35, height = 20, units = "cm")
