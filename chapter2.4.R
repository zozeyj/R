#2.4 Chain commands 
#we want to create a new data set that contains a new variable "gdp_pc"
approval_with_gdp_pc <- mutate(approval, gdp_pc = gdp/population)
filter(approval_with_gdp_pc, gdp_pc > mean(gdp_pc))

#Take the approval dataset, 'then = Pipes' generate a new variable called 
#gdp_pc, 'then' filter the observations 
#so only the ones where gdp_pc is greater than mean remain
approval %>%
  mutate(gdp_pc=gdp/population) %>%
  filter(gdp_pc > mean(gdp_pc)) %>%
  group_by(country)

approval %>%
  group_by(country) %>%
  summarize(unemployment_mean = mean(unemployment),
            growth_mean = mean(gdp_growth),
            approv_mean = mean(net_approval))

#Exercise 2E 
#below is my attempt and it did not work 
#because I included 'approval' in the summarize command 
approval %>%
  mutate(gdp_pc=gdp/population)%>%
  filter(2009<year & year<2015)%>%
  group_by(country) %>%
  summarize(approval, gdp_mean = mean(gdp_pc))

#this is the correct code 
approval %>%
  mutate(gdp_pc = gdp / population) %>%
  filter(2009 < year & year < 2015) %>%
  group_by(country) %>%
  summarize(gdp_mean = mean(gdp_pc)) %>%
  arrange(desc(gdp_mean))

#2G
approval %>%
  filter(president_gender=="Female") %>%
  group_by (country, year, quarter) %>%
  summarize(
    president_gender=president_gender,
    corruption=mean(corruption),
    approval = mean(net_approval))

#2.5 Recode values
approval %>%
  mutate(d_woman_pres= if_else(condition = president_gender == "female",
                               true = 1,
                               false = 0)) %>%
  select(country:president, president_gender, d_woman_pres)

approval %>%
  mutate(d_ec_crisis =if_else(gdp_growth <0 | unemployment > 20, 
                              true =1, 
                              false = 0)) %>%
  select(country:quarter, gdp_growth, unemployment, d_ec_crisis) %>%
  filter(country=="Argentina" & year %in% c(2001,2013))

#what if if_else is not enough? What happens if the variable that we want to create can assume more than two values? 
#for example, it is not a dummy category but rather grouping countries in to three or more categorical themes
#then you can use its sibling function case_when()

approval %>%
  mutate(country_group = case_when(
    country %in% c("Argentina", "Chile", "Uruguay") ~ "Southern Cone", #the first group is assigned 
    country %in% c("Costa Rica", "El Salvador", "Guatemala", "Honduras",
                   "Nicaragua", "Panama") ~ "Central America",
    TRUE ~ "Rest of LA"
  )) %>%
    filter(year==2000 & quarter ==1) %>%
  select(country, country_group)

#2H
approval %>%
  mutate(d_ec_crisis =case_when( gdp_growth <0 | unemployment > 20 ~ 0,
                                 TRUE ~ 1)) %>%
  select(country:quarter, gdp_growth, unemployment, d_ec_crisis) %>%
  filter(country=="Argentina" & year %in% c(2001,2013)) 

#2I
approval %>%
  mutate(country_grouped = case_when(
    country %in% c("Costa Rica", "El Salvador", "Guatemala", "Honduras",
                     "Nicaragua", "Panama") ~ "Central America",
    country %in% c("Mexico") ~ "North America",
    TRUE ~ "South America"
         )) %>%
  select(country_grouped, country:quarter, gdp_growth, unemployment)

countrylist <- select(approval,country)
countrylist %>% 
  distinct()
  arrange(country)

