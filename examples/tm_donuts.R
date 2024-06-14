# bivariate scale
library(tmap)
tm_shape(World) +
	tm_polygons(tm_mv("inequality", "well_being"))


tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_donuts(parts = tm_mv("origin_native", "origin_west", "origin_non_west"),
			  size = "population",
			  fill.scale = tm_scale_categorical(values = "brewer.dark2"))

tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_symbols(size = "population")




tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_donuts(parts = tm_mv("origin_native", "origin_west", "origin_non_west"),
			  lwd = 2,
			  size = "population",
			  fill.scale = tm_scale_categorical(values = "brewer.dark2"))



tm_shape(NLD_prov) +
	tm_polygons() +
	tm_symbols(size = "population",
			   lwd = 4,
			   size.scale =tm_scale_continuous(values.scale = 4))

ttm()
tm_shape(NLD_prov) +
	tm_polygons() +
	tm_symbols(size = "population",
			   lwd = 4,
			   size.scale =tm_scale_continuous(values.scale = 4))
