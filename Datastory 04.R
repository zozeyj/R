library(dplyr)
library(waffle)
library(ggplot2)

# Filter for specific years and load data
filtered_data <- data_nigeria %>%
  filter(as.numeric(as.character(year)) %in% c(2014,2015, 2016,2017,2018,2019,2020,2021,2022))

# Prepare data: Count conflicts by year and organization type with less aggressive scaling
conflict_summary <- filtered_data %>%
  group_by(year, org) %>%
  summarise(n = n(), .groups = 'drop') %>%
  mutate(n_scaled = floor(n / 1))  # Adjust this divisor to ensure visibility of squares

# Check data presence for all years
print(unique(filtered_data$year))
print(table(conflict_summary$year))

# Waffle chart
plot <- ggplot(conflict_summary, aes(fill = org, values = n_scaled)) +
  geom_waffle(n_rows = 3, color = "white", size = 0.2, flip = TRUE, na.rm = TRUE) +
  facet_grid(. ~ year, scales = "free_x") +
  labs(title = "Conflicts in Nigeria by Selected Years and Organization Type", x = NULL, y = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom", panel.spacing = unit(1, "lines"), axis.text.x = element_blank(), axis.text.y = element_blank())

# Print the plot
print(plot)
