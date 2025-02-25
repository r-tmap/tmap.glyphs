library(tmap)

World$norm_well_being = World$well_being / 8
World$norm_footprint = (50 - World$footprint) / 50
World$norm_inequality = (65 - World$inequality) / 65
World$norm_press = (100 - World$press) / 100
World$norm_gender = World$gender

tm_shape(World, bbox = "Europe") +
	tm_polygons(fill = "white", popup.vars = FALSE) +
	tm_flowers(parts = tm_vars(c("norm_well_being", "norm_footprint", "norm_inequality", "norm_press", "norm_gender"), multivariate = TRUE),
			   size = .5, popup.vars = c("norm_well_being", "norm_footprint", "norm_inequality", "norm_press", "norm_gender"), id = "name")
