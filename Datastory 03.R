# Load libraries
library(ggplot2)
library(dplyr)
library(wordcloud2)

# Read the CSV file
data <- read.csv("C:/Users/yeji/Desktop/Data Viz/# Portfolio Data/Nonstate_v23_1.csv")

# Filter data for conflicts in Nigeria
data_nigeria <- filter(data, location == "Nigeria")

# Combine the names from side_a and side_b into one text vector and create a frequency table
names_combined <- c(as.character(data_nigeria$side_a_name), as.character(data_nigeria$side_b_name))
freq_table <- as.data.frame(table(names_combined))

# Rename columns for wordcloud2
colnames(freq_table) <- c("word", "freq")

# Define a custom color palette
custom_colors <- rep_len(c("#FF8585", "#FF4A4A", "#44690D", "#FBE646", "#FFEDC7", "#DBA4A6"), nrow(freq_table))

# Create a word cloud with a custom color palette and specified font
wordcloud2(freq_table, size=1.6, color=custom_colors, backgroundColor="black", fontFamily="serif")
