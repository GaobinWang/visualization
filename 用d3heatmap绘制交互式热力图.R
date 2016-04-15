#使用d3heatmap包来绘制交互式的热力图
setwd("C:\\Users\\Administrator\\Desktop\\wgb\\github_code\\visualization")
library(d3heatmap)

#下载数据
url <- "http://datasets.flowingdata.com/ppg2008.csv"
nba_players <- read.csv(url, row.names = 1)
nba_players <- read.csv(file = "nba_players.csv",row.names = 1)

#绘制交互式热力图
d3heatmap(nba_players,scale = "column", dendrogram = "none",color = "Blues")

#显示聚类结果
d3heatmap(nba_players,scale = "column",color = "Blues")

#将聚类结果分类
d3heatmap(nba_players,Colv = F,scale = "column",color = "Blues",k_row = 6)
#ps:从聚类结果中可以看出：韦德 詹姆斯 科比 保罗 四人在同一类中；
#姚明 邓肯 奥尼尔三人在同一类中

