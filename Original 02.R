library(ggplot2)
library(dplyr)

# Read the CSV file
data <- read.csv("Nonstate_v23_1.csv")

# Filter data for location == "Sudan"
filtered_data <- data %>%
  filter(location == "Sudan")

# Plotting
ggplot(summary_data, aes(x = year)) +
  geom_bar(aes(y = number_of_conflicts), stat = "identity", fill = "lightgoldenrod") +
  geom_line(aes(y = total_fatality/100), color = "darkslategray",size= 1.25) +
  scale_y_continuous(name = "Number of Conflicts", 
                     sec.axis = sec_axis(~.*100, name = "Best Fatality Estimate")) +
  scale_x_continuous(name = "Year", breaks = seq(1989, 2022, by = 1)) +
  
#Visualizing
  theme(axis.title.y = element_text(colour = 'darkgoldenrod',size=12),
        axis.title.y.right = element_text(colour = 'darkslategray',size=12),
        plot.background = element_rect(colour='white'),
        panel.background = element_rect(fill='white',colour = 'gray'),
        panel.grid.major.y = element_line(colour='lavender'),
        panel.grid.minor.x = element_line(colour='lavender'),
        panel.grid.minor.y = element_line(colour='lavender'))+
  
  labs(title = "Conflicts and Fatality Estimate in Sudan",
       subtitle = "1989-2022 Sudan Non-State Conflict",
       caption = "Source: UCDP Non-State Conflict Dataset | Yeji KIM") 



