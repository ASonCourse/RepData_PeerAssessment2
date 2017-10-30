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