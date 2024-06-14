#' Options for tm_donuts
#' 
#' Options for tm_donuts
#'
#' @param type cartogram type, one of: "cont" for contiguous cartogram, "ncont" for non-contiguous cartogram and "dorling" for Dorling cartograms
#' @param itermax, maximum number of iterations (see [cartogram::cartogram_cont()])
#' @param ... arguments passed on to [cartogram::cartogram_cont()]
#' @export
opt_tm_donuts = function(points.only = "ifany",
						 icon.scale = 6,
						 start = 0,
						 direction = 1,
						 inner = .4,
						 just = NA,
						 grob.dim = c(width=48, height=48, render.width=256, render.height=256)) {
	list(mapping.args = list(icon.scale = icon.scale,
							 just = just,
							 start = start,
							 direction = direction,
							 inner = inner,
							 grob.dim = grob.dim),
		 trans.args = list(points.only = points.only))
}



#' Map layer: donuts
#' 
#' Map layer that draws a donuts
#' 
#' @param parts,parts.scale,parts.legend,parts.chart,parts.free Variables that determine the size of the parts
#' @param size,size.scale,size.legend,size.chart,size.free Variables that determine the size of the donut
#' @param plot.order Specification in which order the spatial features are drawn.
#'   See [tm_plot_order()] for details.
#' @param options options passed on to the corresponding `opt_<layer_function>` function
#' @param points.only should only point geometries of the shape object (defined in [tm_shape()]) be plotted? By default `"ifany"`, which means `TRUE` in case a geometry collection is specified. 
#' @param icon.scale scaling number that determines how large the icons (or grobs) are in plot mode in comparison to proportional symbols (such as bubbles). For view mode, use the argument `grob.dim`
#' @param just justification of the text relative to the point coordinates. Either one of the following values: \code{"left"} , \code{"right"}, \code{"center"}, \code{"bottom"}, and \code{"top"}, or a vector of two values where first value specifies horizontal and the second value vertical justification. Besides the mentioned values, also numeric values between 0 and 1 can be used. 0 means left justification for the first value and bottom justification for the second value. Note that in view mode, only one value is used.
#' @param grob.dim vector of four values that determine how grob objects (see details) are shown in view mode. The first and second value are the width and height of the displayed icon. The third and fourth value are the width and height of the rendered png image that is used for the icon. Generally, the third and fourth value should be large enough to render a ggplot2 graphic successfully. Only needed for the view mode.
#' @export
tm_donuts = function(parts = tm_mv(),
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
					 options = opt_tm_donuts()) {
	po = plot.order
	
	shape = 19
	shape.scale = tm_scale()
	shape.legend = tm_legend()
	shape.chart = tm_chart_none()
	shape.free = NA
	
	tm_element_list(tm_element(
		layer = "donuts",
		trans.fun = tmapTransCentroid,
		trans.aes = list(),
		trans.args = options$trans.args,
		trans.isglobal = FALSE,
		mapping.aes = list(parts = tmapScale(aes = "num",
											 value = parts,
											 scale = parts.scale,
											 legend = parts.legend,
											 chart = parts.chart,
											 free = parts.free),
						   size = tmapScale(aes = "size",
						   				 value = size,
						   				 scale = size.scale,
						   				 legend = size.legend,
						   				 chart = size.chart,
						   				 free = size.free),
						   fill = tmapScale(aes = "fill",
						   				 value = tmapUsrCls(parts),
						   				 scale = fill.scale,
						   				 legend = fill.legend,
						   				 chart = fill.chart,
						   				 free = fill.free),
						   col = tmapScale(aes = "col",
						   				value = col,
						   				scale = col.scale,
						   				legend = col.legend,
						   				chart = col.chart,
						   				free = col.free),
						   shape = tmapScale(aes = "shape",
						   				  value = shape,
						   				  scale = shape.scale,
						   				  legend = shape.legend,
						   				  chart = shape.chart,
						   				  free = shape.free),
						   lwd = tmapScale(aes = "lwd",
						   				value = lwd,
						   				scale = lwd.scale,
						   				legend = lwd.legend,
						   				chart = lwd.chart,
						   				free = lwd.free)),
		
		gpar = tmapGpar(fill = "__fill",
						col = "__col",
						shape = "__shape",
						size = "__size",
						fill_alpha = 1,
						col_alpha = 1,
						pattern = NA,
						lty = "solid",
						lwd = "__lwd",
						linejoin = NA,
						lineend = NA),
		tpar = tmapTpar(),
		plot.order = plot.order,
		mapping.fun = "Donuts",
		mapping.args = options$mapping.args,
		zindex = zindex,
		group = group,
		group.control = group.control,
		popup.vars = popup.vars,
		popup.format = popup.format,
		hover = hover,
		id = id,
		subclass = c("tm_aes_layer", "tm_layer")))
	
}


