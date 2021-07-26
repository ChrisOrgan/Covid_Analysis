# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(htmlwidgets)
library(plotly)


# Read data ----
dat <- read.table(
  "sars_cov_2_2021_march_data_12618.txt",
  sep = "\t",
  header = TRUE
)
dat$b117[dat$b117 == 0] <- "Other lineages"
dat$b117[dat$b117 == 1] <- "Lineage B.1.1.7"

# Plot data in a 3D format ----
plot_3d <- plot_ly(
  data = dat,
  x = ~time,
  y = ~node,
  z = ~path,
  color = ~node,
  text = ~genome,
  size = 1.25
)
plot_3d <- plot_3d %>%
  add_markers()
plot_3d <- plot_3d %>%
  layout(
    scene = list(
      xaxis = list(title = "Time"),
      yaxis = list(title = "Node count"),
      zaxis = list(title = "Root-to-tip divergence (subs/site)")
    )
  )
plot_3d_b117<- plot_ly(
  data = dat,
  x = ~time,
  y = ~node,
  z = ~path,
  color = ~b117,
  text = ~genome,
  size = 1.25
)
plot_3d_b117 <- plot_3d_b117 %>%
  add_markers()
plot_3d_b117 <- plot_3d_b117 %>%
  layout(
    scene = list(
      xaxis = list(title = "Time"),
      yaxis = list(title = "Node count"),
      zaxis = list(title = "Root-to-tip divergence (subs/site)")
    )
  )

# Save plot ----
saveWidget(
  widget = as_widget(plot_3d),
  file = "sars_cov_2_2021_march_figure_data_3d_12618.html"
)
saveWidget(
  widget = as_widget(plot_3d_b117),
  file = "sars_cov_2_2021_march_figure_data_3d_b117_12618.html"
)
