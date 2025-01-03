#' Internal method for tm_scale_composition
#' 
#' Internal method for tm_scale_composition
#'  
#' @param ... variables
#' @param scale,legend,chart,o,aes,layer,layer_args,sortRev,bypass_ord,submit_legend arguments to be described
#' @export
#' @keywords internal
tmapScaleComposition = function(..., scale, legend, chart, o, aes, layer, layer_args, sortRev, bypass_ord, submit_legend = TRUE) {
	args = list(...)
	
	ct = NULL # what is it again?
	cls = c("fact", "unord")
	
	scale = tmap::get_scale_defaults(scale, o, aes, layer, cls, ct)
	
	show.messages <- o$show.messages
	show.warnings <- o$show.warnings
	
	n = length(args)
	
	with(scale, {
		fun_getCVV = paste0("tmapValuesCVV_", aes)
		VV = do.call(fun_getCVV, list(x = values, value.na = value.na, n = n, range = values.range, scale = values.scale, rep = values.repeat, o = o))
		
		values = VV$vvalues
		value.na = VV$value.na
		
		sfun = paste0("tmapValuesScale_", aes)
		cfun = paste0("tmapValuesColorize_", aes)
		if (is.na(value.neutral)) value.neutral = VV$value.neutral else value.neutral = do.call(sfun, list(x = do.call(cfun, list(x = value.neutral, pc = o$pc)), scale = values.scale))
		mfun = paste0("tmapValuesSubmit_", aes)
		values = do.call(mfun, list(x = values, args = layer_args))
		value.na = do.call(mfun, list(x = value.na, args = layer_args))
		value.neutral = do.call(mfun, list(x = value.neutral, args = layer_args))

		totals = Reduce("+", args)
		mx = max(totals, na.rm = TRUE)
		val_list = lapply(args, function(a) a / mx)
		
		vals = do.call(encode_mv, c(val_list, list(digits = 4)))
		labs = paste0("label", 1:n)
		
		value.neutral = vals[1]
		
		# only for the legend
		icon_scale = layer_args$icon.scale * {if (getOption("tmap.mode") == "plot") .95 else .66} # approximation, have to find out why
		
		legend = within(legend, {
			nitems = length(labs)
			labels = labs
			dvalues = values
			vvalues = values
			vneutral = value.neutral
			icon_scale = icon_scale
			na.show = FALSE
			scale = "composition"
		})
		
		
		chartFun = paste0("tmapChart", toTitleCase(chart$summary))
		chart = do.call(chartFun, list(chart))
		
		if (submit_legend) {
			if (bypass_ord) {
				format_aes_results(vals, legend = legend, chart = chart)
			} else {
				format_aes_results(vals, ord = 1L, legend = legend, chart = chart)		
			}
		} else {
			list(vals = vals, ids = 1L, legend = legend, chart = chart, bypass_ord = bypass_ord)
		}
	})

}

encode_mv = function(..., digits = 4) {
	args = list(...)
	
	k = length(args)
	m = seq(0, by = digits, length.out = k)
	
	lst = lapply(args, function(v) {
		sprintf(paste0("%0", digits, "d"), round(v * 10^digits))
	})
	Reduce(paste0, lst)
}

decode_mv = function(x, digits = 4) {
	m = seq(1, nchar(x[1]), by = digits)
	lapply(m, function(mi) {
		as.numeric(substr(x, mi, mi + digits-1))
	})
}