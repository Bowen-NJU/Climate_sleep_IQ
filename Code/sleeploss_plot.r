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
# Example code for plotting potential climate-related sleep loss
# SSP585, 2100s

library(tidyverse)
library(sf)
library(readxl)
library(paletteer) 
library(scales)
library(ggflags)
library(ggplot2)



map_path <-':/DATA/shp/ne_10m_admin_0_sovereignty/ne_10m_admin_0_sovereignty.shp'
line_1 <- st_read(map_path, stringsAsFactors=FALSE)

sleeploss_country <- read_excel(":/data/sleeploss_ssp.xlsx")


attach(line_1)
line_1$ssp585_2100 <- sleeploss_country$ssp585_2100

p1 <- ggplot(line_1) +
  theme_bw()  +
  geom_sf(color = NA, aes(fill = ssp585_2100), show.legend = TRUE,linetype = 1,
          lwd = 0.25)+
  coord_sf(xlim = c(-180,180),ylim=c(-60,90), expand = F) + 
  # ggtitle("") +
  scale_fill_paletteer_c(palette = "grDevices::Inferno",breaks=c(0,-4,-8,-12,-16,-20,-24),labels = c("0","4h","8h","12h","16h","20h","24h"),
                         direction = 1,limits = c(-24, 0),  oob = squish)+
  #,guide = guide_colorsteps())+
  labs(fill = "Sleep time loss (hour/year) ") + 
  theme(legend.title = element_text(size = 15),legend.text = element_text(size = 12),
        axis.text = element_text(size = 12),title = element_text(size = 15), plot.title = element_text(hjust = 0.5) #title be center
        ,legend.position = "bottom",legend.key.height = unit(10, "pt"),
        legend.key.width = unit(70, "pt")) +
  theme(panel.border  = element_rect(color = "black",size = 1))+
  theme(axis.text = element_blank(),axis.ticks=element_blank())

