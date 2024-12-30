library(tidyverse)
library(politicalds)

#load our dataset into the R session
data("approval")
#check whether data is loaded correctly
ls()

#how to observe new data?
approval
glimpse(approval)
View(approval)
skimr::skim(approval)
#let's find out the countries-years-quarters with women as presidents 
count(approval, president_gender, sort=T) #order from highest to lowest by n

#only want to select the countries 
select(approval, country)
reduced_approval <- select(approval, country)
reduced_approval

select(approval, country, year, unemployment)
select(approval, country:net_approval) # select multiple columns at once

#if we want to rearrange our datasets, say want to put president at first 
select(approval, president, country:year, net_approval:unemployment)
select(approval, president, everything())
#another helpful function for select is starts_with(), which allows us to select
#columns according to patterns in its names
select(approval, starts_with("gdp"))

#rename columns
rename(approval,gdp_ppp_c2011 = gdp,
       unemployment_percentage = unemployment,
       gdp_percent_growth = gdp_growth)

#filter
filter(approval, country=="Chile")
filter(approval, net_approval>0)
filter(approval, president_gender=="Female")
filter(approval,
       country == "Argentina" | country == "Chile" | country == "Uruguay")
filter(approval, corruption > mean(corruption))
filter(approval, is.na(corruption))

#arrange
arrange(approval, corruption) #least corruption to the most corrupted
arrange(approval, -corruption) #if want the inverse sorting 
arrange(approval, desc(president)) #utilizing inverse alphabetic order 
arrange(approval, president_gender, -net_approval) #this would give us president by gender 
#and by highest approval to lowest

#mutate - create new variables from the ones we already have 
mutate(approval, population_mill = population /1000000)
mutate(approval, log_gdp = log(gdp))
mutate(approval, gdp_pc = gdp/population)
View(approval)

#Exercise 2C
female_approval <- select(approval_wide1, country:president, president_gender, net_approval)

filter(female_approval, president_gender=="Female")
arrange(female_approval, -net_approval) 

View(female_approval) 

#if I run the two codes at the same time, it would show me Male president too??

#Exercise 2D Create a new variable, which registers unemployment as a proportion instead of a percentage 
mutate(approval, p_unemployment = unemployment/100)

#summaries 
summarize(approval, 
          unemplotmen_mean = mean(unemployment),
          growth_mean = mean(gdp_growth),
          approv_mean = mean(net_approval))

#grouped summaries
approval_by_country <- group_by(approval, country)
summarize(approval_by_country,
          unemployment_mean = mean(unemployment),
          gdp_growth_mean = mean(gdp_growth),
          approv_mean = mean(net_approval))

summarize(approval_by_country,
          unemployment,
          gdp_growth,
          net_approval)

approval_by_country_year <- group_by(approval, country, year)
summarize(approval_by_country_year,
          unemployment = mean(unemployment),
          gdp_growth = mean(gdp_growth),
          approv = mean(net_approval) )

#you can ungroup as much as you grouped
approval_by_country_year %>%
  ungroup()