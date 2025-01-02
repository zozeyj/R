#Data Visualization 1
library(readr)
SCAD2018Africa_Final <- read_csv("SCAD2018Africa_Final.csv")
View(SCAD2018Africa_Final)

library(ggplot2)
ggplot(data= SCAD2018Africa_Final,
       mapping = aes(x=duration,
                     y=ndeath))+

  geom_point(alpha=0.3, shape=16)+
  xlim(0,250)+
  ylim(0,500)+
  
  geom_smooth(method="loess", se = FALSE, formula = y~x, color="gray")+

labs(title="DURATION OF CONFLITS AND NUMBER OF DEATHS", 
     subtitle = "1964-2017 African Countries") +
  xlab("Duration of Conflict") +
  ylab("Number of Deaths")+
  labs(caption = "Source: SCAD 2018 Africa | Yeji KIM")
  
