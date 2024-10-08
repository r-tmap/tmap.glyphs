#' @rdname tm_donuts
#' @name opt_tm_donuts
#' @export
opt_tm_donuts = function(start = 0,
						 direction = 1,
						 inner = .4,
						 points.only = "ifany",
						 point.per = "feature",
						 icon.scale = 6,
						 just = NA,
						 grob.dim = c(width=48, height=48, render.width=256, render.height=256)) {
	list(mapping.args = list(icon.scale = icon.scale,
							 just = just,
							 start = start,
							 direction = direction,
							 inner = inner,
							 grob.dim = grob.dim),
		 trans.args = list(points.only = points.only,
		 				  point.per = point.per))
}



#' Map layer: donuts
#' 
#' Map layer that draws a donuts
#' 
#' @param parts,parts.scale,parts.legend,parts.chart,parts.free Variables that determine the size of the parts
#' @param size,size.scale,size.legend,size.chart,size.free Variables that determine the size of the donut
#' @param fill,fill.scale,fill.legend,fill.chart,fill.free Visual variable that determines the fill color. See details.
#' @param col,col.scale,col.legend,col.chart,col.free Visual variable that determines the col color. See details.
#' @param lwd,lwd.scale,lwd.legend,lwd.chart,lwd.free Visual variable that determines the line width. See details.
#' @param plot.order Specification in which order the spatial features are drawn.
#'   See [tm_plot_order()] for details.
#' @param zindex Map layers are drawn on top of each other. The `zindex` numbers
#'   (one for each map layer) determines the stacking order. By default the map
#'   layers are drawn in the order they are called.
#' @param group Name of the group to which this layer belongs.
#'   This is only relevant in view mode, where layer groups can be switched
#'   (see `group.control`)
#' @param group.control In view mode, the group control determines how layer
#'   groups can be switched on and off. Options: `"radio"` for radio buttons
#'   (meaning only one group can be shown), `"check"` for check boxes
#'   (so multiple groups can be shown), and `"none"` for no control (the group cannot be (de)selected).
#' @param options options passed on to the corresponding `opt_<layer_function>` function
#' @param popup.vars names of data variables that are shown in the popups in
#'   `"view"` mode. Set popup.vars to `TRUE` to show all variables in the shape object.
#'   Set popup.vars to `FALSE` to disable popups. Set popup.vars to a character vector
#'   of variable names to those those variables in the popups. The default (`NA`)
#'   depends on whether visual variables (e.g.`col`) are used. If so, only those are shown. If not all variables in the shape object are shown.
#' @param popup.format list of formatting options for the popup values.
#'   See the argument `legend.format` for options. Only applicable for numeric data
#'   variables. If one list of formatting options is provided, it is applied to
#'   all numeric variables of `popup.vars`. Also, a (named) list of lists can be provided.
#'   In that case, each list of formatting options is applied to the named variable.
#' @param hover name of the data variable that specifies the hover labels (view mode only). Set to `FALSE` to disable hover labels. By default `FALSE`, unless `id` is specified. In that case, it is set to `id`,
#' @param id name of the data variable that specifies the indices of the spatial features. Only used for `"view"` mode.
#' @param start starting angle of the pies. 0 means top
#' @param direction direction in which the pies are stacked. 1 means clockwise, 0 counterclockwise
#' @param inner proportion of the inner circle
#' @param points.only should only point geometries of the shape object (defined in [tm_shape()]) be plotted? By default `"ifany"`, which means `TRUE` in case a geometry collection is specified. 
#' @param point.per specification of how spatial points are mapped when the geometry is a multi line or a multi polygon. One of \code{"feature"}, \code{"segment"} or \code{"largest"}. The first generates a spatial point for every feature, the second for every segment (i.e. subfeature), the third only for the largest segment (subfeature). Note that the last two options can be significant slower.
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


