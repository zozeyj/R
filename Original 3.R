#3rd Original Visualization

#load necessary libraries 
library(readr)
library(ggplot2)
library(dplyr)

#Bring in dataset 
SCAD2018Africa_Final <- read_csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/SCAD2018Africa_Final.csv")
View(SCAD2018Africa_Final)

# Summarize data to count conflicts and calculate total fatalities for each year
filtered_data <- SCAD2018Africa_Final %>%
  filter(target1 == "Government")  
summary_data <- filtered_data %>%
  group_by(eyr, countryname) %>%
  summarise(nconflicts = n())

ggplot(data=summary_data,
       mapping = aes(x=eyr,
                     y=countryname)) +
  geom_tile(aes(fill= nconflicts ))+
  scale_x_continuous(breaks = seq(1991, 2020))+
  scale_fill_gradient(low="steelblue1",
                      high="slateblue4",
                      limits =c(5,40))+
theme_minimal()+

labs(title = "Government Targeted Conflicts in Africa 1990-2018",
     x = "Year",
     y = "Country",
     subtitle = "South Africa and Nigeria have extended years of conflict",
     caption = "Source: SCAD 2018 Africa Dataset | Yeji KIM") 
