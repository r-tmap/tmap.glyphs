library(tmap)
library(sf)


tm_shape(World) +
	tm_polygons(fill = "white", popup.vars = FALSE) +
	tm_shape(World) +	
	tm_flowers(parts = tm_vars(c("gender", "press", "footprint", "well_being", "inequality"), multivariate = TRUE),
			   fill.scale = tm_scale(values = "friendly5"),
			   size = 1.5, popup.vars = c("gender", "press", "footprint", "well_being","inequality"), id = "name") +
	tm_basemap(NULL) +
	tm_layout(bg.color = "grey90")


# make leaf sizes consistent: the larger, the better
# use ranking instead of values 

q = function(x) {
	r = rank(x)
	r[is.na(x)] = NA
	r = r / max(r, na.rm = TRUE)
	r
}

World$rank_well_being = q((World$well_being / 8))
World$rank_footprint = q(((50 - World$footprint) / 50))
World$rank_inequality = q(((65 - World$inequality) / 65))
World$rank_press = q(1 - ((100 - World$press) / 100))
World$rank_gender = q(1 - World$gender)

tm_shape(World) +
	tm_polygons(fill = "white", popup.vars = FALSE) +
tm_shape(World) +	
	tm_flowers(parts = tm_vars(c("rank_gender", "rank_press", "rank_footprint", "rank_well_being", "rank_inequality"), multivariate = TRUE),
			   fill.scale = tm_scale(values = "friendly5"),
			   size = 1.5, popup.vars = c("rank_gender", "rank_press", "rank_footprint", "rank_well_being","rank_inequality"), id = "name") +
	tm_basemap(NULL) +
	tm_layout(bg.color = "grey90")

ttmp()
