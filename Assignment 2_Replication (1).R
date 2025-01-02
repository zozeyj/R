# Load required library
library(ggplot2)
library(readr)

crimeRatesByState2005 <-
  read_delim("http://datasets.flowingdata.com/crimeRatesByState2005.tsv",
             "\t", escape_double = FALSE, trim_ws = TRUE)
View(crimeRatesByState2005)

# Calculate the size of the bubble
bubble_size <- sqrt(crimeRatesByState2005$population / pi)

# Create the bubble chart
ggplot(crimeRatesByState2005, 
       aes(x = murder, y = burglary,size=bubble_size, label = state)) +
  geom_point(color = "red",alpha = 0.7) +
  scale_size_continuous(range = c(3,20), breaks=c(3e6,20e6,40e6),labels=c("3M","20M","40M")) +
  geom_text(size = 3, vjust = 0, hjust = 0) +  # To avoid overlapping text
  scale_x_continuous(limits = c(0, max(crimeRatesByState2005$murder) + 2), 
                     breaks = seq(0, max(crimeRatesByState2005$murder) + 2, by = 2)) +
  scale_y_continuous(limits = c(0, max(crimeRatesByState2005$burglary)), 
                     breaks = seq(0, max(crimeRatesByState2005$burglary) + 200, by = 200)) +
  labs(title="MURDERS VERSUS BURGLARIES IN THE UNITED STATES",
         x = "Murders", y = "Burglaries") 
  