object_1 <- 2+2
2+2
object_1

object_1 <- "democracy"
object_1

vector_1 <- c(15, 10, 20)
vector_1

vector_2 <- c(9, 7:10, 2, 14)
vector_2
vector_2[2]
vector_2[4:6]

2+ sqrt(25) - log(1)
mean(vector_1)
median(vector_1)
sd(vector_1)
length(vector_1)
sort(vector_1)
sort(vector_1, decreasing= TRUE)

vector_1_with_na <- c(vector_1, NA)
vector_1_with_na
mean(vector_1_with_na, na.rm = TRUE)
na.omit(vector_1_with_na)
is.na(vector_1_with_na)

install.packages("tidyverse")
library(tidyverse)
install.packages("remotes")
library(remotes)
install_github("arcruz0/politicalds")
library(politicalds)

install.packages("ggparliament")
install_github("zmeers/ggparliament")
install.packages("skimr")
library(skimr)