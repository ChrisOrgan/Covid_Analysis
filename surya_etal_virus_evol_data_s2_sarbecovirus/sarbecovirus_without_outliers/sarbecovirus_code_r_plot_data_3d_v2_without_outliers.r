# Written by Kevin Surya.
# This code is part of the coronavirus-evolution project.


library(htmlwidgets)
library(plotly)


# Read data ----
dat <- read.table(
  "sarbecovirus_data_v2_without_outliers.txt",
  sep = "\t",
  header = TRUE
)

# Plot data in a 3D format ----
plot_3d <- plot_ly(
  data = dat,
  x = ~time,
  y = ~node,
  z = ~path,
  text = ~genome,
  color = ~node,
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

# Save plot ----
saveWidget(
  widget = as_widget(plot_3d),
  file = "sarbecovirus_figure_data_3d_v2_without_outliers.html"
)
