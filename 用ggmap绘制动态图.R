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

#读取数据(已经预处理过了的)
data1=read.csv(file="绘制动态图.csv")
data2=read.csv("weatherhz.csv")
data2=data2[which(data2$date>=20131021 & data2$date<=20131027),][1:7,]
data=merge(data1,data2,by="date")

thedate=20131021
thetimezone=24

#绘图函数
drawit=function(thedate,thetimezone)
{
  thedata=data[which(data$date==thedate),]
  thedata=thedata[which(thedata$timezone==thetimezone),]
  map=get_map(location=c(lon=median(data$经度),lat=median(data$纬度)), zoom = 11, maptype = "terrain", source = "google")
  ggmap(map)+geom_point(data=thedata,aes(x=经度,y=纬度,size=weight), alpha = 0.3)+annotate("text", x=120.3, y=30.1, label = paste(thedate,thetimezone),size=10,color="red")+annotate("text", x=120.3, y=30.15, label = paste("气温：",thedata$min_temp[1],"~",thedata$max_temp[1]," ",thedata$weather[1]),size=8,color="red")
  
}

drawit(20131021,24)

finaldraw=function(alldate,alltimezone){
  for (thisdate in alldate) {
    for (thistimezone in alltimezone) {
      print(drawit(thisdate,thistimezone))
    }
  }
}

alldate=20131021:20131023
alltimezone=1:48

oopts = ani.options(ffmpeg = "D:/ImageMagick/ImageMagick-6.9.3-Q16/ffmpeg.exe")
#Use the function from animation to make the final movie
saveVideo({
  finaldraw(alldate,alltimezone)
  ani.options(interval = 1, nmax = 230)
}, video.name = "Hangzhouall.mp4", other.opts = "-b 500k")
