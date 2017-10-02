###利用treemapify包画树状图
library(ggplot2)
library(treemapify)
library(tweenr)
library(gganimate)
library(RColorBrewer)
library(tweened)

#gganimate和tweened两个R包尚不能正确安装

#安装treemapify包之后，你的ggplot2中会多出一个树状图几何对象——geom_treemap()。
#R语言数据可视化之——TreeMap 

#预览数据集结构：

str(G20)
head(G20)

#画树状图
ggplot(G20, aes(area = gdp_mil_usd)) + geom_treemap()

#画树状图+颜色
ggplot(G20, aes(area = gdp_mil_usd)) + geom_treemap(fill="steelblue")

ggplot(G20, aes(area = gdp_mil_usd, fill = hdi)) + 
  geom_treemap()+
  scale_fill_distiller(palette="Greens")


#添加标签:geom_treemap_text
ggplot(G20, aes(area = gdp_mil_usd, fill = hdi, label = country)) +
  geom_treemap() +
  geom_treemap_text(fontface = "italic", colour = "red", place = "centre",grow = TRUE,alpha=.6)+
  scale_fill_distiller(palette="Greens")

#次级分组（亚群）
ggplot(G20, aes(area = gdp_mil_usd, fill = hdi, label = country,subgroup = region)) +
  geom_treemap() +
  geom_treemap_subgroup_border() +
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour ="black", fontface = "italic", min.size = 0) +
  geom_treemap_text(colour = "red", place = "topleft", reflow = T,alpha=.5)+
  scale_fill_distiller(palette="Greens")


#分面系统：
ggplot(G20, aes(area = gdp_mil_usd, fill = region, label = country)) +
  geom_treemap() +
  geom_treemap_text(grow = T, reflow = T, colour = "black") +
  facet_wrap( ~ econ_classification) +
  scale_fill_brewer(palette="Blues")+
  labs(title = "The G-20 major economies",
    caption = "The area of each country is proportional to its relative GDP within the economic group (advanced or developing)",
    fill = "Region" )+
  theme(legend.position = "bottom",
        plot.caption=element_text(hjust=0))

#GIF动画流
G20_alt <- G20
G20_alt$gdp_mil_usd <- sample(G20$gdp_mil_usd, nrow(G20))
G20_alt$hdi <- sample(G20$hdi, nrow(G20))
tweened <- tween_states(list(G20,G20_alt,G20), tweenlength = 8, statelength = 5, ease = 'cubic-in-out', nframes = 30)

animated_plot <- ggplot(tweened, aes(area = gdp_mil_usd, fill = hdi,label = country, subgroup = region,frame = .frame)) +
  geom_treemap(fixed = T) +
  geom_treemap_subgroup_border(fixed = T) +
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5,colour = "black", fontface = "italic", min.size = 0,fixed = T) +
  geom_treemap_text(colour = "white", place = "topleft", reflow = T, fixed = T)+
  scale_fill_distiller(palette="Greens")

ani.options(interval = 1/10)
gganimate(animated_plot, "E:/animated_treemap.gif", title_frame = F,ani.width = 1000, ani.height = 800)
