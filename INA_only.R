
library(INA)
library(tidyverse)
library(dplyr)


## ----load dataE-------------------------------------------------------------

data<-read_csv("Inputs/Simple_points_for_INA.csv")
adj<-readRDS("Inputs/farm2farm_probs.rds")
#dimnames(adj)<-NULL
class(data)
class(adj)



#big matrix version
dimnames(adj)<-NULL
geocoords2<-matrix(c(data$X, data$Y), byrow=F, ncol=2)
prob_est2<-as.vector(data$Probability_Estab)
prob_est2<-1-(1-prob_est2)*20/100
class(prob_est2)
initbio2<- rep(0, length(data$farm_id))
initbio2[2]<-1 #infested farm in Waipawa
class(initbio2)


## ----example----------------------------------------------------------------------


## ----example Large Matrix, error=TRUE, echo=TRUE--------------------------------------
CNGvLarge <-
  INAscene(
    nreals = 200,
    ntimesteps = 2022-1962,
    doplot = F,
    outputvol = "more",
    readgeocoords = T,
    geocoords = geocoords2,
    numnodes = NA,
    xrange = NA,
    yrange = NA,
    randgeo = F,
    readinitinfo = F,
    initinfo = NA, #initbio2,#
    initinfo.norp = 'prop',
    initinfo.n = NA,
    initinfo.p = 0.5,
    initinfo.dist = 'random',
    readinitbio = F,
    initbio = NA, #initbio2,
    initbio.norp = "num",
    initbio.n = c(1,2), #starts in 1 or 2 nodes
    initbio.p = NA,
    initbio.dist = "random",
    readseam = F,
    seam = NA,
    seamdist = 'random',
    seamrandp = 1,
    seampla = NA,
    seamplb = NA,
    readbpam = T,
    bpam = adj,
    bpamdist = F,
    bpamrandp = NA,
    bpampla = NA,
    bpamplb = NA,
    readprobadoptvec = F,
    probadoptvec = NA,
    probadoptmean = seq(from = 0, to = 1, by = 0.1),
    probadoptsd = 0.2,
    readprobestabvec = F,
    probestabvec = prob_est2,
    probestabmean = 1,
    probestabsd = 0.05,
    maneffdir = 'decrease_estab',
    maneffmean = seq(from = 0, to = 1, by = 0.1),
    maneffsd = 0.2,
    usethreshman = F,
    maneffthresh = NA,
    sampeffort = NA
  )


saveRDS(CNGvLarge, "~/LargeRunCNG.rds")
 




