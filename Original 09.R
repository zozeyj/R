# Load necessary libraries
library(readr)
library(ggplot2)
library(dplyr)

# Read in the dataset
SCAD2018Africa_Final <- read_csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/SCAD2018Africa_Final.csv")

# Filter data to include only specific countries and target "Government"
filtered_data <- SCAD2018Africa_Final %>%
  filter(target1 == "Government",
         countryname %in% c("Nigeria", "Egypt", "Somalia", "Democratic Republic of the Congo", "South Africa"))

# Summarize data to count conflicts for each year and country
summary_data <- filtered_data %>%
  group_by(eyr, countryname) %>%
  summarise(nconflicts = n(), .groups = 'drop') %>%
  complete(eyr = full_seq(eyr, 1), countryname, fill = list(nconflicts = 0))  # Ensures every combination of year and country is present

# Updated ggplot command with adjusted theme settings and axis labels
plot <- ggplot(data = summary_data, aes(x = countryname, y = eyr, fill = nconflicts)) +
  geom_tile() +
  scale_y_reverse(breaks = seq(1991, 2020, by = 5), labels = seq(1991, 2020, by = 5)) +  # Display years every five years
  scale_fill_gradient(low = "steelblue1", high = "slateblue4", na.value = "lightgray", limits = c(0, 40)) +
  theme_minimal() +
  labs(title = "Government Targeted Conflicts in Africa 1990-2018",
       subtitle = "South Africa and Nigeria have extended years of conflict",
       x = "Country",
       y = "Year",
       caption = "Source: SCAD 2018 Africa Dataset | Yeji KIM") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate country names for better readability
        panel.background = element_blank(),  # Remove background
        panel.grid.major = element_blank(),  # Remove major gridlines
        panel.grid.minor = element_blank(),  # Remove minor gridlines
        axis.ticks = element_blank())  # Remove axis ticks for a cleaner look

# Print the updated plot
print(plot)
