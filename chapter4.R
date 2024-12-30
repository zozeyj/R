#Chapter 4
#Use the shortcut Ctrl + Shift + F10 --> clear environment

#4.3 files separated by delimiters
#base R: utils can use read.table() - have some drawbacks 

library(tidyverse)
library(readr)
library(dplyr)
library(haven) # used to load value label with labels (ex marital status)
library(readxl) #read excelfile 
library(tidyr)

#check environment panel of R studio - load different types of df
df_desiguales_rds <- readRDS("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.rds")
df_desiguales_cvs <- read_csv("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.csv")
load("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.Rdata")
df_cead_excel <- read_excel("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/cead.xls")
df_cead_excel_v2 <- read_excel("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/cead.xls",
                            skip = 18)#tell R to skip first 18 rows 
df_cead_excel_v3 <- read_excel("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/cead.xls",
                            range = "A20:G81") 

#check the list of the created or loaded objects
ls()

#confirm that this file is in the dataframe and tibble format 
#it is useful to work with tidyverse tools 
class(df_desiguales_cvs)
class(df_cead_excel_v3)

#explore the data 
df_desiguales_cvs %>% select(1:10) %>% glimpse()
df_cead_excel %>% glimpse()

#data sets with labels (Stata - .dta & SPSS - .sav)
df_desiguales_spss <- read_spss("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.sav")
df_desiguales_stata <- read_stata("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.dta",
                                  encoding = "UTF-8")
ls()
class(df_desiguales_spss)
class(df_desiguales_stata)
#when dbl says only dbl it is numerical, but if it's dbl+lbl then it is value
df_desiguales_spss %>% select(1:10) %>% glimpse()
#the result says "labelled double"
head(df_desiguales_stata$p2)
#simple summary of the first two variables 
df_desiguales_stata%>% select(region,p2)

#basic changes to the CEAD dataset:
names(df_cead_excel_v3) #we want wide dataset (year in vertical line not horizontal)
df_cead_excel_v4 <- df_cead_excel_v3 %>%
  rename(county = `...1`) %>%
  pivot_longer (cols = -county, names_to = "year", values_to = "n_crime") %>%
  filter(county != "Unidad Territorial")

#what if the excel file has multiple sheets?
df_sinim_excel <- read_excel("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/sinim.xls",
                             sheet=2, skip=2, na ="Not received")
#using na we tell the program what other phrases has to be listed as NA

names(df_sinim_excel)
install.packages("janitor") #tools to clean excel
library(janitor)

df_sinim_excel_v2 <- df_sinim_excel %>% janitor::clean_names()
names(df_sinim_excel_v2)

#4.4 large tabular datasets
#load packages
library(tidyverse)
library(readr)
library(dplyr)
library(haven) # used to load value label with labels (ex marital status)
library(readxl) #read excelfile 
library(tidyr)
library(janitor)
library(politicalds) #needed to select variable

df_desiguales_large_100 <- read_csv("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.csv"
                                    , n_max = 100) #observe first one hundred observations 
df_desiguales_large_100 %>% glimpse()
df_desiguales_load_2vars <- read_csv("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.csv",
                                     col_types = cols_only_chr(c("edad", "p2")))
library(data.table)
df_desiguales_large_fread <- fread("C:/Users/yeji/Desktop/R Practice/data_load_politicalds/data_load_politicalds/data/desiguales.csv")
class(df_desiguales_large_fread)
#data table is computationally more efficient, but less intuitive and legible 
library(ff)

