% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tm_layer_donuts.R
\name{tm_donuts}
\alias{tm_donuts}
\title{Map layer: donuts}
\usage{
tm_donuts(
  parts = tm_mv(),
  parts.scale = tm_scale_composition(),
  parts.legend = tm_legend_hide(),
  parts.chart = tm_chart_none(),
  parts.free = NA,
  size = tm_const(),
  size.scale = tm_scale(),
  size.legend = tm_legend(),
  size.chart = tm_chart_none(),
  size.free = NA,
  fill.scale = tm_scale(),
  fill.legend = tm_legend(),
  fill.chart = tm_chart_none(),
  fill.free = NA,
  col = tm_const(),
  col.scale = tm_scale(),
  col.legend = tm_legend(),
  col.chart = tm_chart_none(),
  col.free = NA,
  lwd = tm_const(),
  lwd.scale = tm_scale(),
  lwd.legend = tm_legend(),
  lwd.chart = tm_chart_none(),
  lwd.free = NA,
  plot.order = tm_plot_order("DATA", reverse = FALSE),
  zindex = NA,
  group = NA,
  group.control = "check",
  popup.vars = NA,
  popup.format = list(),
  hover = "",
  id = "",
  options = opt_tm_donuts()
)
}
\arguments{
\item{parts, parts.scale, parts.legend, parts.chart, parts.free}{Variables that determine the size of the parts}

\item{size, size.scale, size.legend, size.chart, size.free}{Variables that determine the size of the donut}

\item{plot.order}{Specification in which order the spatial features are drawn.
See [tm_plot_order()] for details.}

\item{options}{options passed on to the corresponding `opt_<layer_function>` function}

\item{points.only}{should only point geometries of the shape object (defined in [tm_shape()]) be plotted? By default `"ifany"`, which means `TRUE` in case a geometry collection is specified.}

\item{icon.scale}{scaling number that determines how large the icons (or grobs) are in plot mode in comparison to proportional symbols (such as bubbles). For view mode, use the argument `grob.dim`}

\item{just}{justification of the text relative to the point coordinates. Either one of the following values: \code{"left"} , \code{"right"}, \code{"center"}, \code{"bottom"}, and \code{"top"}, or a vector of two values where first value specifies horizontal and the second value vertical justification. Besides the mentioned values, also numeric values between 0 and 1 can be used. 0 means left justification for the first value and bottom justification for the second value. Note that in view mode, only one value is used.}

\item{grob.dim}{vector of four values that determine how grob objects (see details) are shown in view mode. The first and second value are the width and height of the displayed icon. The third and fourth value are the width and height of the rendered png image that is used for the icon. Generally, the third and fourth value should be large enough to render a ggplot2 graphic successfully. Only needed for the view mode.}
}
\description{
Map layer that draws a donuts
}
