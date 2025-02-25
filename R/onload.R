# envir = environment()
.onLoad = function(...) {
	opts = list(value.const = 1,
					  value.na = NULL,
					  value.blank = 1,
					  values.var = 1,
					  values.range = c(0, 1))
	mapply(tmap::tmapAddLayerOptions, names(opts), rep("comppart", length(opts)), opts, SIMPLIFY = FALSE)
	
	opts2 = list(value.const = 1,
				value.na = NULL,
				value.blank = 1,
				values.var = 1,
				values.range = c(0, 1))
	mapply(tmap::tmapAddLayerOptions, names(opts2), rep("multi", length(opts2)), opts, SIMPLIFY = FALSE)
} 
