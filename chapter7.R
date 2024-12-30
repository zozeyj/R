#Chapter 7

#7.1 panel data - how to add a temporal dimension
library(tidyverse)
library(politicalds)
library(unvotes)
library(lubridate)
library(ggpubr)

data("us_brazil")
View(us_brazil)
ggplot(us_brazil) +
  geom_line(aes(x=year, y=vote)) +
  labs(x="Year", y = "Vote convergence")

p_votes_us_br <- un_votes %>%
  filter(country %in% c("United States", "Brazil")) %>%
  inner_join(un_roll_calls, by = "rcid") %>%
  inner_join(un_roll_call_issues, by = "rcid")%>%
  mutate(issue = if_else(issue == "Nuclear weapons and nuclear material",
                         "Nuclear weapons", issue)) %>%
  group_by(country, year= year(date), issue) %>%
  summarize(votes = n(),
            percent_yes = mean(vote == "yes")) %>%
  filter(votes>5)

View(p_votes_us_br)
ggplot(p_votes_us_br,
       mapping = aes(x=year, y=percent_yes, color = country))+
  geom_point()+
  geom_smooth(method="loess", se=F)+
  facet_wrap(~issue, ncol=2)+
  scale_color_grey()+
  labs(x="Year", y="% Yes", color="Country")

ggplot(us_brazil)+
  geom_line(aes(x=year, y = country_power))+
  labs(x="Year", y = "Country power index")
#Amorim Neto's hypothesis -  
#Brazil became more powerful, autonomous foreign policy

ggscatter(us_brazil, x="country_power", y="vote",
          add = "reg.line", add.params = list(color="black",
                                              fill="lightgray"),
          conf.int = TRUE)+
  stat_cor(method="pearson", label.x=0.015)

#7.2 Describing your panel data
data("us_latam")
us_latam %>%
  count(country)

#examine graphically the independent and dependent variable
ggplot(us_latam, aes(x=year, y=vote,
                     color=country, linetype=country, group = country))+
  geom_line()+
  labs(x="Year", y="% Yes", color ="", linetype="")

ggplot(us_latam, aes(x=factor(year), y=vote))+
  geom_boxplot()+
  scale_x_discrete(breaks=seq(1970, 2007, by=5))+
  labs(x="Year", y="% Convergence with the US")

p_votes_countries <- un_votes %>%
  filter(country %in% c("United States", "Brazil", "Bolivia",
                        "Argentina", "Chile", "Peru", "Ecuador", "Colombia",
                        "Venezuela", "Paraguay", "Uruguay")) %>%
  inner_join(un_roll_calls, by = "rcid") %>%
  inner_join(un_roll_call_issues, by = "rcid")%>%
  mutate(issue = if_else(issue == "Nuclear weapons and nuclear material",
                         "Nuclear weapons", issue)) %>%
  group_by(country, year= year(date), issue) %>%
  summarize(votes = n(),
            percent_yes = mean(vote == "yes")) %>%
  filter(votes>5)

ggplot(p_votes_countries,
       mapping = aes(x=year, y=percent_yes, 
                     color = country, linetype= country))+
  geom_smooth(method="loess", se=F)+
  facet_wrap(~issue, ncol=2)+
  scale_color_grey()+
  labs(x="Year", y="% Yes", color="", linetype ="")

us_latam %>%
  filter(country!="Brazil")%>%
  ggplot(aes(x=year, y=country_power))+
  geom_line()+
  facet_wrap(~country, nrow = 3)

#7.A
welfare_no_na %>%
  ggplot(aes(x=year, y=gini/100, color=country_id))+
  geom_line()+
  facet_wrap(~country_id,nrow=5)+
  labs(x="Year", y="Gini coefficient", color="")

#7.3 Modelling group-level variation
#First, a model in which we ignore the existence of eleven countries in the sample,
#we treat each observation as independent

pooled <-lm(vote~country_power, data = us_latam)
summary(pooled)

#second, model in which we incorporate each 