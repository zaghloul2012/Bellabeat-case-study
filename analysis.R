#setting the work environment
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggthemes)


setwd("C:/Users/youss/OneDrive/Desktop/case study #2/Raw Data/Fitabase Data 4.12.16-5.12.16")


# import first file of data to check it (daily_activity_merged)
daily_activity <- read_csv("dailyActivity_merged.csv")

# check top rows of data to get familiarized with it
head(daily_activity)

# check structure of data and how it's organized
str(daily_activity)

# check number of users participated in this dataset
length(unique(daily_activity$Id))

# check number of days
length(unique(daily_activity$ActivityDate))

# catchy observation here is "ActivityDate" column is formatted as charters not date \
# so we will convert it to time to deal with it easily in analysis
daily_activity <- daily_activity %>%
  mutate (ActivityDate = as.Date(daily_activity_merged$ActivityDate, format = "%m/%d/%Y"))

invalid_steps <- daily_activity %>%
  filter( TotalSteps <= 0) %>%
  summarise( n() )
invalid_steps
# There are 77 observations where total steps/day are zero or less which may be impossible 
# the reason for that may be the person forget to wear the device so we will discard these observation for avoiding bias
daily_activity <- daily_activity %>%
  filter( TotalSteps > 0)

# quick summary
summary(daily_activity)
# for the first while, no data seems to be invalid or so on, so let's keep with another data file


# get summary data for each user along this period
user_ativity_monthly_summary <- daily_activity %>%
  group_by(Id) %>%
  summarise(
    monthly_steps = sum(TotalSteps),
    mean_daily_steps = mean(TotalSteps),

    monthly_distance_km = sum(TotalDistance),
    mean_daily_distance_km = mean(TotalDistance),

    monthly_active_minutes = sum(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes),
    mean_daily_active_minutes_per = 100*(monthly_active_minutes / 31)/(24*60),
    
    monthly_sedentary_minutes = sum(SedentaryMinutes),
    mean_monthly_sedentary_minutes_per = 100*mean(SedentaryMinutes) / (24*60),

    
    monthly_calories = sum(Calories),
    mean_daily_calories = mean(Calories),

  )

head(user_ativity_monthly_summary)

ggplot(user_ativity_monthly_summary,
       aes(mean_daily_calories)) +
  geom_histogram(binwidth = 200, fill = "darkblue") + 
  theme_stata() +
  ggtitle("Distribution of mean daily calories burned") + 
  xlab("Calories per day")
# Daily activity differs from person to another with single peak at 2000 calories and few exceptional persons at 3500 calories (3)
# and only one person around 1500 calories
# we can conclude from these data that most people are healthy but we can add feature that send notifications for users on weekly basis 
# if there mean_daily_calories is less than 1600 for women and 2000 for men
# according to Dietary Guidelines for Americans (https://www.dietaryguidelines.gov/sites/default/files/2020-12/Dietary_Guidelines_for_Americans_2020-2025.pdf)


ggplot(user_ativity_monthly_summary,
       aes(monthly_steps,monthly_calories)) + 
  geom_point(fill = "darkblue") +
  geom_smooth(method = "lm") + 
  theme_stata() +
  ggtitle("Correleation between total steps and calories burned") +
  xlab("Total Monthly Steps") + 
  ylab("Total Monthly Calories")
cor(user_ativity_monthly_summary$monthly_steps,user_ativity_monthly_summary$monthly_calories)
# seems to be there is a correlation between monthly_steps and monthly_calories with r = 0.727
# so Bellbeat application may push some notifications motivate person to walk/run when needed
# as this seems to be effective


ggplot(user_ativity_monthly_summary,
       aes(mean_daily_distance_km)) +
  geom_histogram(binwidth = 2, fill = "darkblue") + 
  theme_stata() +
  ggtitle("Distribution of mean daily distance for person in KM") +
  xlab("Mean Daily Distance per KM") 


ggplot(user_ativity_monthly_summary,
       aes(mean_daily_steps)) +
  geom_histogram(binwidth = 1000, fill = "darkblue") + 
  theme_stata() +
  ggtitle("Distribution of mean daily steps for person")
# Around fifty percentage of data set walk/run less than 8 km/day which isn't recommended at all
# Centers for Disease Control and Prevention (CDC) CDC recommend that most adults aim for 10,000 steps per day
# For most people, this is the equivalent of about 8 kilometers
# https://www.medicalnewstoday.com/articles/how-many-steps-should-you-take-a-day#:~:text=Walking%20is%20a%20form%20of,8%20kilometers%2C%20or%205%20miles.





# import second file of data to check it (heartrate_seconds)
heartrate_5_sec <- read_csv("heartrate_seconds_merged.csv")

# check top rows of data to get familiarized with it
head(heartrate_5_sec)

# check structure of data and how it's organized
str(heartrate_5_sec)

# the same observation here which is "Time" column is formatted as charters not date-time so let's convert it
heartrate_5_sec <- heartrate_5_sec %>%
  mutate(Time = as.POSIXct(Time, format = "%m/%d/%Y %I:%M:%S %p"))

# check number of users participated in this dataset
length(unique(heartrate_5_sec$Id))
# There are only 14 person attached in this data set which may be small number but let's see what insights we can get from 

# Note that heart rate is observed each five seconds so we will create some columns help us in analysis
heartrate_5_sec <- heartrate_5_sec %>%
  mutate(
    day = wday(Time, label = TRUE),
    hour = hour(Time),
    minute = minute(Time)
  )
head(heartrate_5_sec)

# quick summary
summary(heartrate_5_sec)

hourly_heartrate_distribution <- heartrate_5_sec %>%
  group_by(Id, hour) %>%
  summarise(hourly_mean_heartrate = mean(Value)) %>%
  group_by(hour) %>%
  summarise(mean_heartrate_hourly = mean(hourly_mean_heartrate))
hourly_heartrate_distribution
ggplot(hourly_heartrate_distribution, aes(x=as.factor(hour),y=mean_heartrate_hourly)) + 
  geom_col(fill = "darkblue") + 
  theme_stata() +
  ggtitle("Distribution of mean heartrate over the day") + 
  xlab("Hour") + 
  ylab("Mean Heart rate")
# you can notice that heart rate starts to drops between 11 P.M and 6 A.M
# This can be used to indicate that person is sleeping right now to help calculating the accuracy of sleep hour times
# Also this can be used to add Don't disturb feature to stop pushing notification when sleeping
# Another feature is if person want to sleep specif hours each day this can be used to make automatic alarm starting from the moment he slept

#Also we can notice that heart rate distribution over the day has single peak between 5 P.M to 7 P.M 
# which may be many people are doing some workout or being at the gym this time
# so we can push some motivational notifications or reminders to help them keep fit




# import third set of data where calories/intensity/steps measured every hour
# we will combine them to easily deal with them
hourly_calories <- read_csv("hourlyCalories_merged.csv")
str(hourly_calories)

hourly_intensities <- read_csv("hourlyIntensities_merged.csv")
str(hourly_intensities)

hourly_steps <- read_csv("hourlySteps_merged.csv")
str(hourly_steps)

hourly_summary <- merge(hourly_calories, hourly_intensities)
hourly_summary <- merge(hourly_summary, hourly_steps)

# check top rows of data to get familiarized with it
head(hourly_summary)

str(hourly_summary)

summary(hourly_summary)
#Note these data is the same as of daily activity data so we will remove the same invalid data 
hourly_summary <- hourly_summary %>%
  filter(StepTotal > 0)


# check structure of data and how it's organized
# the same observation here which is "ActivityHour" column is formatted as charters not date-time so let's convert it
hourly_summary <- hourly_summary %>%
  mutate(ActivityHour = as.POSIXct(ActivityHour, format = "%m/%d/%Y %I:%M:%S %p"))
View(hourly_summary)

# Note that calories/intensity/steps is measured every hour so we will create some columns help us in analysis
hourly_summary <- hourly_summary %>%
  mutate(
    month = month(ActivityHour, label = TRUE),
    day = wday(ActivityHour, label = TRUE),
    hour = hour(ActivityHour)
  )
head(hourly_summary)

# quick summary
summary(hourly_summary)

user_steps_hourly <- hourly_summary %>%
  group_by(Id) 
ggplot(user_steps_hourly, aes(x=as.factor(hour), y=StepTotal, fill=TotalIntensity)) +
  geom_col() +
  facet_wrap(~Id) +
  theme_stata() +
  ggtitle("Total steps of user/hour") + 
  xlab("Hours of Day") +
  ylab("Total steps per day")
# Distribution of total steps/hour differs from person to another this can help build customized plan for each person based on his daily life





# import fifth set of data which contains sleep summary
sleep_data <- read_csv("sleepDay_merged.csv")


# check top rows of data to get familiarized with it
head(sleep_data)

# check structure of data and how it's organized
str(sleep_data)

# the same observation here which is "SleepDay" column is formatted as charters not date-time so let's convert it
sleep_data <- sleep_data %>%
  mutate(SleepDay = as.POSIXct(SleepDay, format = "%m/%d/%Y %I:%M:%S %p"))
str(sleep_data)

# we will create some columns help us in analysis
sleep_data <- sleep_data %>%
  mutate(
    minutes_before_sleep = TotalTimeInBed - TotalMinutesAsleep,
    month = month(SleepDay, label = TRUE),
    day = wday(SleepDay, label = TRUE)
  )
head(sleep_data)

# quick summary
summary(sleep_data)

sleep_summary <- sleep_data %>%
  group_by(day) %>% 
  summarise(
    mean_time_before_sleep_min = mean(minutes_before_sleep),
    mean_time_bed_min = mean(TotalTimeInBed),
    mean_time_asleep_min = mean(TotalMinutesAsleep)
  )

sleep_summary
ggplot(sleep_summary, aes(x=as.factor(day), y=mean_time_before_sleep_min)) + 
  geom_col(fill = "darkblue") +
  theme_stata() +
  ggtitle("Mean time before sleep") +
  xlab("Day of week") +
  ylab('Time before sleep (min)')
# Graph shows single peak over days in Sunday which can be explained due to
#being exposed to blue light in the evening can trick our brain into thinking it's still daytime, 
#disrupting circadian rhythms and leaving us feeling alert instead of tired
# Being exposed to blue light in the evening can trick our brain into thinking it's still daytime, disrupting circadian rhythms and leaving us feeling alert instead of tired
# Source: https://www.sleepfoundation.org/bedroom-environment/blue-light#:~:text=Being%20exposed%20to%20blue%20light,to%20many%20negative%20health%20impacts
# This can help Bellbeat send notifications to alert user from exposing to blue light in evening specially on Sunday


ggplot(sleep_summary, aes(x=as.factor(day), y=mean_time_bed_min )) + 
  geom_col(fill = "darkblue") +
  theme_stata() +
  ggtitle("Mean time in bed") + 
  xlab("Day of week") +
  ylab("Mean time in bed")
# Appearntly the long time before sleep affect the total time in bed without going to sleep

ggplot(sleep_summary, aes(x=as.factor(day), y=mean_time_asleep_min )) + 
  geom_col(fill = "darkblue") +
  theme_stata() +
  ggtitle("Mean time Asleep") +
  xlab("Day of week") + 
  ylab("Mean time Asleep")


# import last set of data which contains weight summary
weight_info <- read_csv("weightLogInfo_merged.csv")

# check top rows of data to get familiarized with it
length(unique(weight_info$Id))

# check structure of data and how it's organized
str(weightLogInfo_merged)

# these data are too small to get insights from and even not organzied or complete date so we will not use them in our analysis








