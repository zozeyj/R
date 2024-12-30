#chapter 5

#let's clean it
rm(list=ls())

#load libraries
library(tidyverse)
library(politicalds)
library(skimr)
library(car)
library(ggcorrplot)
install.packages("texreg")
library(texreg)
install.packages("prediction")
library(prediction)
install.packages("lmtest")
library(lmtest)
install.packages("sandwich")
library(sandwich)
install.packages("miceadds")
library(miceadds)

#OLS in R 
#first, merge two datasets
data("welfare")
ls()

#goal - we want to examine what creates inequality 
#dependent variable - gini
#control variable - (many but primarily) education_budget

skimr::skim(welfare)
corr_selected <- welfare %>%
  select(gini, education_budget, sector_dualism, foreign_inv, gdp, 
         ethnic_diversity, regime_type, health_budget, socialsec_budget,
         legislative_bal, population) %>%
  cor(use="pairwise")%>%
  round(1)
ggcorrplot(corr_selected, type ="lower", lab=T, show.legend = F)

ggplot(welfare, aes(x=gini, na.rm=T))+
  geom_histogram(binwidth = 1) +
  labs(x="Gini Index", y = "Frequency",
       caption = "Source: Huber et al (2012)")

ggplot(welfare, aes(x=education_budget, na.rm=T))+
  geom_histogram(binwidth = 1) +
  labs(x="Education Expenditure", y = "Frequency",
       caption = "Source: Huber et al (2012)")

ggplot(welfare, aes(education_budget, gini)) +
  geom_point() +
  geom_smooth(method = "lm", #the regression line is overlapped
              se = F, # the error area is not plotted at a 95% CI
              color = "black")+
  labs( x = "Education Expenditure (% of GDP)", y = "Gini",
    caption = "Source: Huber and Stephens (2012)" )

#5.2 Simple linear regression
model_1 <- lm(gini ~ 1+education_budget, data=welfare)
class(model_1) #verify the object of class is lm
summary(model_1)
screenreg(model_1) #more visually friendly
screenreg(model_1,
          custom.model.names = "Model 1",
          custom.coef.names = c("Constant", "Education expenditure"))
htmlreg(list(model_1), file = "model_1.doc",
        custom.model.names = "Model 1",
        custom.coef.names = c("Constant", "Education expenditure"),
        inline.css = FALSE, doctype = T, html.tag = T,
        head.tag = T, body.tag = T)

model_2 <- lm(gini ~ 1+foreign_inv, data=welfare)
screenreg(model_2)
screenreg(model_2,
          custom.model.names = "Model 2",
          custom.coef.names = c("Constant", "Foreign Direct Investment"))

#5.3 Multivariate model
welfare_no_na <- welfare %>%
  drop_na(gini, education_budget, foreign_inv, health_budget,
          socialsec_budget, population, sector_dualism, ethnic_diversity,
          gdp, regime_type, legislative_bal)

model_3 <- lm(gini ~ 1 + education_budget + foreign_inv + health_budget +
                socialsec_budget + population + sector_dualism +
                ethnic_diversity + gdp + factor(regime_type)+
                legislative_bal,
              data=welfare_no_na)
screenreg(model_3)
models <- list(model_1, model_2, model_3)
screenreg(models,
          custom.model.names = c("Model 1", "Model 2", "Model 3"),
          custom.coef.names = c(
            "Constant", "Education expenditure", "FDI",
            "Health expenditure", "Social sec. expenditure",
            "Young population", "Dualism in the economy",
            "Ethnic division", "pc GDP", "Democratic.reg", "Mixed.reg",
            "Authoritarian.reg", "Balance between powers"
          ))

model_2_restricted <- lm(gini ~ 1 + education_budget + ethnic_diversity,
                         data = welfare_no_na)
screenreg(model_2_restricted)
pred_model_2_restricted <- as_tibble(prediction(model_2_restricted))

ggplot(data=pred_model_2_restricted) + #the new predicted values
  geom_point(mapping = aes (x=education_budget, y = gini,
                            color = factor(ethnic_diversity)))+
  geom_line(mapping = aes(x=education_budget, y = fitted,
                          color = factor(ethnic_diversity),
                          group = factor(ethnic_diversity)))+
  labs(x="Education Expenditure", y = "Inequality",
       color = "Ethnic division")

model_3_restricted <- lm(gini ~ 1+ education_budget + foreign_inv +
                           health_budget + socialsec_budget +
                           population + sector_dualism + gdp,
                         data = welfare_no_na)
anova(model_3, model_3_restricted)

#interpretation:
#level-level: if we increase x by 1 unit, we expect change of B1 unit on y
#log-level: if we increase x by 1 unit, we expect y to change by 100*B1%
#level-log: if we increase x by 1%, we expect a change of (B1/100) units on y
#log-log: if we increase x by 1%, we expect y to change by B1%

model_1_log <- lm(log(gini) ~ 1+education_budget, data=welfare)
screenreg(model_1_log)
#ceteris paribus = other things being equal 
crPlots(model_1)

#Ramsey's RESET Test
resettest(model_1, power = 2, type = "fitted", data = welfare_no_na)
#the result, p-val = 0.004 indicates that adding a quadratic will improve the fit of estimation

#multicollinearity
corr_selected <- welfare %>%
  select(gini, education_budget, sector_dualism, foreign_inv, gdp,
         ethnic_diversity, regime_type, health_budget, socialsec_budget,
         legislative_bal, population) %>%
  cor(use="pairwise") %>%
  round(1)

ggcorrplot(corr_selected, type = "lower", lab=T, show.legend = F)

#to detect if multicollinearity is a problem,
#necessary to perform a Variance Inflation Factors test
vif(model_3)
#if the GVIF score is higher than 2 there is a multicollinearity issue
sqrt(vif(model_3))>2

#homoskedasticity
#Breush-Pagan
bptest(model_3, studentize = T)
#several ways to reinforce the errors
model_3_robust_3 <- coeftest(model_3, vcov=vcovHC(model_3, "HC3"))
model_3_robust_1 <- coeftest(model_3, vcov=vcovHC(model_3, "HC1"))
model_3_robust_0 <- coeftest(model_3, vcov=vcovHC(model_3, "HC0"))

models_robust <- list(model_3, model_3_robust_0,
                      model_3_robust_1, model_3_robust_3)


screenreg(models_robust,
          custom.model.names = c("w/0 robust SE",
                                 "robust HCO", "robust HC1", "robust HC3"))

#error variance associated to clusters 
#this can be the Computer Vision problem! Some areas would have higher error
#than other circles, hence error is dependent on the region 
ggplot(welfare_no_na, aes(education_budget, gini))+
  geom_point()+
  facet_wrap(~country_id)
#will use lm.cluster command - this command clusters the standard errors 
#according to the indicated cluster variable 

model_3_cluster <- miceadds::lm.cluster(
  data= welfare_no_na,
  formula= gini ~1+ education_budget + sector_dualism + foreign_inv+
    gdp+ ethnic_diversity + regime_type + health_budget +
    socialsec_budget + legislative_bal,
  cluster = "country_id"
)

summary(model_3_cluster)

#5.6.6 Normality in the error distribution
# Best Linear Unbiased Parameter BLUE
# it is necessary to assume that the coefficient follows a T-Student distribution
qqPlot(model_3$residuals, col.lines="black")
#I honestly don't understand this one
library(ggpubr)
ggdensity(model_3$residuals, main = "Density plot of the residuals")
