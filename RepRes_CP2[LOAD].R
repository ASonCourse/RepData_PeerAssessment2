# This file / script describes the steps involved in loading the StormData into R. The
# code is minimally commented, since the .Rmd file contains a thorough description.

# First, let's fix the date we run this script / download the data:
Download_Date <- Sys.Date()

# Next let's download the data from the internet:
source_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

download.file(source_url, destfile = "StormData.csv.bz2", 
              method = "curl")

# Unzip downloaded file (unzipped file -> "StormData.csv"):
unzip("StormData.csv.bz2", exdir = ".")

# Reading .csv file into R:
StormData <- read.csv("StormData.csv", stringsAsFactors = FALSE)

# Confirm the data was imported properly:
dim(StormData)


# How many NA's?


