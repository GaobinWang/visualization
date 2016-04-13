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


#画出各个站点的交易频繁程度
#交易表中的站点有经纬度的站点有2365个,简单的分析可知大的站点基本上都有经纬度数据
data1=merge(LonLat,data1,by="站点编号")
data1=data1[,c("站点编号","纬度","经度","权重")]
data1=data1[which(data1$纬度<90),]
lat=c(min(data1$纬度),max(data1$纬度))
lon=c(min(data1$经度),max(data1$经度))
center = c(lat = mean(lat), lon = mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))

#zoom=11
map=get_map(location=c(lon=median(data1$经度),lat=median(data1$纬度)), zoom = 11, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data1,aes(x=经度,y=纬度,size=权重), alpha = 0.3))

#zoom=11,color="red"
map=get_map(location=c(lon=median(data1$经度),lat=median(data1$纬度)), zoom = 11, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data1,aes(x=经度,y=纬度,size=权重,color="red"), alpha = 0.3))

#zoom=12
map=get_map(location=c(lon=median(data1$经度),lat=median(data1$纬度)), zoom = 12, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data1,aes(x=经度,y=纬度,size=权重), alpha = 0.3))

#zoom=12,color="red"
map=get_map(location=c(lon=median(data1$经度),lat=median(data1$纬度)), zoom = 12, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data1,aes(x=经度,y=纬度,size=权重,color="red"), alpha = 0.3))


#画出各个站点的工作频繁程度
data2=merge(LonLat,data2,by="站点编号")
data2=data2[,c("站点编号","纬度","经度","权重")]
data1=data1[which(data1$纬度<90),]
lat=c(min(data1$纬度),max(data1$纬度))
lon=c(min(data1$经度),max(data1$经度))
center = c(lat = mean(lat), lon = mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))

#zoom=12
map=get_map(location=c(lon=median(data2$经度),lat=median(data2$纬度)), zoom = 12, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data2,aes(x=经度,y=纬度,size=权重), alpha = 0.3))


#选择出1053站点来进行分析(龙翔桥站点)
#画出该站点
data=LonLat[which(LonLat$站点编号==1053),]
map=get_map(location=c(lon=median(data$经度),lat=median(data$纬度)), zoom = 13, maptype = "terrain", source = "google")
print(ggmap(map)+geom_point(data=data,aes(x=经度,y=纬度,color="red"), alpha = 0.3))


#newwork map(2059站点)
#数据预处理1
start=LonLat[which(LonLat$站点编号==2059),]
start=start[,c("经度","纬度")]
colnames(start)=c("出发站点经度","出发站点纬度")

data=read.table(file="plotdata.txt",header=T)
#data=data[order(data$weight,decreasing = T),]
data=data[,2:3]
colnames(data)=c("站点编号","权重")
data=data[which(data$站点编号!=2059),]
data=merge(LonLat,data,by="站点编号")
data=data[,c("站点编号","经度","纬度","权重")]
data=data[order(data$权重,decreasing = T),]
data=data[,2:4]
colnames(data)=c("到达站点经度","到达站点纬度","权重")
data=data[1:100,]
data[,4:5]=start
data=data[,c("出发站点经度","出发站点纬度","到达站点经度","到达站点纬度","权重")]

#数据预处理2
pointsDf=data[,3:5]
colnames(pointsDf)[3]="权重2"
edgesDf=data

#画出路径图
edgeMaker <- function(whichRow, len = 1, curved = TRUE){
  fromC <- c(edgesDf[whichRow,1],edgesDf[whichRow,2])  # Origin
  toC <- c(edgesDf[whichRow,3],edgesDf[whichRow,4]) # Terminus
  weight <- edgesDf[whichRow, 5]  # Terminus
  
  # Add curve:
  graphCenter <- c(median(edgesDf$到达站点经度),median(edgesDf$到达站点纬度))
  bezierMid <- c(fromC[1], toC[2])  # A midpoint, for bended edges
  distance1 <- sum((graphCenter - bezierMid)^2)
  if(distance1 < sum((graphCenter - c(toC[1], fromC[2]))^2)){
    bezierMid <- c(toC[1], fromC[2])
  }  # To select the best Bezier midpoint
  bezierMid <- (fromC + toC + bezierMid) / 3  # Moderate the Bezier midpoint
  if(curved == FALSE){bezierMid <- (fromC + toC) / 2}  # Remove the curve
  
  edge <- data.frame(bezier(c(fromC[1], bezierMid[1], toC[1]),  # Generate
                            c(fromC[2], bezierMid[2], toC[2]),  # X & y
                            evaluation = len))  # Bezier path coordinates
  edge$Sequence <- 1:len  # For size and colour weighting in plot
  edge$weight <- weight
  edge$Group <- whichRow
  return(edge)
}
allEdges <- lapply(1:nrow(edgesDf), edgeMaker, len = 10, curved = TRUE)
allEdges <- do.call(rbind, allEdges)  # a fine-grained path ^, with bend ^

#画图
new_theme_empty <- theme_bw()
new_theme_empty$line <- element_blank()
new_theme_empty$rect <- element_blank()
new_theme_empty$strip.text <- element_blank()
new_theme_empty$axis.text <- element_blank()
new_theme_empty$axis.title <- element_blank()
new_theme_empty$legend <- element_blank()
new_theme_empty$plot.margin <- structure(c(0, 0, 0, -1), unit = "lines",valid.unit = 3L, class = "unit")
map=get_map(location=c(median(edgesDf$到达站点经度),median(edgesDf$到达站点纬度)),zoom=14,maptype="terrain")
p=ggmap(map)
p=p+geom_path(data=allEdges, aes(x = x, y = y,group = Group,size=(weight-1),colour=Sequence),alpha=0.6)  # and taper
p=p+geom_point(data = data.frame(pointsDf),aes(x=到达站点经度,y=到达站点纬度,size=权重2), pch = 21,colour = "black", fill = "red2")  # Customize gradient 
p <- p + scale_colour_gradient(low = "red3", high = "white", guide = "none")
p <- p + scale_size(range = c(.6, 5), guide = "none")  # Customize taper
p <- p + new_theme_empty  # Clean up plot
print(p)
ggsave("latestImage.png", p, h = 4, w = 8, type = "cairo-png")


###画动态图
library(RODBC)
ch=odbcConnect("bicycledata","root","123")
data=sqlQuery(ch,"select rent_netid,tran_date,`index`, weight from result3")
colnames(data)=c("站点编号","date","timezone","weight")
data=merge(LonLat,data,by="站点编号")
data=data[,c("站点编号","date","timezone","经度","纬度","weight")]
#colnames(data)=c("rent_netid","date","timezone","lon","lat","weight")


thedate=20131021
thetimezone=24

drawit=function(thedate,thetimezone)
{
  #ind=which(data$date==thedate&&data$timezone==thetimezone)
  #thedata=data[ind,]
  thedata=data[which(data$date==thedate),]
  thedata=thedata[which(thedata$timezone==thetimezone),]
  map=get_map(location=c(lon=median(data$经度),lat=median(data$纬度)), zoom = 11, maptype = "terrain", source = "google")
  ggmap(map)+geom_point(data=thedata,aes(x=经度,y=纬度,size=weight), alpha = 0.3)+annotate("text", x=120.2, y=30.15, label = paste(thedate,thetimezone),size=10,color="red")+annotate("text", x=120.3, y=30.4, label = "天气情况",size=10,color="red")
  
}

drawit(20131021,24)

finaldraw=function(alldate,alltimezone){
  for (thisdate in alldate) {
    for (thistimezone in alltimezone) {
      print(drawit(thisdate,thistimezone))
    }
  }
}

alldate=order(unique(data$date))
alltimezone=order(unique(data$timezone))
alldate=20131021:20131027
alldate=20131021

alltimezone=1:48

oopts = ani.options(ffmpeg = "D:/ImageMagick/ImageMagick-6.9.3-Q16/ffmpeg.exe")
#Use the function from animation to make the final movie
saveVideo({
  finaldraw(alldate,alltimezone)
  ani.options(interval = .1, nmax = 230)
}, video.name = "Hangzhouall.mp4", other.opts = "-b 500k")
