#ggplot2绘图手册

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
#例子一：
#特性：图层(数据层和图像层)
#先将数据映射到第一层
p <- ggplot(diamonds, aes(carat, price, colour = cut))  #在加上图层之前无法显示
summary(p)
#添加第二层
p <- p + geom_point()
summary(p)
p <- p + geom_smooth()
summary(p)
#上面的信息告诉我们，p对象含有两层，第一层数据层描述了变量和映射方式，
#第二层是直方图对象（geom_histogram），geom表示几何对象，
#它是ggplot中重要的图层控制对象，因为它负责图形渲染的类型。

#每个geom对象都需要有数据输入，数据可以从第一层中自动读取，
#也可以在aes参数中直接设置。而且每个geom还默认搭配某种统计变换（stat），
#geom_histogram的默认统计变换是stat_bin。它负责对数据进行分组计数。


#例子二：
p <- ggplot(mpg,aes(hwy))
p <- p + geom_histogram(position = 'identity',alpha=0.5,aes(y = ..density..,fill = factor(year))) 
p <- p + stat_density(geom = 'line',position = 'identity',aes(colour = factor(year)))
p
#分面
p <- p + facet_grid(facets = . ~ year)
p

#位置调整与图层
#位置调整（Position adjustments）是针对同一图层内元素的位置进行微调的方法。
#它包括五种设置，分别是stack、dodge、fill、identity、jitter。




