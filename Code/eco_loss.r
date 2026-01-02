#####################################################
# Title: 
# 
# Year:
#
# Author: 
#
# Affiliation: 
#
#
# Example code for plotting potential economic loss
# 

library(tidyverse)
library(sf)
library(readxl)
library(paletteer) 
library(scales)
library(ggpubr)
library(ggplot2)


lost_ <- read_excel(":/data/Economicloss_R.xlsx")

p1 <- ggplot(lost_, aes(x = reorder(region,r) ,y = avetotal,fill = ssp)) +
  theme_bw()  +
  geom_bar(position=position_dodge(),stat = "identity")+
  coord_flip() +
  theme(axis.text = element_text(size = 12,face = "bold"),
        axis.title = element_text(size = 12,face = "bold"),
        legend.text = element_text(size = 12,face = "bold"),
        legend.title = element_blank(),
        legend.position = "bottom",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(x=NULL, y = "Relative economical loss (%)")+
  geom_errorbar(aes(ymin=lowtotal, ymax=hightotal),position=position_dodge(.9), width=.3,size=0.2)+
  scale_fill_manual(values = c("#FF1493", "#CCEDB1", "#41B7C4"),labels=c("SSP126", "SSP370", "SSP585"))+
  scale_y_continuous(expand=c(0,0),limits =  c(0,1.1),breaks = c(0,0.25,0.50,0.75,1.00),labels = c("0","0.25%","0.5%","0.75%","1.0%"))


p2 <- ggplot(lost_, aes(x = GDP_per_capita ,y = avetotal,fill = ssp)) +
  theme_bw()  +
  geom_bar(position=position_dodge(),stat = "identity")+
  theme(axis.text = element_text(size = 12,face = "bold"),
        axis.title = element_text(size = 12,face = "bold"),
        legend.text = element_text(size = 12,face = "bold"),
        legend.title = element_blank(),
        legend.position = "bottom",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(x="GDP per capita", y = "Relative economical loss (%)")+
  geom_errorbar(aes(ymin=lowtotal, ymax=hightotal),position=position_dodge(.9), width=.2,size=0.8)+
  scale_fill_manual(values = c("#FF1493", "#CCEDB1", "#41B7C4"))+
  scale_y_continuous(expand=c(0,0),limits =  c(0,.1),breaks = c(0,0.025,0.050,0.075,0.1),labels = c("0","0.25%","0.5%","0.75%","1.0%"))+
  scale_x_continuous(limits =  c(0.5,10.5),breaks = seq(from=1, to=10, by=1))

