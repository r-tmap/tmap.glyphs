#' Internal method for tm_scale_multi
#' 
#' Internal method for tm_scale_multi
#'  
#' @param ... variables
#' @param scale,legend,chart,o,aes,layer,layer_args,sortRev,bypass_ord,submit_legend arguments to be described
#' @export
#' @keywords internal
tmapScaleMulti = function(..., scale, legend, chart, o, aes, layer, layer_args, sortRev, bypass_ord, submit_legend = TRUE) {
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
		
		#totals = Reduce("+", args)
		#mx = max(totals, na.rm = TRUE)
		#val_list = lapply(args, function(a) a / mx)
		
		
		anyna = Reduce("|", lapply(args, is.na))

		vals = do.call(encode_mv, c(args, list(digits = 5)))
		if (is.na(value.na)) {
			vals[anyna] = NA
		}
		labs = paste0("label", 1:n)
		
		value.neutral = vals[1]
		
		# only for the legend
		icon_scale = layer_args$icon.scale * {if (getOption("tmap.mode") == "plot") 1.15 else .80} # approximation, have to find out why
		
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
