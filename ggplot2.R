#ggplot2绘图手册
setwd("C:\\Users\\Administrator\\Desktop\\wgb\\github_code\\visualization\\可视化报告")
#加载ggplot2,如果显示没有此包，则需自己安装，命令为：install.packages("ggplot2")
library(ggplot2)

#qplot的使用
#使用diamonds数据集
head(diamonds)
summary(diamonds)

#画散点图
qplot(carat,price,data=diamonds)
#设置变化颜色
qplot(carat,price,data=diamonds,colour=color)
#设置单一颜色
qplot(carat,price,data=diamonds,colour=I("red"))
#设置散点的形状
qplot(carat,price,data=diamonds,shape=cut)  
#设置散点透明度
qplot(carat,price,data=diamonds,alpha=I(1/10))
qplot(carat,price,data=diamonds,alpha=I(1))

#qplot的综合运用(尽可能多的用到ggplot2中的绘图参数)
qplot(carat,price,data=diamonds,colour=color,shape=cut,xlim = c(1,4),ylim = c(5000,15000),main = "qplot绘图",xlab = "x:caret",ylab="y:price")

#其他常见的图形
#直方图
qplot(price,data=diamonds,geom=c('histogram'),colour = I("darkgreen"), fill = I("white"))
#条形图
qplot(cut,data=diamonds,geom='bar',fill=cut)
#箱线图
qplot(cut,price/carat,data=diamonds,geom=c('boxplot'),alpha=I(0.5),colour=cut)
qplot(cut,price/carat,data=diamonds,geom=c('jitter','boxplot'),alpha=I(0.5),colour=cut)
#散点图
qplot(carat,price,data=diamonds,geom=c('point','smooth'),alpha=I(0.3),colour=cut,log='xy')
qplot(carat,price,data=diamonds,geom=c('point','smooth'),alpha=I(0.1),facets=cut~.)

#其他图形实例
qplot(displ, hwy, data = mpg, facets = . ~ year) + geom_smooth()
qplot(displ, hwy, data = mpg, colour = factor(cyl)) + geom_smooth(data = subset(mpg, cyl != 5), method = "lm")	



#ggplot函数
#ggplot函数的用法
p <- ggplot(diamonds, aes(carat, price, colour = cut))  #在加上图层之前无法显示
summary(p)
p
p <- p + geom_point()
summary(p)
p
p <- p + geom_smooth()
summary(p)
p

#修饰图形(添加标题，坐标轴名称，坐标轴范围，添加文本等)
p <- ggplot(diamonds, aes(carat, price, colour = cut))
p <- p + geom_point()
p <- p + geom_smooth()
#添加标题，x轴y轴的名称
p <- p+labs(title="我是标题",x="我是x轴名称",y="我是y轴名称")
#添加文本
p <- p+annotate("text", label = "我是图形当中的文本", x = 2, y = 10000, size = 8, colour = "red")
#限定坐标轴范围
p <- p+xlim(0,4)+ylim(0,15000)
#保存画出的图形
ggsave(file="output.pdf", width = 10, height = 6) 
ggsave(file="output.png", width = 10, height = 6)


#条形图&分面
p <- ggplot(mpg,aes(hwy))
p <- p + geom_histogram(position = 'identity',alpha=0.5,aes(y = ..density..,fill = factor(year))) 
p <- p + stat_density(geom = 'line',position = 'identity',aes(colour = factor(year)))
p
#分面
p <- p + facet_grid(facets = . ~ year)
p


#位置调整与图层
with(mpg,table(class,year))
p <- ggplot(data=mpg,aes(x=class,fill=factor(year)))
p + geom_bar(position='dodge')
p + geom_bar(position='stack')
p + geom_bar(position='fill')
p + geom_bar(position='identity',alpha=0.3)

#条形图&修饰&添加文本
y=c(1.1,1.8,2.5,3.6,3.1,2.7,1.9,-0.1,-3.5,3.0)
x=2001:2010
data=data.frame(x,y)
p=ggplot(data,aes(as.factor(x),y,fill=y))
p=p+geom_bar(stat="identity")
p=p+geom_abline(intercept = 0, slope = 0,size=1,colour='gray')
p=p+geom_text(aes(label=y),hjust=0.5, vjust=-0.5 )
p=p+scale_y_continuous(limits=c(-3.8,4.2))
p=p+labs(x='年份', y='GDP增长率%')+labs(title="美国GDP增长率")
p

#散点图&修饰&添加文本
p <- ggplot(mtcars, aes(x=wt, y=mpg,colour=factor(cyl),label=rownames(mtcars)))
p + geom_text(hjust=0,vjust=-1,alpha=0.8)+ geom_point(size=3,aes(shape=factor(cyl)))
