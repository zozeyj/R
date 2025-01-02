# Load libraries
library(readr)
library(ggplot2)
library(dplyr)
library(treemap)

# Read the CSV file
SCAD2018Africa_Final <- read_csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/SCAD2018Africa_Final.csv")

# Define country code lists for each region
NorthA <- c(615, 651, 620, 600, 625, 616)
EasternA <- c(553, 590, 516, 581, 522, 531, 530, 501, 580, 541, 517, 591, 520, 626, 510, 500, 551, 552)
CentralA <- c(540, 471, 482, 484, 481, 403, 483, 490)
SouthernA <- c(571, 570, 565, 560)
WesternA <- c(438, 434, 439, 402, 437, 420, 452, 404, 450, 432, 435, 436, 475, 433, 451, 461)

get_region <- function(code) {
  if (code %in% NorthA) {
    return("Northern Africa")
  } else if (code %in% EasternA) {
    return("Eastern Africa")
  } else if (code %in% CentralA) {
    return("Central Africa")
  } else if (code %in% SouthernA) {
    return("Southern Africa")
  } else {
    return("Western Africa")
  }
}

# Apply the function to create a new column for region
SCAD2018Africa_Final$region <- sapply(SCAD2018Africa_Final$ccode, get_region)

# Now you have a new column 'region' indicating the region for each entry
# Summarize data at the country level
country_summary <- SCAD2018Africa_Final %>%
  group_by(region, countryname) %>%
  summarise(total_conflicts = n())

# Plot treemap with first level as region and subgroup as countries
treemap(country_summary, index = c("region", "countryname"), vSize = "total_conflicts", 
        title = list("Western Africa has the highest number of conflicts from 1980-2018"), 
        fontsize.labels = c(15, 12),               
        fontcolor.labels = c("white", "white"),   
        fontface.labels = c(2, 3),                 
        bg.labels = c("transparent"),              
        align.labels = list(
          c("center", "top"), 
          c("right", "bottom")
        ),                      
        overlap.labels = 0.5,     
        inflate.labels = F
) +
  labs(caption = "Source: SCAD 2018 Africa Dataset | Yeji KIM") 
