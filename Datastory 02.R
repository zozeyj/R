# Load libraries
library(ggplot2)
library(dplyr)

# Read the CSV file
data <- read.csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/Nonstate_v23_1.csv")

# Filter data for location == "Nigeria" and aggregate data by year
filtered_data <- data %>%
  filter(location == "Nigeria") %>%
  group_by(year) %>%
  summarise(number_of_conflicts = n(),  # Counting number of rows per year which represents number of conflicts
            total_fatality = sum(best_fatality_estimate, na.rm = TRUE))  # Summing fatality estimates per year
View(filtered_data)

# Plotting
ggplot(filtered_data, aes(x = year)) +
  geom_col(aes(y = number_of_conflicts), fill = "lightgoldenrod") +  # Using geom_col for bar chart
  geom_line(aes(y = total_fatality/100), color = "darkslategray", size = 1.25) +
  scale_y_continuous(name = "Number of Conflicts", 
                     sec.axis = sec_axis(~.*100, name = "Total Fatality Estimate (x100)")) +
  scale_x_continuous(name = "Year", 
                     breaks = seq(min(filtered_data$year), max(filtered_data$year), by = 5)) +  # Adjust breaks to every 5 years
  
  # Using minimal theme and removing background grid
  theme_minimal() +
  theme(axis.title.y = element_text(color = 'darkgoldenrod', size = 12),
        axis.title.y.right = element_text(color = 'darkslategray', size = 12),
        panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank()) +  # Remove minor grid lines
  
  labs(title = "Conflicts and Fatality Estimate in Nigeria",
       subtitle = "1989-2022 Nigeria Non-State Conflict",
       caption = "Source: UCDP Non-State Conflict Dataset | Yeji KIM") 

