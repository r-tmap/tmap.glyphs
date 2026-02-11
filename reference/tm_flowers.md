# Map layer: flowers

Map layer that draw flowers as glyphs

## Usage

``` r
opt_tm_flowers(
  start = 0,
  direction = 1,
  inner = 0.4,
  fill_hole = NA,
  points_only = "ifany",
  point_per = "feature",
  on_surface = FALSE,
  icon.scale = 6,
  just = NA,
  grob.dim = c(width = 48, height = 48, render.width = 256, render.height = 256)
)

tm_flowers(
  parts = tmap::tm_vars(multivariate = TRUE),
  parts.scale = tm_scale_multi(),
  parts.legend = tmap::tm_legend_hide(),
  parts.chart = tmap::tm_chart_none(),
  parts.free = NA,
  size = tmap::tm_const(),
  size.scale = tmap::tm_scale(),
  size.legend = tmap::tm_legend(),
  size.chart = tmap::tm_chart_none(),
  size.free = NA,
  fill.scale = tmap::tm_scale(),
  fill.legend = tmap::tm_legend(),
  fill.chart = tmap::tm_chart_none(),
  fill.free = NA,
  col = tmap::tm_const(),
  col.scale = tmap::tm_scale(),
  col.legend = tmap::tm_legend(),
  col.chart = tmap::tm_chart_none(),
  col.free = NA,
  lwd = tmap::tm_const(),
  lwd.scale = tmap::tm_scale(),
  lwd.legend = tmap::tm_legend(),
  lwd.chart = tmap::tm_chart_none(),
  lwd.free = NA,
  plot.order = tmap::tm_plot_order("DATA", reverse = FALSE),
  zindex = NA,
  group = NA,
  group.control = "check",
  popup.vars = NA,
  popup.format = list(),
  hover = "",
  id = "",
  options = opt_tm_flowers()
)
```

## Arguments

- start:

  starting angle of the pies. 0 means top

- direction:

  direction in which the pies are stacked. 1 means clockwise, 0
  counterclockwise

- inner:

  proportion of the inner circle

- fill_hole:

  should the hole be filled? Either \`FALSE\` or a fill color.

- points_only:

  should only point geometries of the shape object (defined in
  \[tm_shape()\]) be plotted? By default \`"ifany"\`, which means
  \`TRUE\` in case a geometry collection is specified.

- point_per:

  specification of how spatial points are mapped when the geometry is a
  multi line or a multi polygon. One of `"feature"`, `"segment"` or
  `"largest"`. The first generates a spatial point for every feature,
  the second for every segment (i.e. subfeature), the third only for the
  largest segment (subfeature). Note that the last two options can be
  significant slower.

- on_surface:

  In case of polygons, centroids are computed. Should the points be on
  the surface? If \`TRUE\`, which is slower than the default \`FALSE\`,
  centroids outside the surface are replaced with points computed with
  \[sf::st_point_on_surface()\].

- icon.scale:

  scaling number that determines how large the icons (or grobs) are in
  plot mode in comparison to proportional symbols (such as bubbles). For
  view mode, use the argument \`grob.dim\`

- just:

  justification of the text relative to the point coordinates. Either
  one of the following values: `"left"` , `"right"`, `"center"`,
  `"bottom"`, and `"top"`, or a vector of two values where first value
  specifies horizontal and the second value vertical justification.
  Besides the mentioned values, also numeric values between 0 and 1 can
  be used. 0 means left justification for the first value and bottom
  justification for the second value. Note that in view mode, only one
  value is used.

- grob.dim:

  vector of four values that determine how grob objects (see details)
  are shown in view mode. The first and second value are the width and
  height of the displayed icon. The third and fourth value are the width
  and height of the rendered png image that is used for the icon.
  Generally, the third and fourth value should be large enough to render
  a graphic successfully. Only needed for the view mode.

- parts, parts.scale, parts.legend, parts.chart, parts.free:

  Variables that determine the size of the parts

- size, size.scale, size.legend, size.chart, size.free:

  Variables that determine the size of the donut

- col, col.scale, col.legend, col.chart, col.free:

  Visual variable that determines the col color. See details.

- lwd, lwd.scale, lwd.legend, lwd.chart, lwd.free:

  Visual variable that determines the line width. See details.

- plot.order:

  Specification in which order the spatial features are drawn. See
  \[tm_plot_order()\] for details.

- zindex:

  Map layers are drawn on top of each other. The \`zindex\` numbers (one
  for each map layer) determines the stacking order. By default the map
  layers are drawn in the order they are called.

- group:

  Name of the group to which this layer belongs. This is only relevant
  in view mode, where layer groups can be switched (see
  \`group.control\`)

- group.control:

  In view mode, the group control determines how layer groups can be
  switched on and off. Options: \`"radio"\` for radio buttons (meaning
  only one group can be shown), \`"check"\` for check boxes (so multiple
  groups can be shown), and \`"none"\` for no control (the group cannot
  be (de)selected).

- popup.vars:

  names of data variables that are shown in the popups in \`"view"\`
  mode. Set popup.vars to \`TRUE\` to show all variables in the shape
  object. Set popup.vars to \`FALSE\` to disable popups. Set popup.vars
  to a character vector of variable names to those those variables in
  the popups. The default (\`NA\`) depends on whether visual variables
  (e.g.\`col\`) are used. If so, only those are shown. If not all
  variables in the shape object are shown.

- popup.format:

  list of formatting options for the popup values. See the argument
  \`legend.format\` for options. Only applicable for numeric data
  variables. If one list of formatting options is provided, it is
  applied to all numeric variables of \`popup.vars\`. Also, a (named)
  list of lists can be provided. In that case, each list of formatting
  options is applied to the named variable.

- hover:

  name of the data variable that specifies the hover labels (view mode
  only). Set to \`FALSE\` to disable hover labels. By default \`FALSE\`,
  unless \`id\` is specified. In that case, it is set to \`id\`,

- id:

  name of the data variable that specifies the indices of the spatial
  features. Only used for \`"view"\` mode.

- options:

  options passed on to the corresponding \`opt\_\<layer_function\>\`
  function

- fill, fill.scale, fill.legend, fill.chart, fill.free:

  Visual variable that determines the fill color. See details.

## Value

a \[tmap::tmap-element\], supposed to be stacked after
\[tmap::tm_shape()\] using the \`+\` operator. The
\`opt\_\<layer_function\>\` function returns a list that should be
passed on to the \`options\` argument.

## Examples

``` r
library(tmap)

tm_shape(World) +
  tm_polygons(fill = "white", popup.vars = FALSE) +
tm_shape(World) +  
 tm_flowers(
    parts = tm_vars(c("gender", "press", "footprint", 
              "well_being", "inequality"), multivariate = TRUE),
  fill.scale = tm_scale(values = "friendly5"),
  size = 1.5, 
    popup.vars = c("gender", "press", "footprint", "well_being","inequality"), 
    id = "name") +
tm_basemap(NULL) +
tm_layout(bg.color = "grey90")
#> [tip] Consider a suitable map projection, e.g. by adding `+ tm_crs("auto")`.
#> This message is displayed once per session.



# make leaf sizes consistent: the larger, the better
# use ranking instead of values 

q = function(x) {
  r = rank(x)
  r[is.na(x)] = NA
  r = r / max(r, na.rm = TRUE)
  r
}

World$rank_well_being = q((World$well_being / 8))
World$rank_footprint = q(((50 - World$footprint) / 50))
World$rank_inequality = q(((65 - World$inequality) / 65))
World$rank_press = q(1 - ((100 - World$press) / 100))
World$rank_gender = q(1 - World$gender)

tm_shape(World) +
  tm_polygons(fill = "white", popup.vars = FALSE) +
tm_shape(World) +  
  tm_flowers(
    parts = 
      tm_vars(c("rank_gender", "rank_press", "rank_footprint", 
            "rank_well_being", "rank_inequality"), multivariate = TRUE),
    fill.scale = tm_scale(values = "friendly5"),
    size = 1.5, 
    popup.vars = c("rank_gender", "rank_press", "rank_footprint",
             "rank_well_being","rank_inequality"), id = "name") +
tm_basemap(NULL) +
tm_layout(bg.color = "grey90")


ttmp()
#> ℹ tmap modes "plot" - "view"
#> ℹ toggle with `tmap::ttm()`
#> This message is displayed once per session.
#> Error: not all variables specified in tm_vars are found
```
