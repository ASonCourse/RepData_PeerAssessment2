# Manipulating the data: grouping by EVTYPE, ordering by fatalities,
# display only relevant colums / variables, filter out events without
# any fatalities:
EVs_by_Fatalities <- StormData %>%
        group_by(EVTYPE) %>%
        arrange(desc(FATALITIES)) %>%
        select(EVTYPE, FATALITIES) %>%
        filter(FATALITIES > 0)



# Barplot showing fatalities per EVTYPE:
barplot(StormData$FATALITIES)

# Which EVTYPE has more than 500 fatalities?
StormData[which(StormData$FATALITIES > 500), EVTYPE]
# Answer: HEAT
# In which year was that?
StormData[which(StormData$FATALITIES > 500), BGN_DATE, END_DATE]
# Answer: 7/16/1995 0:00:00 7/12/1995 0:00:00
# What happened in 1995?
# Answer: https://en.wikipedia.org/wiki/1995_Chicago_heat_wave

# Which EVTYPE has more than 100 but less than 500 fatalities?
StormData[which(StormData$FATALITIES > 100 & StormData$FATALITIES < 500), EVTYPE]
# Answer: TORNADO, TORNADO, TORNADO

# Unordered list of fatalities (summarized) per EVTYPE:
EVs_by_Fatalities3 <- StormData %>%
        group_by(EVTYPE) %>%
        summarise(FATS = sum(FATALITIES))

# Which (group of) EVTYPE has more than 5000 fatalities in total?
EVs_by_Fatalities3[which(EVs_by_Fatalities3$FATS > 5000),]
# Answer: TORNADO

# This produces an ordered list ranking the EVTYPEs by total
# number of fatalities:
EVs_by_Fatalities2 <- StormData %>%
        group_by(EVTYPE) %>%
        summarise(FATS = sum(FATALITIES)) %>%
        filter(FATS > 0) %>%
        arrange(desc(FATS))

# EXCESSIVE HEAT ranks #2 in this list, but we've seen the 1995
# heatwave caused a disproportional number of fatalities. Let's
# look at the average number of fatalities instead:
EVs_by_Fatalities4 <- StormData %>%
        group_by(EVTYPE) %>%
        summarise(FATS = mean(FATALITIES, na.rm = TRUE)) %>%
        arrange(desc(FATS))