# Exploring Data-Driven Strategies for Health and Wellness: A case study of Bellabeat

I created this project as a case study to showcase my abilities in data analysis and visualization. It was developed after completing the Google Data Analytics specialization.

## Description

- We want to analyze smart device usage data in order to gain insight into how consumers
use smart devices.
- It’s believed that analyzing smart device fitness data could help unlock new growth opportunities.
- It’s required to gain insights into how consumers are using their smart devices,
these insights then along with high-level recommendations help in guiding the next
marketing strategy/campaign


## About the company (Bellabeat)

- Bellabeat is a high-tech company that manufactures health-focused products
for women.
- Bellabeat collects data on activity, sleep, stress, and reproductive health to empower women with knowledge about their own health and habits.
- Urška Sršen (Founder) believes that analyzing smart device usage data can lead to the company's growth.

## About the Dataset(FitBit Fitness Tracker Data)

- This [dataset]((https://www.kaggle.com/datasets/arashnic/fitbit)) was generated through a survey conducted on Amazon Mechanical Turk between December 3-5, 2016.
- The survey was completed by 30 eligible Fitbit users who consented to the submission of their personal tracker data.
- The data includes minute-level output for physical activity, heart rate, and sleep monitoring.
- The data can be parsed by using the export session ID (column A) or timestamp (column B).
- The variations in the data output may be due to the use of different types of Fitbit trackers and individual tracking behaviors and preferences.

### Dependencies

* This project is based on the R programming language.
* To run this project, the following packages are required:
1. tidyverse
2. lubridate
3. ggplot2
4. ggthemes

```r
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("ggthemes")

library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggthemes)
```

### Reproduce Analysis and Visualization

- Download the data on your local machine from [here](https://www.kaggle.com/datasets/arashnic/fitbit)

- Add data location instead of this line of code 
```r
setwd("C:/Users/youss/OneDrive/Desktop/case study #2/Raw Data/Fitabase Data 4.12.16-5.12.16")

```

## Results
- A full report detailing the results and high-level insights from the project can be found in the root directory of the project.
- The report is titled "report" and can be accessed from the root directory.
- The report provides a comprehensive overview of the project and its key findings.
- It is intended to give readers a detailed understanding of the project and its results.
- If you are interested in learning more about the project, we recommend reviewing the report in the root directory

## Version History

* 0.1
    * Initial Release