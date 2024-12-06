# bivariate scale
#library(tmap)
devtools::load_all("../tmap")
devtools::load_all()

Utrecht_muni = NLD_dist[NLD_dist$province == "Limburg", ]
Utrecht_muni = NLD_muni[NLD_muni$province == "Zuid-Holland", ]

tm_shape(Utrecht_muni) +
	tm_polygons() +
	tm_donuts(parts = tm_vars(c("pop_0_14", "pop_15_24", "pop_25_44", "pop_45_64", "pop_65plus"), multivariate = TRUE),
			  fill.scale = tm_scale_categorical(values = "-pu_gn_div"),			  
			  size = "population")


Utrecht_muni$income_middle = 100 - Utrecht_muni$income_high - Utrecht_muni$income_low


tm_shape(Utrecht_muni) +
	tm_polygons() +
	tm_donuts(parts = tm_vars(c("income_low", "income_middle", "income_high"), multivariate = TRUE),
			  fill.scale = tm_scale_categorical(values = "-pu_gn_div"),			  
			  size = "population")

