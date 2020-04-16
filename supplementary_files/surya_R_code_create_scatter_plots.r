# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(Cairo)  # v1.5.10
library(ggplot2)  # v3.2.1
library(ggthemes)  # v4.2.0
library(htmlwidgets)  # v1.5.1
library(plotly)  # v4.9.1
library(svglite)  # v1.2.2


# Load and prepare data ----
dat <- read.table("surya_BayesTraits_data_path_lengths_nodes.txt", sep = "\t")
colnames(dat) <- c("genome", "path", "node")
location <- dat$genome
location <- gsub("/.*", "", location)
# Next time, use the metadata file!
# table(location)
region <- gsub("Algeria", "Africa", location)
region <- gsub("Anhui", "Asia", region)
region <- gsub("Argentina", "South America", region)
region <- gsub("Australia", "Oceania", region)
region <- gsub("Austria", "Europe", region)
region <- gsub("Beijing", "Asia", region)
region <- gsub("Belgium", "Europe", region)
region <- gsub("Brazil", "South America", region)
region <- gsub("Cambodia", "Asia", region)
region <- gsub("Canada", "North America", region)
region <- gsub("canine", "Asia", region)
region <- gsub("Chile", "South America", region)
region <- gsub("China", "Asia", region)
region <- gsub("Chongqing", "Asia", region)
region <- gsub("Colombia", "South America", region)
region <- gsub("CzechRepublic", "Europe", region)
region <- gsub("Denmark", "Europe", region)
region <- gsub("DRC", "Africa", region)
region <- gsub("Ecuador", "South America", region)
region <- gsub("England", "Europe", region)
region <- gsub("Finland", "Europe", region)
region <- gsub("Foshan", "Asia", region)
region <- gsub("France", "Europe", region)
region <- gsub("Fujian", "Asia", region)
region <- gsub("Fuyang", "Asia", region)
region <- gsub("Ganzhou", "Asia", region)
region <- gsub("Georgia", "Europe", region)
region <- gsub("Germany", "Europe", region)
region <- gsub("Ghana", "Africa", region)
region <- gsub("Greece", "Europe", region)
region <- gsub("Guangdong", "Asia", region)
region <- gsub("Guangzhou", "Asia", region)
region <- gsub("Hangzhou", "Asia", region)
region <- gsub("HongKong", "Asia", region)
region <- gsub("Hungary", "Europe", region)
region <- gsub("Iceland", "Europe", region)
region <- gsub("India", "Asia", region)
region <- gsub("Ireland", "Europe", region)
region <- gsub("Israel", "Asia", region)
region <- gsub("Italy", "Europe", region)
region <- gsub("Japan", "Asia", region)
region <- gsub("Jiangsu", "Asia", region)
region <- gsub("Jiangxi", "Asia", region)
region <- gsub("Jiujiang", "Asia", region)
region <- gsub("Jian", "Asia", region)
region <- gsub("Korea", "Asia", region)
region <- gsub("Kuwait", "Asia", region)
region <- gsub("Luxembourg", "Europe", region)
region <- gsub("Malaysia", "Asia", region)
region <- gsub("Mexico", "North America", region)
region <- gsub("Nanchang", "Asia", region)
region <- gsub("NanChang", "Asia", region)
region <- gsub("Nepal", "Asia", region)
region <- gsub("Netherlands", "Europe", region)
region <- gsub("EuropeL", "Europe", region)
region <- gsub("NewZealand", "Oceania", region)
region <- gsub("Nigeria", "Africa", region)
region <- gsub("Nonthaburi", "Asia", region)
region <- gsub("NorthernEurope", "Europe", region)
region <- gsub("Norway", "Europe", region)
region <- gsub("Pakistan", "Asia", region)
region <- gsub("Panama", "North America", region)
region <- gsub("Peru", "South America", region)
region <- gsub("Pingxiang", "Asia", region)
region <- gsub("Poland", "Europe", region)
region <- gsub("Portugal", "Europe", region)
region <- gsub("Russia", "Europe", region)
region <- gsub("SaudiArabia", "Asia", region)
region <- gsub("Scotland", "Europe", region)
region <- gsub("Senegal", "Africa", region)
region <- gsub("Shandong", "Asia", region)
region <- gsub("Shanghai", "Asia", region)
region <- gsub("Shangrao", "Asia", region)
region <- gsub("Shenzhen", "Asia", region)
region <- gsub("Sichuan", "Asia", region)
region <- gsub("Singapore", "Asia", region)
region <- gsub("Slovakia", "Europe", region)
region <- gsub("Slovenia", "Europe", region)
region <- gsub("SouthAfrica", "Africa", region)
region <- gsub("SouthAsia", "Asia", region)
region <- gsub("Spain", "Europe", region)
region <- gsub("Sweden", "Europe", region)
region <- gsub("Switzerland", "Europe", region)
region <- gsub("Taiwan", "Asia", region)
region <- gsub("Thailand", "Asia", region)
region <- gsub("Tianmen", "Asia", region)
region <- gsub("Turkey", "Europe", region)
region <- gsub("USA", "North America", region)
region <- gsub("Vietnam", "Asia", region)
region <- gsub("Wales", "Europe", region)
region <- gsub("Wuhan-Hu-1", "Asia", region)
region <- gsub("Wuhan", "Asia", region)
region <- gsub("Xinyu", "Asia", region)
region <- gsub("Yunnan", "Asia", region)
region <- gsub("Zhejiang", "Asia", region)
# table(region)
dat <- cbind(dat, region)

# Plot scatter plots ----
scatter_plot <-
  ggplot(dat, aes(node, path)) +
    geom_point(color = "gray") +
    geom_segment(
      x = min(dat$node),
      xend = max(dat$node),
      y = 7.123483712113 + 0.008430464495*min(dat$node),
      yend = 7.123483712113 + 0.008430464495*max(dat$node),
      color = "black",
      size = 1
    ) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL
    )
scatter_plot_region <-
  ggplot(dat, aes(node, path, color = region)) +
    geom_jitter(size = 0.75, height = 0.2, width = 0.2, alpha = 0.3) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(
      legend.direction = "vertical",
      legend.position = "right"
    ) +
    labs(
      subtitle = "Total Path Lengths (mutations)\n",
      x = "\nNumber of Nodes",
      y = NULL,
      color = NULL
    )
## Interactive plot
interactive_plot <-
  ggplot(dat, aes(node, path, color = region, label = genome)) +
    geom_jitter(height = 0.25, width = 0.25, alpha = 0.4) +
    theme_tufte(base_size = 12, base_family = "Arial", ticks = FALSE) +
    theme(legend.title = element_blank()) +
    labs(
      x = "Number of Nodes",
      y = "Total Path Lengths (mutations)"
    )
interactive_plot <- ggplotly(interactive_plot)

# Save scatter plots ----
CairoPDF("surya_figure_punctuation.pdf", width = 6.535, height = 4.039)
print(scatter_plot)
graphics.off()
CairoSVG("surya_figure_punctuation.svg", width = 6.535, height = 4.039)
print(scatter_plot)
graphics.off()
CairoPDF("surya_figure_punctuation_region.pdf", width = 6.535, height = 4.039)
print(scatter_plot_region)
graphics.off()
CairoSVG("surya_figure_punctuation_region.svg", width = 6.535, height = 4.039)
print(scatter_plot_region)
graphics.off()
## Interactive plot
saveWidget(
  widget = as_widget(interactive_plot),
  file = "surya_figure_punctuation_interactive.html"
)
