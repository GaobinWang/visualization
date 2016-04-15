#!/usr/bin/Rscript
#设置默认工作路径
setwd("C:\\Users\\Administrator\\Desktop\\wgb\\3，师门讨论班材料\\杭州公共自行车项目\\第二次给的数据（20160311韩博文同学）")
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


#读取数据
#经纬度数据
#ps:共记录了2607个站点，其中168个站点的经纬度数据缺失
data=read.csv(file="经纬度.csv")
LonLat=data[,c("序号","站点编号","经度","纬度")]
colnames(LonLat)=c("序号","站点编号","纬度","经度")
LonLat=LonLat[complete.cases(LonLat),]

#交易数据
#PS:数据中有2881个站点
data1=read.table(file="tran_freq.txt",header = F)
colnames(data1)=c("站点编号","权重")
data1=data1[order(data1$权重,decreasing = T),]
data1$编号=1:nrow(data1)

#上下架数据
#ps:数据中有3131个站点
data2=read.table(file="sxj_freq.txt",header = F)
colnames(data2)=c("站点编号","权重")
data2=data2[order(data2$权重,decreasing = T),]
data2$编号=1:nrow(data2)



#输出数据1：各个站点的交易频繁程度的数据
data1=merge(LonLat,data1,by="站点编号")
data1=data1[,c("站点编号","纬度","经度","权重")]
data1=data1[which(data1$纬度<90),]
setwd("C:\\Users\\Administrator\\Desktop\\wgb\\github_code\\visualization")
write.csv(data1,file = "各站点交易频繁程度.csv",row.names=F)

#输出数据2：各个站点的工作频繁程度的数据
data2=merge(LonLat,data2,by="站点编号")
data2=data2[,c("站点编号","纬度","经度","权重")]
data1=data1[which(data1$纬度<90),]
write.csv(data1,file = "各站点工作频繁程度.csv",row.names=F)