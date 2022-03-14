# set up for smart_surv output

library(tidyverse)
library(ggraph)
library(igraph)
library(actuar)

data<-read_csv("Inputs/Simple_points_for_INA.csv")
dist<-readRDS("Inputs/dist_mat_farm.rds")
smart_surv<-readRDS("Inputs/surv_out.rds")

#weibull

k= 7 #shape parameter
b= 500 #scale parameter
thresh= 1/20 #location parameter
d=seq(from=0, to=5000, by=1 )

#prob2<-k/b*(d/b)^(k-1)*exp(-(d/b)^k) #wikipedia
##prob2<-k/b*(d-c/b)^(k-1)*exp(- ((d-c)/b)^k) #https://www.itl.nist.gov/div898/handbook/eda/section3/eda3668.htm
#prob2<-k/b*((d/b)^(k-1))*exp ( - ((d/b)^k)) #https://www.sciencedirect.com/topics/engineering/weibull-probability-distribution

prob2<- thresh*ppareto(d, shape=k,  scale=b, lower.tail=F,log.p = F)

for_plot<-tibble(distance=d, probability=prob2, shape_par=k, scale_par=b, loc_par=c)

for_plot %>% 
ggplot(aes(x=distance, y=probability))+ geom_line()




