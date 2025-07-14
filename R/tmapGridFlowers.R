#' Internal methods for tm_flowers
#' 
#' Internal methods for tm_flowers
#'  
#' @param shpTM,dt,gp,bbx,facet_row,facet_col,facet_page,id,pane,group,o,... to be described
#' @export
#' @return internal tmap object
#' @importFrom utils head
#' @import tmap
#' @keywords internal
#' @rdname internals_glyphs
#' @method tmapGridDataPlot tm_data_flowers
tmapGridDataPlot.tm_data_flowers = function(a, shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...) {
	tmapXFlowers(gs = "Grid", a, shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...)
}

#' @keywords internal
#' @export
#' @rdname internals_glyphs
#' @method tmapLeafletDataPlot tm_data_flowers
tmapLeafletDataPlot.tm_data_flowers = function(a, shpTM, dt, pdt, popup.format, hdt, idt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...)  {
	tmapXFlowers(gs = "Leaflet", a, shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...)
}


tmapXFlowers = function(gs, a, shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...) {
	ymin = NULL
	ymax = NULL
	lwd = NULL
	shape = NULL
	parts = NULL
	

	val_list = decode_mv(dt$parts, digits = 5)
	n = length(val_list)
	
	labs = paste0("label", 1:n)
	
	dat = data.table::rbindlist(mapply(function(v, pid) {
		data.table::data.table(pid = pid, id = 1:length(v), perc = 100 * v)
	}, val_list, 1:n, SIMPLIFY = FALSE))
	
	fill = strsplit(dt$fill[1], "__", fixed = TRUE)[[1]]
	
	if (gs == "Leaflet") {
		dat$lwd_compensation = 16/dt$size[dat$id]
	} else {
		dat$lwd_compensation = 4
	}
	
	dat$fill = fill[dat$pid]
	dat$col = dt$col[dat$id]
	dat$lwd = tmap::lwd_to_mm(dt$lwd)[dat$id] * o$scale_down * dat$lwd_compensation
	
	
	
	total = length(val_list[[1]])
	pb = utils::txtProgressBar(min = 0, max = total)
	

		
	grobs <- structure(lapply(split(dat, dat$id), function(x) {
		if (any(is.na(x$perc))) return(NULL)
		flowerGrob(x)
	}), class = "tmapSpecial")
	
	values_shapes = rep(NA_integer_, total)
	
	sel = which(!is.na(val_list[[1]]))
	if (length(sel)) {
		values_shapes[sel] = do.call("tmapValuesSubmit_shape", list(x = grobs[sel], args = a))
	}

	gp$col = NA
	gp$shape = "__shape"
	
	dt[, shape:=values_shapes]
	dt[, parts:=NULL]
	dt[, fill:=NULL]
	
	fun = paste0("tmap", gs, "DataPlot")
	
	value_neutral = do.call("tmapValuesSubmit_shape", list(x = grobs[1], args = a))
	
	
	# # update legends:
	# # - get vneutral for scale composision
	# # - set vneutral for scale shape
	# legs_cached = get("legs", .TMAP)
	# unms = vapply(legs_cached, "[[", character(1), "unm", USE.NAMES = FALSE)
	# mfuns = vapply(legs_cached, "[[", character(1), "mfun", USE.NAMES = FALSE)
	# id_shape = which(unms == "shape" & mfuns == "Flowers")
	# legs_cached[[id_shape]]$vneutral = 24 #value_neutral
	# 
	# 
	# assign("legs", legs_cached, envir = .TMAP)
	class(a) = c("tm_data_symbols", "list")
	
	do.call(fun, c(list(a, shpTM = shpTM, dt = dt, gp = gp, bbx = bbx, facet_row = facet_row, facet_col = facet_col, facet_page = facet_page, id = id, pane = pane, group = group, o = o), list(...)))
}
