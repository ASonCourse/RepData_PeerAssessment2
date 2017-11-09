# This file contains code that was used in the data analyses:

# What kind of event caused the most fatalities?
StormData[which.max(StormData$FATALITIES), c("EVTYPE", "FATALITIES")]
# Looks like it was a heatwave...

# What kind of event caused the most injuries?
StormData[which.max(StormData$INJURIES), c("EVTYPE", "INJURIES")]
# Looks like it was tornado...

# List of EVTYPEs (group_by), summarised and ordered by injuries / fatalities:
SD_by_impact_on_PopHealth_FatInjs <- StormData %>%
    group_by(EVTYPE) %>%
    select(EVTYPE, FATALITIES, INJURIES) %>%
    arrange(desc(FATALITIES), desc(INJURIES))

#             EVTYPE FATALITIES INJURIES
#             <chr>      <dbl>    <dbl>
# 1           HEAT        583        0
# 2        TORNADO        158     1150
# 3        TORNADO        116      785
# 4        TORNADO        114      597
# 5 EXCESSIVE HEAT         99        0
# 6        TORNADO         90     1228
  
SD_by_impact_on_PopHealth_InjFats <- StormData %>%
  group_by(EVTYPE) %>%
  select(EVTYPE, FATALITIES, INJURIES) %>%
  arrange(desc(INJURIES), desc(FATALITIES))

#         EVTYPE FATALITIES INJURIES
#         <chr>      <dbl>    <dbl>
# 1   TORNADO         42     1700
# 2 ICE STORM          1     1568
# 3   TORNADO         90     1228
# 4   TORNADO        158     1150
# 5   TORNADO         36     1150
# 6   TORNADO         44      800

# Looks like tornado's are most harmful to the population health...
# Although heatwaves seem to have caused most fatalities per event.

# Grouping and sumarizing:
SD_by_group_totals <- StormData %>%
  group_by(EVTYPE) %>%
  summarise(fat_total = sum(FATALITIES), inj_total = sum(INJURIES))

# Correlation between fatalities (totalled per EVTYPE) and injuries (totalled
# per EVTYPE)?

###########################################
## THIS PRODUCES THE MOST TELLING PLOT -->>
###########################################
plot(x = SD_by_group_totals$fat_total, y = SD_by_group_totals$inj_total)
# There does not seem to be a strong correlation, if anything fatalities and
# injuries are only lightly correlated.

# What stands out, however is the fact that (taken as a group) TORNADO's
# have resulted in most fatalities aswell as caused most injuries:
SD_by_group_totals[SD_by_group_totals$EVTYPE == "TORNADO",]

  #   EVTYPE      fat_total   inj_total
  #   <chr>       <dbl>       <dbl>
  # 1 TORNADO     5633       91346

# What if we look at averages per event?
SD_by_group_means <- StormData %>%
  group_by(EVTYPE) %>%
  summarise(fat_mean = mean(FATALITIES), inj_mean = mean(INJURIES))

# Correlation?
plot(x = SD_by_group_means$fat_mean, y = SD_by_group_means$inj_mean)
# This produces a fan-like picture, so it's hard to say that there is any
# correlation between the average number of fatalities and the average
# number of injuries for events in general. Some seem to result in more
# deaths, some in more injuries (relatively).

# What are the events with extreme disproportionate ratios injuries /
# fatalities?
SD_by_group_means[which.max(SD_by_group_means$fat_mean), ]
# TORNADOES, TSTM WIND, HAIL
SD_by_group_means[which.max(SD_by_group_means$inj_mean), ]
# Heat Wave


# Perhaps we should also look at the frequency of certain EVTYPEs
# occuring...
SD_by_group_cnt <- StormData %>%
  group_by(EVTYPE) %>%
  summarise(N = n()) %>%
  arrange(desc(N))

# TORNADO's have occured more than 60.000 times, TSTM WIND, almost 220.000
# times and HAIL nearly 290.000 times (most frequent). So no wonder that these
# EVTYPEs have had the biggest impact on population health.

# The "Heat Wave" event causing the most injuries on average occurred only
# once (N = 1)...
SD_by_group_cnt[which(SD_by_group_cnt$EVTYPE == "Heat Wave"),]

# More generally "HEAT" events only occurred 767 times:
SD_by_group_cnt[which(SD_by_group_cnt$EVTYPE == "HEAT"),]

# So not only do heat-related events result in more injuries than fatalities
# on average, but they also happen way less often than TORNADO's etc.
# Tornado's cause more fatalities on average and are much more common, so
# policy should primarily be focussed on coping with TORNADO's and the like:
plot(SD_by_group_cnt$N, type = "l")
# There is a huge drop-off in the number of occurences per type of event.
# This is also the case when we look at the percentage of the total number of
# events registered in the dataset:
plot(SD_by_group_cnt$N/nrow(StormData), type = "l")
# Calculating the share of total events for the first few events topping the
# list shows this clearly aswell:
sum(SD_by_group_cnt$N[1])
sum(SD_by_group_cnt$N[1:3])
sum(SD_by_group_cnt$N[1:5])
sum(SD_by_group_cnt$N[1:10])
# in percentages:
sum(SD_by_group_cnt$N[1])/nrow(StormData)
sum(SD_by_group_cnt$N[1:3])/nrow(StormData)
sum(SD_by_group_cnt$N[1:5])/nrow(StormData)
sum(SD_by_group_cnt$N[1:10])/nrow(StormData)

# So the top 5 events by occurrence represent almost 80% of all events;
# the top 10 coves almost 90%. Heat Wave / HEAT make up a tiny percentage
# of events (0.000851161, less than 1/10th of a percent, actually).

# WHICH EVENTS HAVE GREATEST ECONOMIC CONSEQUENCES?

# Let's look at the amount of property / crop damage. The monetary value of the
# damage consists of a number plus an exponent. This exponent should be a "K",
# "M" or a "B" -- times $ 1.000, times $ 1.000.000, or times $ 1.000.000.000...
unique(StormData$PROPDMGEXP)
unique(StormData$CROPDMGEXP)
# Produces lists that are considerably longer. What is the impact of the entries
# that are not conform to spec? How many are there?
Proper_PROPDMGEXP <- StormData[StormData$PROPDMGEXP %in% c("K", "M", "B"), ]
unique(Proper_PROPDMGEXP$PROPDMGEXP)
# "K" "M" "B"
nrow(Proper_PROPDMGEXP)
# 436035
nrow(Proper_PROPDMGEXP) / nrow(StormData)
# 0.48325
# So more than half of the data entries are not up to spec...
# This introduces a HUGE problem, because of missing / potentially erroneus data.
# We should assume the amounts entered are correct if the exponent is up to spec,
# but data entry errors could have massive impact aswell -- damage could be off
# by a factor 1.000 or even 1.000.000 times more / less if the wrong exponent
# was used...

Proper_CROPDMGEXP <- StormData[StormData$CROPDMGEXP %in% c("K", "M", "B"), ]
unique(Proper_CROPDMGEXP$CROPDMGEXP)
# "M" "K" "B"
nrow(Proper_CROPDMGEXP)
# 283835
nrow(Proper_CROPDMGEXP) / nrow(StormData)
# 0.3145694
# The proportion of improperly entered data for the exponent of the crop damage
# value is even larger...
# So there is a potentially HUGE problem here, aswell.
# Should we exclude the data that was not entered properly?


# HOW ABOUT THE QUALITY OF DATA ENTERED AS EVTYPE?
length(unique(StormData$EVTYPE))
# 985... That's way more than one would expect!
unique(StormData$EVTYPE)
# This produces a list with most values in CAPITALS. Presumably this is the
# way data should have been entered, lower case letters indicate erroneus
# data (potentially / likely). Can we get a grip on the proportion of
# problematic entries for EVTYPE?
# The Storm Data Event Table lists only about 50 events that can be entered,
# so there's an enormous difference. The events in the list are printed in
# lowercase (but Capitalized), so maybe these cover identical events
# entered in all caps?
# How many EVTYPEs containing one or more lower case letters are there?
EVTYPE_List <- unique(StormData$EVTYPE)
EVTYPE_List_lowercase <- grep("[a-z]+", EVTYPE_List, value = T)
length(EVTYPE_List_lowercase)
# 193 EVTYPES with one or more lower case letters...
# Only capitals?
# Use the invert = TRUE flag in the grep() function!
EVTYPE_List_UPPERCASE <- grep("[a-z]+", EVTYPE_List, value = T, invert = T)
length(EVTYPE_List_UPPERCASE)
# 792
# That's still way more than the 50 types one would expect...

# SOLUTION?
# There seems to be a lot of dirty data -- the difference between 50
# types of events and almost 1.000 is ridiculous. We have to filter out
# the allowed entries, so it's best to get the list from the Storm Data
# Event Table and filter out the matching entries...
# Bring in the text-editor!
# Copied the information from the PDF-file to BBEdit and created the
# list of possible events.
Allowed_EVTYPEs <- c("Astronomical Low Tide",
                     "Avalanche",
                     "Blizzard", "Coastal Flood", "Cold/Wind Chill",
                     "Debris Flow", "Dense Fog", "Dense Smoke",
                     "Drought", "Dust Devil", "Dust Storm",
                     "Excessive Heat", "Extreme Cold/Wind Chill",
                     "Flash Flood", "Flood",
                     "Frost/Freeze", "Funnel Cloud", "Freezing Fog",
                     "Hail", "Heat", "Heavy Rain", "Heavy Snow",
                     "High Surf", "High Wind", "Hurricane (Typhoon)",
                     "Ice Storm", "Lake-Effect Snow", "Lakeshore Flood",
                     "Lightning", "Marine Hail", "Marine High Wind",
                     "Marine Strong Wind", "Marine Thunderstorm Wind",
                     "Rip Current", "Seiche", "Sleet", "Storm Surge/Tide",
                     "Strong Wind", "Thunderstorm Wind", "Tornado",
                     "Tropical Depression", "Tropical Storm", "Tsunami",
                     "Volcanic Ash", "Waterspout", "Wildfire", "Winter Storm",
                     "Winter Weather")

# For reproducibility here's the description of what I did to get the list
# of allowed events:
# Found " Z ", " C ", and " M " in copied text. Replaced that with \n to get a
# list. Removed " Z" from the last values (copied two lists seperately). 
# Corrected apparent typo in "V olcanic Ash" (removed space between V and
# olcanic). Wrapped each line in "". Added a comma plus one space to the end of
# each line except the last one. Removed all \n from the list; copied the line
# of text to R.

length(Allowed_EVTYPEs)
# 48
# So there should only be 48 event types. Or 96 if we ignore the case in which
# the entries are set.

# Changed Allowed_EVTYPEs to data.frame, while adding a second column with the
# allowed EVTYPE's in capitals. Let's filter StormData, so that it only contains
# EVTYPE's that are present in either of the two colums:
SD_Allowed_EVTYPEs <- StormData %>%
  filter(EVTYPE %in% Allowed_EVTYPEs$LowerCase | EVTYPE %in% Allowed_EVTYPEs$UpperCase)

# This reduces the dataset substantially:
nrow(StormData)
# 902297
nrow(SD_Allowed_EVTYPEs)
# 635348
nrow(SD_Allowed_EVTYPEs) / nrow(StormData)
# 0.7041451
# So, about 30% of the data was not entered correctly...
length(unique(SD_Allowed_EVTYPEs$EVTYPE))
# There are only 59 unique values for EVTYPE in the dataset now,
# so not all event types allowed appear in both lower and upper case.
# Looking at the values, we see mostly all upper case entries.
length(grep("[a-z]+", unique(SD_Allowed_EVTYPEs$EVTYPE), value = T))
# There are exactly 13 entries with one or more lower case letters.
length(grep("[a-z]+", unique(SD_Allowed_EVTYPEs$EVTYPE), value = T, invert = T))
# And 46 entries without any lower case characters.
# There could potentially be 48, so that's practically all of them.
# When we ignore the case of the entries (by converting them all to upper
# case), there are still 46 unique values.
# So there are two EVTYPE's that could be entered, but have not been
# entered. In other words: these event types did not occur.
Missing_EVTYPEs <- Allowed_EVTYPEs[!is.element(Allowed_EVTYPEs$UpperCase, 
                    unique(toupper(SD_Allowed_EVTYPEs$EVTYPE))), ]
Missing_EVTYPEs
# So DEBRIS FLOW and HURRICANE (TYPHOON) are the missing EVTYPE's.
# We check this visually by comparing the results from:
sort(unique(toupper(SD_Allowed_EVTYPEs$EVTYPE)))
# and
Allowed_EVTYPEs$UpperCase
