#Leaflet
#Leaflet is a JavaScript library for creating dynamic maps that support
#panning and zooming along with  various annotations like markers, 
#polygons, and popups.
library(leaflet)
#example1
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map


#Dygraphs

#Dygraphs provides rich facilities for charting time-series data in 
#R and includes support for many interactive features including
#series/point highlighting, zooming, and panning.
library(dygraphs)
dygraph(nhtemp, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))


#Plotly (不知为何无法下载)
#Plotly  allows you to easily translate your ggplot2 graphics to an 
#interactive web-based version, and also provides bindings to the
#plotly.js graphing library.
library(plotly)
p <- ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")
ggplotly(p)



#rboken (不知为何无法安装)
#Bokeh is a visualization library that provides a flexible and 
#powerful declarative framework for creating web-based plots.
library(rbokeh)
figure(width = NULL, height = NULL) %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
            color = Species, glyph = Species,
            hover = list(Sepal.Length, Sepal.Width))


#Highcharter
#Highcharter provides a rich R interface to the popular Highcharts 
#JavaScript graphics library. Note that Highcharts is free for 
#non-commercial use but otherwise requires a license.
library(magrittr)
library(highcharter)
highchart() %>% 
  hc_title(text = "Scatter chart with size and color") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       mtcars$drat, mtcars$hp)


#visNetwork
#visNetwork provides an interface to the network visualization 
#capabilties of the vis.js library.
library(visNetwork)
nodes <- data.frame(id = 1:6, title = paste("node", 1:6), 
                    shape = c("dot", "square"),
                    size = 10:15, color = c("blue", "red"))
edges <- data.frame(from = 1:5, to = c(5, 4, 6, 3, 3))
visNetwork(nodes, edges) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)





#networkD3
#http://christophergandrud.github.io/networkD3/
#Creates D3 JavaScript network, tree, dendrogram, and Sankey graphs from R.
library(networkD3)
#example1:
data(MisLinks, MisNodes)
forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.4)
#example2:
#数据准备
src <- c("A", "A", "A", "A",
         "B", "B", "C", "C", "D")
target <- c("B", "C", "D", "J",
            "E", "F", "G", "H", "I")
networkData <- data.frame(src, target)
#画图
simpleNetwork(networkData)


#d3heatmap
#Interactive heatmaps with D3 including support for row/column 
#highlighting and zooming.
library(d3heatmap)
d3heatmap(mtcars, scale="column", colors="Blues")



#DataTables
#DataTables displays R matrices or data frames as interactive 
#HTML tables that support filtering, pagination, and sorting.
library(DT)
datatable(iris, options = list(pageLength = 5))



#threejs
#threejs includes a 3D scatterplot and 3D globe 
#(you can directly manipulate the scatterplot below with the mouse).
library(threejs)
z <- seq(-10, 10, 0.01)
x <- cos(z)
y <- sin(z)
scatterplot3js(x,y,z, color=rainbow(length(z)))


#DiagrammeR
#A tool for creating diagrams and flowcharts using Graphviz and Mermaid.
library(DiagrammeR)
grViz("
      digraph {
      layout = twopi
      node [shape = circle]
      A -> {B C D} 
      }")


#MetricsGraphics
#MetricsGraphics enables easy creation of D3 scatterplots, line charts, and histograms.
library(metricsgraphics)
mjs_plot(mtcars, x=wt, y=mpg) %>%
  mjs_point(color_accessor=carb, size_accessor=carb) %>%
  mjs_labs(x="Weight of Car", y="Miles per Gallon")

