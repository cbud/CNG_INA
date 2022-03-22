library(tidyverse)
library(plot3D)
Output<-readRDS( "~/Sleeper Weeds/Large_model1in10.rds")

#get data into format
jt2<-Output$multout

library(plot3D)
p2<-plot3D::scatter3D(
  x = jt2$probadoptmean,
  y = jt2$maneffmean,
  z = jt2$mestab*1830,
  pch = 16,
  xlab = 'Mean prob adoption',
  ylab = 'Mean man effect',
  zlab = 'No. of farms established',
  main = "Spread in possible 1830 farms",
  bty = 'b2',
  type = 'h'
)

plot(
  jt2$maneffmean,
  jt2$mestab,
  xlab = 'Mean management effect size',
  ylab = 'Proportion nodes with invasive established',
  ylim = c(0, 1),
  col = 'red',
  pch = 16
)
lines(jt2$maneffmean, jt2$mestab, col = 'red')
# also indicate the 95th percentile
lines(jt2$maneffmean, jt2$estab95, col='red', lty=2)
# also indicate the 5th percentile
lines(jt2$maneffmean, jt2$estab5, col='red', lty=2)

jt2<-as_tibble(jt2)

#rate of establishment with management effectiveness
jt2 %>% 
  ggplot(aes(x=maneffmean, y=mestab*1830))+geom_jitter(color="blue")+
  geom_smooth(method = "loess", se = F,formula = (y ~ (1/x)), span = 2)+ geom_point(aes(x=maneffmean, y=estab95*1830), color="red")+
  geom_smooth(aes(x=maneffmean, y=estab95*1830),method = "loess", se = F,formula = (y ~ (1/x)), span = 2, color="red")+
  xlab("Simulated management effect mean (sd=0.2)")+ylab("Number of farms infected after 60 time-steps")

#rate of establishment with adoption rate
jt2 %>% 
  ggplot(aes(x=probadoptmean, y=mestab*1830))+geom_point(color="blue")+
  geom_smooth(method = "loess", se = F,formula = (y ~ (1/x)), span = 2)+ geom_point(aes(x=probadoptmean, y=estab95*1830), color="red")+
  geom_smooth(aes(x=probadoptmean, y=estab95*1830),method = "loess", se = F,formula = (y ~ (1/x)), span = 2, color="red")+
  xlab("Simulated mean probability of adoption (sd=0.2)")+ylab("Number of farms infected after 60 time-steps")
