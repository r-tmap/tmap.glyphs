if (FALSE) {
	df = structure(list(pid = 1:3, id = c(1L, 1L, 1L), perc = c(419000, 
														   387000, 194000), lwd_compensation = c(1, 1, 1), fill = c("#4D9D4F", 
														   														 "#E8E8E8", "#B873C0"), col = c("#000000", "#000000", "#000000"
														   														 ), lwd = c(1.41111111111111, 1.41111111111111, 1.41111111111111
														   														 )), row.names = c(NA, -3L), class = c("data.table", "data.frame"
														   														 ))
	opts = list(inner = 0.4, direction = 1, start = 0, fill_hole = NA)
	opts = list(inner = 0.4, direction = 1, start = 0, fill_hole = "pink")
}



donutGrob = function(df, opts = list(inner = 0.4, direction = 1, start = 0)) {

	df$label = df$pid
	df$fraction = df$perc / sum(df$perc)
	
	create_donut_grob = function(radius1, radius2, fill, col) {
		k=100
		theta = seq(0, 2*pi, length.out = k)
		x1 = radius1 * cos(theta)
		y1 = radius1 * sin(theta)
		x2 = radius2 * cos(theta)
		y2 = radius2 * sin(theta)
		
		grid::pathGrob(
			x = c(x1, rev(x2)), y = c(y1, rev(y2)),
			id = rep(1:2, each = k),
			rule = "evenodd",
			default.units = "native", gp = grid::gpar(fill = fill, col = col)
		)
	}

	# Function to create a segment grob
	create_segment_grob = function(start_angle, end_angle, radius1, radius2, fill, col) {
		k=100
		theta = seq(start_angle, end_angle, length.out = k)
		x1 = radius1 * cos(theta)
		y1 = radius1 * sin(theta)
		x2 = radius2 * cos(theta)
		y2 = radius2 * sin(theta)

		grid::polygonGrob(
			x = c(x2, rev(x1)), y = c(y2, rev(y1)),
			default.units = "native", gp = grid::gpar(fill = fill, col = col)
		)
	}
	
	# Convert degrees to radians
	degrees_to_radians = function(degrees) {
		degrees * pi / 180
	}
	
	# Generate grobs for donut segments
	grob_list = list()
	start_angle = -opts$start + 90

	dir = if (opts$direction == 1) -1 else 1
	
	singleCat = (sum(df$fraction == 0) == (nrow(df) - 1L))
	if (singleCat) {
		id = which(df$fraction != 0)
		grob_list[[1]] = create_donut_grob(opts$inner, 1, df$fill[id], df$col[id])
	} else {
		for (i in seq_len(nrow(df))) {
			end_angle = start_angle + dir * df$fraction[i] * 360
			grob_list[[i]] = create_segment_grob(
				degrees_to_radians(start_angle), degrees_to_radians(end_angle), 
				opts$inner, 1, df$fill[i], df$col[i]
			)
			start_angle = end_angle
		}
	}
	
	if (!is.na(opts$fill_hole)) {
		# Create the hole in the donut
		hole_grob = grid::circleGrob(0, 0, r = opts$inner, default.units = "native", gp = grid::gpar(fill = opts$fill_hole, col = df$col[1]))
		grob_list[[length(grob_list) + 1]] = hole_grob
	}
	
	# Combine all grobs into a single gTree object
	grid::gTree(children = do.call(grid::gList, grob_list), vp = grid::viewport(width = unit(1, "snpc"), height = unit(1, "snpc"), xscale = c(-1, 1), yscale = c(-1, 1)))
}
