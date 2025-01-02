#load necessary libraries 
library (readxl)
library (ggridges)
library (dplyr)
library (ggplot2)
library (forcats)

# Bring in dataset 
SCAD2018Africa_Final <- read_csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/SCAD2018Africa_Final.csv")
year_subset <-c(seq(1990,2016,by=3))

# Subset data
filtered_data <- SCAD2018Africa_Final %>%
  filter(target1 == "Government")

# Summarize data
summary_data <- filter(filtered_data, eyr %in% year_subset)
View(summary_data)

# Create the plot
ggplot(data = summary_data, aes(x = duration, y = fct_rev(factor(eyr)))) +
  geom_density_ridges(fill = "dodgerblue", color = "darkblue", scale = 1.5, alpha = 0.5) +
  coord_cartesian(xlim = c(0, 100)) +
  theme_minimal()+

labs(title = "Duration of Government Targeted Conflicts in Africa 1990-2018",
     x = "Duration of Conflicts",
     y = "Year",
     subtitle = "Most conflicts terminate by day 25",
     caption = "Source: SCAD 2018 Africa Dataset | Yeji KIM") 


       

  