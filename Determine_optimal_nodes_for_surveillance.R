# set up for smart_surv output

library(tidyverse)
library(ggraph)
library(igraph)
library(actuar)
library(INA)

#get the adjacency matrix for
adj<-readRDS("Inputs/farm2farm_probs.rds")
#get farm data with centroids for graphing
data<-read_csv("Inputs/Simple_points_for_INA.csv")

#make the network cutoff smaller than you planned - 1 in ten thousand probability of dispersal, set lower probabilities to zero.

length(adj[adj[]>0])
adj[adj < 1/10000]<-0

#This INA package function that can be used to determine the relative value of different nodes for surveillance and detection based on the spread of information/bioentities through the network.

surv_out<-smartsurv(adjmat = adj, stoch = F, nrealz=1)

#keep the output for later
saveRDS(surv_out, "~/Downloads/surv_out.rds") #can save as csv too

#Then graph the network and the depict the relative importance of each node

adj<-readRDS("Inputs/farm2farm_probs.rds")
length(adj[adj[]>0])
adj[adj < 1/10000]<-0

#create an igraph object from the adj matrix
net<-graph_from_adjacency_matrix(adj, mode="directed", weighted = TRUE, diag = F)
E(net)$weight
layout<-create_layout(net, layout = "kk")

#Get node importance from the smartsurv analysis

Node_impt<-colMeans(surv_out$meanarr)

#replace the x y coordinates from the default layout with lat long data for farm centroids.

layout$x<-data$X
layout$y<-data$Y

#Add the smart surveillance point values to the network object with layout

layout$smart<-Node_impt


#graph the layout 

ggraph(layout) + 
  geom_edge_link(aes(color=weight, width=weight), alpha=0.25, show.legend = F) + 
  geom_node_point(aes(color=smart, size=smart)  )+
  scale_color_viridis_c(breaks=c(300, 600, 900, 1200))+
  scale_edge_width(range = c(0, 0.3), guide="none")+
  scale_size_continuous(range = c(0, 3), breaks=c(300, 600, 900, 1200, 1500))+guides(size=guide_legend("Uninfested nodes \nat detection"), 
                                                                                     color=guide_legend("Uninfested nodes \nat detection"))

ggsave("uninfested nodes at detection.jpg", width=11, height=11)


