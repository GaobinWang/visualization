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

#读取数据
data2=read.csv(file="路径图.csv")

#数据预处理
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
ggsave("路径图.png", p, h = 4, w = 8, type = "cairo-png")
