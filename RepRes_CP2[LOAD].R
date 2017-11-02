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

install.packages("data.table")
library(data.table)

# Unzipping can not be handled by fread(), so we should find a solution for that.
# It turns out that fread() can process / implement terminal commands and work with
# the result...
# This works in terminal: $ bunzip2 -k StormData.csv.bz2
# ... and takes only a couple of seconds...
# Inside fread() we need to specify that the result of the unzip command has to
# be directed to standard output with the -c flag.
# So let's try this code:
StormData_fread <- fread('bunzip2 -ck StormData.csv.bz2')

# It seems like this provides equal results, apart from a minor difference:
all.equal(StormData, StormData_fread)
# "Datasets have different column modes. First 3: F(numeric!=character)"
# Column F is different indeed. Numeric vs character.
# After that was corrected another minor difference remained:
all.equal(StormData, StormData_fread)
# "Column 'BGN_LOCATI': 1 string mismatch"
# Not so easy to determine what is different, but I'm satisfied that fread()
# delivers the same dataset as read.csv().


# Also caching should be looked at, because this is going to be an issue when we start
# writing our R Markdown file.

# Reading .csv.bz2 file into R:
StormData <- read.csv("StormData.csv.bz2", stringsAsFactors = FALSE)

# Confirm the data was imported properly:
dim(StormData)
str(StormData)
head(StormData)
tail(StormData)
summary(StormData)
unique(StormData$EVTYPE)

# Preliminary observations?
#
# 1.
# The data seems to be messy. I've seen entries with leading whitespace and 
# capitals / lower case seem to have been used randomly...
#
# 2.
# There are 902.297 rows / observations in the data set.

# More information about the data in the file is available via a separate
# documents:

source_url_2 <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf"

download.file(source_url_2, destfile = "repdata-peer2_doc-pd01016005curr.pdf", 
              method = "curl")

source_url_3 <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf"

download.file(source_url_3, destfile = "repdata-peer2_doc-NCDC Storm Events-FAQ Page.pdf",
              method = "curl")

# The names of the files are unwieldy; we should consider renaming them...

file.rename("repdata-peer2_doc-pd01016005curr.pdf", "Storm Data Documentation.pdf")
file.rename("repdata-peer2_doc-NCDC Storm Events-FAQ Page.pdf", "Storm Events FAQs.pdf")
