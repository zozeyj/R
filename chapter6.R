#Chapter 6
#nested analysis - combination of statistical analysis of 
#a large sample with in-dept study

#the first step is to estimate the residuals and the predicted values of the model
#will use the augment command from the broom package 
#this command creates a new dataset over the model that adds variables to the original dataset

#library
library(tidyverse)
library(broom)
library(politicalds)
data("welfare")

welfare_no_na <- welfare %>%
  drop_na(gini, education_budget, foreign_inv, health_budget,
          socialsec_budget, population,sector_dualism,
          ethnic_diversity, gdp, regime_type, legislative_bal, repression)

model_2 <- lm(gini ~ 1+ education_budget + foreign_inv + health_budget +
                socialsec_budget + population + sector_dualism +
                ethnic_diversity + gdp + regime_type + legislative_bal + 
                repression,
              data = welfare_no_na)

model_aug <- broom::augment(model_2, data=welfare_no_na)
model_aug

#objective of case selection, examine the mechanisms of independent - dependent 
#look for case with lowest residual --> called on theline cases

#graph showing three cases (Brazil appears 2) where the residual is lowest
ggplot(data = model_aug, mapping = aes(x=.fitted, y=.resid))+
  geom_point() +
  geom_hline(aes(yintercept=0)) +
  geom_text(data= model_aug %>%
              mutate(.resid_abs = abs(.resid)) %>%
              top_n(-4, .resid_abs),
            mapping = aes(label = country_id))

#outliers - 'theoretical anomalies' 
ggplot(data = model_aug, mapping = aes(x=.fitted, y=.resid))+
  geom_point() +
  geom_hline(aes(yintercept=0)) +
  geom_text(data= model_aug %>%
              mutate(.resid_abs = abs(.resid)) %>%
              top_n(4, .resid_abs),
            mapping = aes(label = country_id))

#influential cases - helps to confirm baseline hypothesis
#dfbetas - how much the deletion of a single observation would have changed?
model_aug %>%
  mutate(dfb_cseduc = as.tibble(dfbetas(model_2))$education_budget) %>%
  arrange(-dfb_cseduc) %>%
  slice(1:3) %>%
  dplyr::select(country_id, dfb_cseduc)

#cook's distance 
ggplot(data=model_aug,
       mapping = aes(x=.fitted, y=.cooksd))+ 
  #.fitted is typically used on the x-axis 
  # to represent the predicted values from the model.
  geom_point()+
  geom_text(data=model_aug%>%top_n(3, .cooksd),
            mapping = aes(label = country_id))+
  labs(title = "Influential Cases")

#extreme cases
#independent variable
ggplot(data=welfare_no_na,
       aes(x=education_budget))+
  geom_histogram(binwidth = 1)+
  labs(caption = "Source: Huber et al (2006)",
       x = "Education Expenditures",
       y = "Frequence")

mean(model_aug$education_budget, na.rm=T)
model_aug %>%
  mutate(diff_cseduc = abs(education_budget- mean(education_budget,
                                                  na.rm = T))) %>%
  top_n(3, diff_cseduc) %>%
  arrange(-diff_cseduc) %>%
  dplyr::select(country_id, year, education_budget, diff_cseduc)

model_aug <- model_aug %>%
  mutate(dif_cseduc = education_budget - mean(education_budget, na.rm = T))

ggplot(data=model_aug,
       mapping = aes(x=.fitted, y=dif_cseduc))+
  geom_point()+
  geom_text(data=model_aug %>% top_n(3, dif_cseduc),
            mapping = aes(label = country_id))

mean(model_aug$gini, na.rm=T)
model_aug %>%
  mutate(dif_gini = abs(gini-mean(gini,na.rm=T))) %>%
  top_n(3, dif_gini) %>%
  arrange(-dif_gini) %>%
  dplyr ::select(country_id, gini, dif_gini)

#matching cases - similar in covariates but differ in the variable of interest
#propensity score - the probability of being in the treatment (dummy=1) conditioned by the controlled variables

welfare_no_na <- welfare_no_na%>%
  mutate(treatment = if_else(education_budget>mean(education_budget),
                             1,0)) #make a dataframe where you have treatment group
#with education budget higher than the mean and the other where budget is lower
#In this case, the augment function cannot be directly used as a substitute for mutate. The augment function is specifically designed to add columns related to model outputs (like predicted values, residuals, etc.) to a dataset based on a model object. It is not intended for creating new variables based on conditional logic or calculations that are independent of a model.
m_propensityscore <- glm(treatment ~ sector_dualism+foreign_inv+gdp+
                           population+ethnic_diversity+regime_type+
                           regime_type*socialsec_budget + health_budget+
                           socialsec_budget+legislative_bal+repression,
                         data = welfare_no_na,
                         family = binomial(link = logit),
                         na.action =na.exclude)

propensity_scores <- augment(m_propensityscore, data = welfare_no_na,
                             type.predict = "response") %>%
  dplyr::select(propensity_scores = .fitted, country_id, treatment, year, gini)

#cases with low propensity scores in the group where expenditure higher than sample
propensity_scores %>%
  filter(treatment==1) %>%
  arrange(propensity_scores) %>%
  dplyr::select(country_id, year, propensity_scores) %>%
  slice(1:2)

#cases wwith low propensity score among expenditure below average
propensity_scores %>%
  filter(treatment==0) %>%
  arrange(propensity_scores) %>%
  dplyr::select(country_id, year, propensity_scores) %>%
  slice(1:2)

propensity_scores <- propensity_scores %>%
  mutate(gini=if_else(gini>mean(gini, na.rm = T), 1,0))

propensity_scores %>%
  filter(gini==1 & treatment==0) %>%
  #country with gini higher than mean and budget lower than mean
  arrange(propensity_scores) %>%
  dplyr::select(country_id, year, propensity_scores) %>%
  slice(1:2)

propensity_scores %>%
  filter(gini==1 & treatment==0) %>%
  #country with gini higher than mean and budget lower than mean
  arrange(~ propensity_scores) %>%
  dplyr::select(country_id, year, propensity_scores) %>%
  slice(1:2)
  arrange(propensity_scores) %>%
  dplyr::select(country_id, year, propensity_scores) %>%
  slice(1:2)
  
propensity_scores %>%
    filter(gini == 1 & treatment == 0) %>%
    arrange(desc(propensity_scores)) %>%
    dplyr::select(country_id, year, propensity_scores) %>%
    slice(1:2)
  