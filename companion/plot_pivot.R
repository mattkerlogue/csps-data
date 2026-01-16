library(ggplot2)

pivot_gdf <- tibble::tribble(
  ~rect_x , ~rect_xend , ~text_x , ~y , ~hjust , ~type      , ~content                           ,
  # original table
  -2.5    ,  1.5       ,  1.25   ,  1 , 1      , "header"   , "Measure"                          ,
   1.5    ,  2.5       ,  2      ,  1 , 0.5    , "year1"    , "2009"                             ,
   2.5    ,  3.5       ,  3      ,  1 , 0.5    , "year2"    , "2010"                             ,
  -2.5    ,  1.5       ,  1.25   ,  2 , 1      , "measure1" , "Employee engagement\nindex"       ,
   1.5    ,  2.5       ,  2      ,  2 , 0.5    , "value"    , "58"                               ,
   2.5    ,  3.5       ,  3      ,  2 , 0.5    , "value"    , "56"                               ,
  -2.5    ,  1.5       ,  1.25   ,  3 , 1      , "measure2" , "B01. I am interested\nin my work" ,
   1.5    ,  2.5       ,  2      ,  3 , 0.5    , "value"    , "90"                               ,
   2.5    ,  3.5       ,  3      ,  3 , 0.5    , "value"    , "89"                               ,
   # pivoted table
  5.5    ,  9.5       ,  9.25   ,  1 , 1      , "header"   , "Measure"                          ,
   9.5    , 10.5       , 10      ,  1 , 0.5    , "header"   , "year"                             ,
  10.5    , 11.5       , 11      ,  1 , 0.5    , "header"   , "value"                            ,
   5.5    ,  9.5       ,  9.25   ,  2 , 1      , "measure1" , "Employee engagement\nindex"       ,
   5.5    ,  9.5       ,  9.25   ,  3 , 1      , "measure1" , "Employee engagement\nindex"       ,
   5.5    ,  9.5       ,  9.25   ,  4 , 1      , "measure2" , "B01. I am interested\nin my work" ,
   5.5    ,  9.5       ,  9.25   ,  5 , 1      , "measure2" , "B01. I am interested\nin my work" ,
   9.5    , 10.5       , 10      ,  2 , 0.5    , "year1"    , "2009"                             ,
   9.5    , 10.5       , 10      ,  3 , 0.5    , "year2"    , "2010"                             ,
   9.5    , 10.5       , 10      ,  4 , 0.5    , "year1"    , "2009"                             ,
   9.5    , 10.5       , 10      ,  5 , 0.5    , "year2"    , "2010"                             ,
  10.5    , 11.5       , 11      ,  2 , 0.5    , "value"    , "58"                               ,
  10.5    , 11.5       , 11      ,  3 , 0.5    , "value"    , "56"                               ,
  10.5    , 11.5       , 11      ,  4 , 0.5    , "value"    , "90"                               ,
  10.5    , 11.5       , 11      ,  5 , 0.5    , "value"    , "89"
)

pivot_plot <- ggplot(pivot_gdf, aes(y = y)) +
  geom_rect(
    aes(xmin = rect_x, xmax = rect_xend, height = 1, fill = type),
    colour = "#333333"
  ) +
  geom_text(
    aes(x = text_x, label = content, hjust = hjust),
    colour = "#000000",
    size = 3.25,
    family = "IBM Plex Sans"
  ) +
  annotate(
    "segment",
    x = 4,
    xend = 5,
    y = 1,
    linewidth = 2,
    colour = "#333333",
    arrow = arrow(),
  ) +
  scale_y_reverse() +
  scale_x_continuous(
    breaks = seq(-1, 11, 1)
  ) +
  scale_fill_manual(
    values = c(
      "header" = "#ffffff",
      "value" = "#ffffff",
      "year1" = "#ff7eb6",
      "year2" = "#ffd6e8",
      "measure1" = "#33b1ff",
      "measure2" = "#bae6ff"
    ),
    guide = guide_none()
  ) +
  labs(
    alt = paste(
      "Figure demonstrating the difference between 'wide' and 'long'",
      "format data"
    )
  ) +
  coord_fixed() +
  theme_void()

inlinesvg::svg_plot(
  pivot_plot,
  600,
  250,
  path = "companion/images/pivot_plot.svg",
  web_fonts = svglite::fonts_as_import("IBM Plex Sans")
)
