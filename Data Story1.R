# Load libraries
library(readr)
library(ggplot2)
library(dplyr)

# Read the CSV file
SCAD2018Africa_Final <- read_csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/SCAD2018Africa_Final.csv")

# Filter data for specified countries
countries <- c("Nigeria", "Egypt", "Somalia", "South Africa", "Democratic Republic of the Congo")

# Prepare the data
filtered_data <- SCAD2018Africa_Final %>%
  filter(countryname %in% countries) %>%
  group_by(countryname, eyr) %>%
  summarise(totalconflicts = n(),
            government_conflicts = sum(cgovtarget == 1),
            other_conflicts = totalconflicts - government_conflicts,
            .groups = 'drop')

# Plotting with area charts
ggplot(filtered_data, aes(x = eyr, y = totalconflicts, fill = countryname)) +
  geom_area(aes(y = other_conflicts), fill = "lightyellow", color = "black", alpha = 0.5) +
  geom_area(aes(y = government_conflicts), fill = "darkblue", color = "black", alpha = 0.5) +
  facet_wrap(~countryname, scales = "free_y") +
  labs(title = "Total and Government Conflicts per Year by Country",
       x = "Year",
       y = "Number of Conflicts") +
  theme_minimal() +
  theme(panel.spacing = unit(1, "lines"))

