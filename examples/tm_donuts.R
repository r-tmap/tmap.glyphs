# bivariate scale
#library(tmap)
devtools::load_all("../tmap")
devtools::load_all()

tm_shape(World) +
	tm_polygons(tm_vars(c("inequality", "well_being"), multivariate = TRUE))


tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_donuts(parts = tm_vars(c("origin_native", "origin_west", "origin_non_west"), multivariate = TRUE),
			  size = "population",
			  size.scale = tm_scale_continuous(values.scale = 1.5),
			  fill.scale = tm_scale_categorical(values = "brewer.dark2"))

tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_donuts(parts = tm_mv("origin_native", "origin_west", "origin_non_west"),
			  size = "population",
			  size.scale = tm_scale_continuous(values.scale = 3),
			  fill.scale = tm_scale_categorical(values = "brewer.dark2"),options = opt_tm_donuts(icon.scale = 3)
			  )


require(rnaturalearth)
	
airports <- ne_download(scale=10, type="airports", returnclass = "sf")
airplane <- tmap_icons(system.file("img/airplane.png", package = "tmap"))


tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_symbols(size = "population", size.scale = tm_scale_continuous(values.scale = 3), options = opt_tm_symbols(icon.scale = 3))

tm_shape(NLD_prov) + 
	tm_polygons() +
	tm_symbols(size = "population", size.scale = tm_scale_continuous(values.scale = 9), options = opt_tm_symbols(icon.scale = 1))


#current.mode <- tmap_mode("view")

tm_shape(NLD_prov, crs = 4326) + tm_polygons() + 
	tm_shape(airports) +
	tm_symbols(shape=airplane, size="natlscale", 
			   size.scale = tm_scale_continuous(values.scale = 1), options = opt_tm_symbols(icon.scale = 3))


tm_shape(NLD_prov, crs = 4326) + tm_polygons() + 
	tm_shape(airports) +
	tm_symbols(shape=airplane, size="natlscale", 
			   size.scale = tm_scale_continuous(values.scale = 1), options = opt_tm_symbols(icon.scale = 9))



tm_shape(NLD_prov, crs = 4326) + tm_polygons() + 
	tm_shape(airports) +
	tm_symbols(shape=airplane, size="natlscale", 
			   size.scale = tm_scale_continuous(values.scale = 1), options = opt_tm_symbols(icon.scale = 9), size.legend=tm_legend(orientation = "landscape"))

tm_shape(NLD_prov, crs = 4326) + tm_polygons() + 
	tm_shape(airports) +
	tm_symbols(shape=airplane, size="natlscale", 
			   size.scale = tm_scale_continuous(values.scale = 1), options = opt_tm_symbols(icon.scale = 9), size.legend=tm_legend(orientation = "portrait"))




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

