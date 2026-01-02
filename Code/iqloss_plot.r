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
# Example code for plotting IQ loss related with sleep
# SSP585, 2100s

library(tidyverse)
library(sf)
library(readxl)
library(paletteer) 
library(scales)
library(ggflags)
library(ggplot2)
library(ggpubr)
library(ggsci)

IQ <- read_excel(":/data/IQ.xlsx")

# SSP585, 2100s, 
dd  = filter(IQ,IQ$ssp585_2100_ave !="NA",IQ$gdp !="NA")
dd$code <- tolower(dd$code)
dd$ssp585_2100_ave <- as.numeric(dd$ssp585_2100_ave)


q1 <- ggplot(dd, aes(x=gdp, y=ssp585_2100_ave)) + 
  theme_bw()+
  geom_flag(aes(country = code),size = 5) +
  geom_smooth(method = "lm",fill="#0000ff", alpha=0.2)+
  theme(legend.title = element_text(size = 15),legend.text = element_text(size = 12),
        axis.text = element_text(size = 12),title = element_text(size = 15), plot.title = element_text(hjust = 0.5) #title be center
        ,legend.position = "bottom",legend.key.height = unit(10, "pt"),
        legend.key.width = unit(70, "pt")) +
  theme(panel.border  = element_rect(color = "black",size = 1))+
  #theme(axis.title =  element_blank())+
  labs(x="GDP per capita", y = "IQ loss per capita")+
  scale_y_continuous(limits =  c(-.2,0.01),breaks = c(0,-0.05,-0.10,-0.15,-0.2))

#box-plot
q2 <- ggplot(dd, aes(x=subgroup1, y=ssp585_2100_ave))+
  theme_bw()+
  geom_boxplot(aes(fill=subgroup1),outlier.shape = NA,width = 0.3,size = 0.8,position = position_dodge(width = 0.5)) +
  geom_jitter(size = 2,width = 0.1,alpha = 0.5) +
  scale_y_continuous(limits =  c(-.2,0.01),breaks = c(0,-0.05,-0.10,-0.15,-0.2))+
  labs(x="Subgroup", y = "IQ loss per capita")+
  xlab(NULL)+
  theme(legend.title = element_text(size = 15),legend.text = element_text(size = 12),
        axis.text = element_text(size = 12),title = element_text(size = 15), plot.title = element_text(hjust = 0.5) #title be center
        ,legend.position = "bottom",legend.key.height = unit(10, "pt"),
        legend.key.width = unit(70, "pt")) +
  theme(panel.border  = element_blank(),axis.line = element_line(color = "black",size = 1))+
  theme(legend.position = "none")