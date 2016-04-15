#!/usr/bin/Rscript
#设置默认工作路径
setwd("C:\\Users\\Administrator\\Desktop\\wgb\\github_code\\visualization")
#加载相应的包
library(lubridate)
library(ggplot2)
library(RgoogleMaps)
library(ggmap)
library(mapproj)
library(plyr)
library(sna)
library(Hmisc)
library(animation)

#绘制各个站点的交易频繁度
data1=read.csv(file = "各站点交易频繁程度.csv")
lat=c(min(data1$纬度),max(data1$纬度))
lon=c(min(data1$经度),max(data1$经度))
center = c(lat = mean(lat), lon = mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))
map=get_map(location=c(lon=median(data1$经度),lat=median(data1$纬度)), zoom = 11, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data1,aes(x=经度,y=纬度,size=权重,color="red"), alpha = 0.3))


#画出各个站点的工作频繁程度
data1=read.csv(file = "各站点工作频繁程度.csv")
lat=c(min(data1$纬度),max(data1$纬度))
lon=c(min(data1$经度),max(data1$经度))
center = c(lat = mean(lat), lon = mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))
map=get_map(location=c(lon=median(data2$经度),lat=median(data2$纬度)), zoom = 11, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data2,aes(x=经度,y=纬度,size=权重), alpha = 0.3))
