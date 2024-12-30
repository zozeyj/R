#Chapter 3. Data Visualization
library(tidyverse)
library(politicalds)
library(ggrepel)
library(ggplot2)

data("municipal_data")
glimpse(municipal_data)
View(municipal_data)

#3.2 Faceting_ wrap and grip 
ggplot(data = municipal_data %>% filter(year == c(2004,2008,2012)),
       mapping = aes(x=year, y=poverty)) +
  geom_boxplot() +
  facet_wrap(~zone, nrow =1)

ggplot(data = municipal_data %>% filter(year == c(2004,2008,2012)),
       mapping = aes(x=year, y=poverty)) +
  geom_boxplot() +
  facet_wrap(zone ~ gender)

ggplot(data = municipal_data %>% filter(year == c(2004,2008,2012)),
       mapping = aes(x=year, y=poverty)) +
  geom_boxplot() +
  facet_grid(zone ~ gender)

#3.2.1.5 transformations
ggplot(data = municipal_data %>% filter(year == c(2004,2008,2012)),
       mapping = aes(x=poverty,y=income)) +
  geom_point()

#most frequently, when we use a variable related to money, 
#we apply a logarithmic transformation
ggplot(data = municipal_data %>% filter(year == c(2004,2008,2012)),
       mapping = aes(x=poverty,y=income)) +
  geom_point() +
  scale_y_log10()

#3.3 application
#want to know how many women were elected as mayors
plot_a <- ggplot(municipal_data, mapping = aes(x=gender))
plot_a +
  geom_bar()+
  facet_wrap(~year, nrow=1)

plot_a +
  geom_bar(mapping = aes(y= after_stat(prop), group=1))+
  facet_wrap(~zone, nrow=1)+
  scale_x_discrete(labels=c("Men","Women"))+
  labs(title="Proportion of men and women elected as mayors (2004-2012)",
       subtitle = "By economic zones of Chile",
       x="Gender", y = "Proportion",
       caption = "Source: Based on data from SERVEL and SINIM (2018)") +
  theme()

#line graph
plot_b <- ggplot(data = municipal_data,
                 mapping = aes(x = year, y = income))

plot_b +
  geom_line()

plot_b +
  geom_line(mapping = aes(group = municipality))

plot_b +
  geom_line(mapping = aes(group = municipality))+
  facet_wrap(~zone, nrow=2)

#create a dataset that contains the mean income by every zone
means <- municipal_data %>%
  group_by(zone) %>%
  summarize(mean = mean(income, na.rm = T))

plot_b +
  geom_line(color = "lightgray", aes(group = municipality)) + 
  geom_hline(aes(yintercept = mean), data = means, color = "black")+ 
  scale_x_discrete(expand = c(0,0))+
  scale_y_log10(labels =scales::dollar)+
  facet_wrap(~zone, nrow=2) +
  labs(title = "Municipal income in electoral years (2004-2012)",
       y = "Income",
       x = "Years") +
  theme(panel.spacing = unit(2, "lines"))

#3.3 Boxplot
plot_c <- ggplot(data = municipal_data %>%
                   filter(year %in% c(2004,2008,2012)),
                 mapping = aes(x=income, y=zone))+
  geom_boxplot()+
  facet_wrap(~year, ncol=1)

plot_c #we can observe outliers 

plot_c +
  geom_text(data = municipal_data %>% filter(income > 50000000),
            mapping = aes(label = municipality))
#the downside of it is that the labels are overlapping 

library(ggrepel)
plot_c +
  geom_text_repel(data = municipal_data %>% 
                    filter(income>50000000),
                  mapping = aes(label=municipality)) +
  scale_x_continuous(labels = scales:: dollar) +
  labs(title = "Municipal income by zone (2004-2012)",
       x= "Income", y = "Zone",
       caption = "Source: Based on data from SINIM (2018)")

library(ggthemes) # themes from well known magazines The Economist 
library(hrbrthemes) #elaborated some minimalist and elegant themes
library(wespalette) #into colors
library(colorfindr) #create my own palette

#3.3.4 Histogram 
ggplot(data = municipal_data %>% filter(income<50000000),
       mapping = aes(x=income, fill=zone)) +
  geom_histogram(alpha = 0.5, bins=50)+
  scale_x_continuous(labels = scales ::dollar)+
  labs(title = "Number of municipalities according to their annual income",
       subtitle = "Chile(2004-2012)",
       x = "Income", y = "Number of municipalities", 
       caption = "Source: Based on data from SINIM (2018)")

#3.3.5 relations between variables
plot_f <- ggplot(data= municipal_data,
                 mapping = aes(x=poverty, y=log(income)))

plot_f+
  geom_point(alpha=0.3)+
  geom_smooth(method = "lm", color = "black")+
  scale_x_continuous(expand = c(0,0))+
  labs(title = "Relation between municipality income and its poverty rate",
       subtitle = "Chile (2004-2012)",
       x = "CASEN's poverty rate", y = "Income",
       caption = "Source: Based on data from SINIM(2018)")+
  annotate(geom = "text", x = 50, y=15, label = "Correlation: -0.27")

cor(municipal_data $poverty, municipal_data$income,
    use = "pairwise.complete.obs") #treatment of missing values 
  
library(ggparliament) #all political scientist should know this package 

#3.4 patchwork
plot_a2 <- plot_a +
  geom_bar()

plot_b2 <- plot_b +
  geom_line(mapping = aes(group = municipality))

library(patchwork)
(plot_a2 | plot_b2) / plot_c

#3.E Choosing only one year, make a line graph with geom_smooth()
#that indicates the relation between income and poverty rate. Now, with
#annotate() make a box that encloses the municipalities with the highest poverty rate and
#and above it, write down the corresponding municipality 

plot_e <- ggplot(data= municipal_data %>% filter(year==2008),
                 aes(x=poverty, y = log(income)))

plot_e +
  geom_point(alpha=0.3)+
  geom_smooth(method = "lm", color = "black")+
  scale_x_continuous(expand = c(0,0))+
  annotate(geom = "box", x = 50, y=15, label = "Correlation: -0.27")

library(ggplot2)
library(dplyr)

# Assuming municipal_data is your data frame containing the relevant data

# Step 1: Filter data for the year 2008
plot_e <- ggplot(data = filter(municipal_data, year == 2008),
                 aes(x = poverty, y = log(income)))

# Step 2: Create the scatter plot with a smoothed line (using geom_smooth)
plot_e +
  geom_point(alpha = 0.3) +  # Scatter plot of poverty vs. log(income)
  geom_smooth(method = "lm", color = "black") +  # Add linear regression line
  scale_x_continuous(expand = c(0, 0)) +  # Ensure x-axis starts at 0
  scale_y_continuous(expand = c(0, 0)) +  # Ensure y-axis starts at 0
  labs(x = "Poverty Rate", y = "Log Income") +  # Label axes
  theme_minimal() +  # Minimal theme for cleaner look
  
  # Step 3: Annotate the plot to highlight municipalities with highest poverty rate
annotate(geom = "rect", xmin = quantile(municipal_data$poverty, probs = 0.95), xmax = Inf,
           ymin = -Inf, ymax = Inf, fill = "gray", alpha = 0.3) +
  
annotate(geom = "text", x = quantile(municipal_data$poverty, probs = 0.95) + 1, 
         y = max(log(municipal_data$income)),
        label = paste("Highest Poverty Rate Municipality:", 
                         municipal_data %>% filter(year == 2008 & poverty == max(poverty)) %>% pull(municipality)),
           hjust = 0, vjust = 1, size = 5)
