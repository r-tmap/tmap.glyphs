if (FALSE) {
	
	df = structure(list(pid = 1:3, id = c(1L, 1L, 1L), perc = c(1000000, 
														   387000, 194000), lwd_compensation = c(1, 1, 1), fill = c("#4D9D4F", 
														   														 "#E8E8E8", "#B873C0"), col = c("#000000", "#000000", "#000000"
														   														 ), lwd = c(1.41111111111111, 1.41111111111111, 1.41111111111111
														   														 )), row.names = c(NA, -3L), class = c("data.table", "data.frame"
														   														 ))
	opts = list(inner = 0.4, direction = 1, start = 0, fill_hole = NA)
	opts = list(inner = 0.4, direction = 1, start = 0, fill_hole = "pink")
	
	grid.draw(donutGrob(df, opts))
	
	
	grid.newpage();grid.rect();grid.draw(flowerGrob(df))
}



donutGrob = function(df, opts = list(inner = 0.4, direction = 1, start = 0)) {

	df$label = df$pid
	df$fraction = df$perc / sum(df$perc)
	
	create_donut_grob = function(radius1, radius2, fill, col, lwd) {
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
			default.units = "native", gp = grid::gpar(fill = fill, col = col, lwd = lwd)
		)
	}

	# Function to create a segment grob
	create_segment_grob = function(start_angle, end_angle, radius1, radius2, fill, col, lwd) {
		k=100
		theta = seq(start_angle, end_angle, length.out = k)
		x1 = radius1 * cos(theta)
		y1 = radius1 * sin(theta)
		x2 = radius2 * cos(theta)
		y2 = radius2 * sin(theta)

		grid::polygonGrob(
			x = c(x2, rev(x1)), y = c(y2, rev(y1)),
			default.units = "native", gp = grid::gpar(fill = fill, col = col, lwd = lwd)
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
		grob_list[[1]] = create_donut_grob(opts$inner, 1, df$fill[id], df$col[id], df$lwd[id])
	} else {
		for (i in seq_len(nrow(df))) {
			end_angle = start_angle + dir * df$fraction[i] * 360
			grob_list[[i]] = create_segment_grob(
				degrees_to_radians(start_angle), degrees_to_radians(end_angle), 
				opts$inner, 1, df$fill[i], df$col[i], df$lwd[i]
			)
			start_angle = end_angle
		}
	}
	
	if (!is.na(opts$fill_hole)) {
		# Create the hole in the donut
		hole_grob = grid::circleGrob(0, 0, r = opts$inner, default.units = "native", gp = grid::gpar(fill = opts$fill_hole, col = df$col[1], lwd = df$lwd[1]))
		grob_list[[length(grob_list) + 1]] = hole_grob
	}
	
	# Combine all grobs into a single gTree object
	grid::gTree(children = do.call(grid::gList, grob_list), vp = grid::viewport(width = grid::unit(1, "snpc"), height = grid::unit(1, "snpc"), xscale = c(-1, 1), yscale = c(-1, 1)))
}



flowerGrob <- function(df, opts = list(scale = 0.5,
								  body_width_factor = 0.81, body_angle_offset = 0.31,
								  shape_factor = 1, base_angle_offset = 0.15,
								  base_width_factor = 0.4)) {
	
	x = 0.5
	y = 0.5
	
	petal_sizes = df$perc / 1e6
	
	fill = df$fill
	col = df$col
	lwd = df$lwd
	
	with(opts, {
		# Input validation
		if (!is.numeric(scale) || scale <= 0) stop("Invalid scale")
		if (!is.numeric(body_width_factor) || body_width_factor <= 0) stop("Invalid body_width_factor")
		if (!is.numeric(body_angle_offset) || body_angle_offset < 0) stop("Invalid body_angle_offset")
		if (!is.numeric(shape_factor)) stop("Invalid shape_factor")
		if (!is.numeric(base_angle_offset)) stop("Invalid base_angle_offset")
		if (!is.numeric(base_width_factor) || base_width_factor <=0) stop("Invalid base_width_factor")
		
		k <- length(petal_sizes)
		angles <- seq(0, 2 * pi, length.out = k + 1)[1:k]
	

		petal_grobs <- lapply(1:k, function(i) {
			gp = grid::gpar(fill = fill[i], col = col[i], lwd = lwd[i])
			if (is.na(petal_sizes[i])) {
				tip_x <- x + scale * cos(angles[i])
				tip_y <- y + scale * sin(angles[i])
				grid::polylineGrob(x = grid::unit(c(x, tip_x), "npc"),
								   y = grid::unit(c(y, tip_y), "npc"),
								   gp = gp)
			} else {
				# Calculate petal tip coordinates
				tip_x <- x + scale * petal_sizes[i] * cos(angles[i])
				tip_y <- y + scale * petal_sizes[i] * sin(angles[i])
				
				# Control points for the narrow base, using base_angle_offset
				base_width <- base_width_factor * scale * petal_sizes[i] # Base width
				b1_x <- x + base_width * cos(angles[i] - base_angle_offset)
				b1_y <- y + base_width * sin(angles[i] - base_angle_offset)
				b2_x <- x + base_width * cos(angles[i] + base_angle_offset)
				b2_y <- y + base_width * sin(angles[i] + base_angle_offset)
				
				# Control points for the rounded body
				body_width <- body_width_factor * scale * petal_sizes[i]
				b3_x <- x + body_width * cos(angles[i] - body_angle_offset)
				b3_y <- y + body_width * sin(angles[i] - body_angle_offset)
				b4_x <- x + body_width * cos(angles[i] + body_angle_offset)
				b4_y <- y + body_width * sin(angles[i] + body_angle_offset)
				
				# Combine points.  Start and end at the flower center (x, y).
				x_coords <- c(x, b1_x, b3_x, tip_x, b4_x, b2_x, x)
				y_coords <- c(y, b1_y, b3_y, tip_y, b4_y, b2_y, y)
				
				grid::xsplineGrob(
					x = grid::unit(x_coords, "npc"),
					y = grid::unit(y_coords, "npc"),
					shape = as.numeric(shape_factor),
					open = FALSE,
					gp = gp,
					default.units = "npc"
				)			
			}
		})
		#center_grob <- circleGrob(x = x, y = y, r = scale * 0.1, gp = gpar(fill = "yellow", col = "black"))
		#gTree(children = gList(do.call(gList, petal_grobs), center_grob), cl = "raindropFlowerGlyph")
		grid::gTree(children = grid::gList(do.call(grid::gList, petal_grobs)), cl = "flowerGlyph")		
	})

}

