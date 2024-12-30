library(tidyverse)
library(politicalds)

#2.5.1 Data pivoting
#let's create a dataset at country-year level with the mean levels of approval
approval_annual <- approval %>%
  group_by(country,year)%>%
  summarize(net_approval = mean(net_approval)) %>%
  ungroup()

approval_annual

#this tidy dataset can be presented in different formats 
#the most common format is the 'wide' format -- in which one of the id variables is distributed among the columns 
data("approval_wide1")
approval_wide1

#benefit of the wide format is briefness, but its weakness is that it can only 
#register one variable of the dataset and luckily tidyr package -- useful function
#provides how to rapidly convert data from wide to tide 
approval_wide1 %>%
  pivot_longer(cols = -country, #transform all variables, except country, identification variable
               names_to = "year", values_to = "net_approval")

#the reverse operation would be pivot_wider 
approval_annual %>%
  pivot_wider(names_from = "year", values_from = "net_approval")

#2J make a tidy dataset with the mean GDP growth
approval_annual <- approval %>%
  group_by(country,year)%>%
  summarize(gdp_growth = mean(gdp_growth)) %>%
  pivot_wider(names_from = "year", values_from = "gdp_growth")
approval_annual

approval_annual %>%
  pivot_longer(cols = -country,
               names_to = "year", values_to = "gdp_growth")
approval_annual

#2.5.2 Wide datasets with more than one variable of interest
data("approval_annual")
data("approval_wide2")
approval_wide2 %>%
  pivot_longer(cols = -country,
               names_to = c("varialbe","year"), names_sep = "_")

approval_wide2 %>%
  pivot_longer(cols= - country,
               names_to =c("variables", "year"), names_sep = "_") %>%
  pivot_wider(names_from = "variable", values_from = "value")

