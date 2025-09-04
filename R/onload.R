# envir = environment()
.onLoad = function(...) {
	tmap::tmapSubmitOptions(
		options = list(value.const = list(comppart = 1, multi = 1),
					   value.blank = list(comppart = 1, multi = 1),
					   values.var = list(comppart = 1, multi = 1),
					   values.range = list(comppart = c(0, 1), multi = c(0, 1))))

} 
