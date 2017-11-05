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

# How much of an outlier was the 1995 heatwave?
# Let's make a boxplot:
Heat_Fatalities <- StormData[StormData$EVTYPE == "HEAT", c(8, 23)]
Heat_Fatalities_Mean <- mean(Heat_Fatalities$FATALITIES, na.rm = TRUE)
Heat_Fatalities_Median <- median(Heat_Fatalities$FATALITIES, na.rm = TRUE)
Heat_Fatalities_Summary <- summary(Heat_Fatalities)
boxplot(FATALITIES ~ EVTYPE, data = Heat_Fatalities)
# It seems the 1995 heatwave was an extreme outlier that really distorts / skews
# the distribution. Removing this outlier may be defensable since there were
# compounding factors that contributed to the extreme amount of fatalities. Let's
# see what that does for the plot / distribution.
Heat_Fatalities_Minus_95HW <- Heat_Fatalities[Heat_Fatalities$FATALITIES != 583, ]
boxplot(FATALITIES ~ EVTYPE, data = Heat_Fatalities_Minus_95HW)
Heat_Fatalities_Minus_95HW_Sum <- summary(Heat_Fatalities_Minus_95HW)
# This brings everything much closer together. The mean is still not equal to the
# median (indicating a skewed distribution), but the difference is a lot smaller.
# The plot shows some outliers, but the whiskers still seem to be very close to 0.
# Looking at a densitiy plot seems interesting.

# Using a log-transformation to get rid of the skewedness didn't work, because
# there were 0's in the data. (Taking the log of those results in -Inf...). As we've
# seen Roger Peng do, we could add a very small amount to the zero's to produce
# a dataset that could be transformed using the log function.
Heat_Fatalities$FATALITIES[Heat_Fatalities$FATALITIES == 0] <- 0.0001
# Now we can create boxplots using the log of fatalities:
boxplot(log(FATALITIES) ~ EVTYPE, data = Heat_Fatalities)
Heat_Fatalities_Minus_95HW <- Heat_Fatalities[Heat_Fatalities$FATALITIES != 583, ]
boxplot(log(FATALITIES) ~ EVTYPE, data = Heat_Fatalities_Minus_95HW)
# Hm, this produces plots with negative values. That's not what
# we want...
# How about taking squares?
boxplot(sqrt(FATALITIES) ~ EVTYPE, data = Heat_Fatalities)
boxplot(sqrt(FATALITIES) ~ EVTYPE, data = Heat_Fatalities_Minus_95HW)
# This get's rid of the negative values and brings everything closer together,
# but the image doesn't improve substantially in comparison with the plot
# that was produced after filtering out the extreme outlier of the 1995
# heatwave. Resetting the original values:
Heat_Fatalities <- StormData[StormData$EVTYPE == "HEAT", c(8, 23)]
Heat_Fatalities_Minus_95HW <- Heat_Fatalities[Heat_Fatalities$FATALITIES != 583, ]

# Density plots?
plot(density(Heat_Fatalities$FATALITIES))
plot(density(EVs_by_Fatalities$FATALITIES))

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