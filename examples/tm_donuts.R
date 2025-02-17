library(tmap)

ZH_muni = NLD_muni[NLD_muni$province == "Zuid-Holland", ]

ZH_muni$income_middle = 100 - ZH_muni$income_high - ZH_muni$income_low

which.max(ZH_muni$population)

ZH_muni$population[c(10,26)] = 500000

tm_shape(ZH_muni) +
	tm_polygons() +
	tm_donuts(parts = tm_vars(c("income_low", "income_middle", "income_high"), multivariate = TRUE),
			  fill.scale = tm_scale_categorical(values = "-pu_gn_div"),			  
			  size = "population",
			  lwd = 1,
			  size.scale = tm_scale_continuous(ticks = c(50000, 100000, 250000, 500000)),
			  options = opt_tm_donuts(fill_hole = FALSE))

tm_shape(ZH_muni) +
	tm_polygons() +
	tm_flowers(parts = tm_vars(c("income_low", "income_middle", "income_high"), multivariate = TRUE),
			  fill.scale = tm_scale_categorical(values = "-pu_gn_div"),			  
			  size = "population",
			  lwd = 1,
			  size.scale = tm_scale_continuous(ticks = c(50000, 100000, 250000, 500000)),
			  options = opt_tm_donuts(fill_hole = FALSE))

names(World)

World$norm_well_being = World$well_being / 8
World$norm_footprint = (50 - World$footprint) / 50
World$norm_inequality = (65 - World$inequality) / 65
World$norm_press = (100 - World$press) / 100
World$norm_gender = World$gender

tm_shape(World) +
	tm_polygons(fill = "white", popup.vars = FALSE) +
	tm_flowers(parts = tm_vars(c("norm_well_being", "norm_footprint", "norm_inequality", "norm_press", "norm_gender"), multivariate = TRUE),
			   size = 2, popup.vars = c("norm_well_being", "norm_footprint", "norm_inequality", "norm_press", "norm_gender"), id = "name")
