tmapGridDonuts = function(shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...) {
	tmapXDonuts(gs = "Grid", shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...)
}

tmapLeafletDonuts = function(shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...) {
	tmapXDonuts(gs = "Leaflet", shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...)
}

	
tmapXDonuts = function(gs, shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o, ...) {
	layer_args = list(...)
	
	
	val_list = decode_mv(dt$parts, digits = 4)
	n = length(val_list)
	
	labs = paste0("label", 1:n)
	
	dat = data.table::rbindlist(mapply(function(v, pid) {
		data.table::data.table(pid = pid, id = 1:length(v), perc = 100 * v)
	}, val_list, 1:n, SIMPLIFY = FALSE))
	
	fill = strsplit(dt$fill[1], "__", fixed = TRUE)[[1]]

	if (gs == "Leaflet") {
		dat$lwd_compensation = 4/dt$size[dat$id]
	} else {
		dat$lwd_compensation = 1
	}
	
	dat$fill = fill[dat$pid]
	dat$col = dt$col[dat$id]
	dat$lwd = lwd_to_mm(dt$lwd)[dat$id] * o$scale_down * dat$lwd_compensation
	scale = 1
	
	requireNamespace("ggplot2")
	
	grobs <- structure(lapply(split(dat, dat$id), function(x) {
		singleCat = sum(dat$perc != 0) <= 1L
		x$fraction = x$perc / sum(x$perc)
		x$ymax = cumsum(x$fraction)
		x$ymin = c(0, head(x$ymax, n = -1))
		ggplot2::ggplotGrob(ggplot2::ggplot(x, ggplot2::aes(ymax=ymax, ymin=ymin, xmax=1, xmin=layer_args$inner, fill=I(fill), color = I(col), lwd = I(lwd))) +
								#ggplot2::scale_fill_manual(values = values[1:n]) + 
								ggplot2::geom_rect() +
								ggplot2::coord_polar(theta="y", start = layer_args$direction * layer_args$start * pi / 180, direction = layer_args$direction) +
								ggplot2::xlim(c(0, 1)) +
								theme_ps())
	}), class = "tmapSpecial")
	values_shapes = do.call("tmapValuesSubmit_shape", list(x = grobs, args = layer_args))
	
	gp$col = NA
	gp$shape = "__shape"
	
	dt[, shape:=values_shapes]
	dt[, parts:=NULL]
	dt[, fill:=NULL]
	
	fun = paste0("tmap", gs, "Symbols")
	
	value_neutral = do.call("tmapValuesSubmit_shape", list(x = grobs[1], args = layer_args))

	
	# update legends:
	# - get vneutral for scale composision
	# - set vneutral for scale shape
	legs_cached = get("legs", .TMAP)
	unms = vapply(legs_cached, "[[", character(1), "unm", USE.NAMES = FALSE)
	mfuns = vapply(legs_cached, "[[", character(1), "mfun", USE.NAMES = FALSE)
	id_shape = which(unms == "shape" & mfuns == "Donuts")
	legs_cached[[id_shape]]$vneutral = value_neutral
	
	assign("legs", legs_cached, envir = .TMAP)
	
	do.call(fun, c(list(shpTM, dt, gp, bbx, facet_row, facet_col, facet_page, id, pane, group, o), layer_args))
}
