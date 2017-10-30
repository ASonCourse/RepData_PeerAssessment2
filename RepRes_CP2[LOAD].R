# This file / script describes the steps involved in loading the StormData into R. The
# code is minimally commented, since the .Rmd file contains a thorough description.

# First, let's fix the date we run this script / download the data:
Download_Date <- Sys.Date()

# Next let's download the data from the internet:
source_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

download.file(source_url, destfile = "StormData.csv.bz2", 
              method = "curl")

# # Unzipping of downloaded file ("StormData.csv.bz2") is not necessary! It can be
# read in directly with read.csv(). Maybe we should use read_csv() instead, because
# the file is quite large and we might want to experiment a bit first with just a
# couple of lines / observations before we import the whole file...

# May be we should also consider a faster option because it takes minutes to get the
# data into R with read.csv(). fread()?

# Also caching should be looked at, because this is going to be an issue when we start
# writing our R Markdown file.

# Reading .csv.bz2 file into R:
StormData <- read.csv("StormData.csv.bz2", stringsAsFactors = FALSE)

# Confirm the data was imported properly:
dim(StormData)


# How many NA's?


