#Data Visualization Replication 1
#goal - does murder and burglary go together by State?

library(readxl)
library(ggplot2)
ggplot(data = crimeRatesByState2005,
       mapping = aes(x= murder,
                     y=burglary))+
  geom_smooth(method ="loess",
              color = "blue", se= FALSE)+
  geom_point(alpha=0.2,color = "blue")+
  scale_x_continuous(breaks =c(0,2.5,5,7.5,10)) +
  xlim(0,10)+
  
labs(title =
       paste("MURDERS VERSUS BURGLARIES IN THE UNITED STATES"),
    subtitle =
      paste("States with higher murder rates tend to have higer burglary rates"),
    caption = "Source: U.S. Census Bureau | Nathan Yau",
    x="Murders per 100,000 population", 
    y="Burglaries per 100,000 population") 


