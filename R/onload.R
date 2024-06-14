# envir = environment()
.onLoad = function(...) {
	parts_opts = list(value.const = "grey85",
					  value.na = "grey75",
					  value.blank = "#ffffff",
					  values.var = "tol.muted",
					  values.range = NA)
	mapply(tmap::tmapAddLayerOptions, names(parts_opts), rep("parts", length(parts_opts)), parts_opts, SIMPLIFY = FALSE)
	
	
	
} 
