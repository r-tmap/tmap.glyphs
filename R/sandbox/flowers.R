library(grid)

flower_glyph <- function(petal_sizes, x = 0.5, y = 0.5,
									   scale = 0.2, gp = gpar(fill = "pink", col = "black"), p1 = 0.05, p2 = 0.3, p3 = 0.5, p4 = 0.2, a1 = pi/2, a2 = pi/4, shape = 1) {
	
	# Input validation
	if (!is.numeric(petal_sizes)) {
		stop("petal_sizes must be a numeric vector.")
	}
	if (any(petal_sizes < 0) || any(petal_sizes > 1)) {
		stop("All elements of petal_sizes must be between 0 and 1.")
	}
	if (!is.numeric(x) || length(x) != 1 || x < 0 || x > 1) {
		stop("'x' must be a single number between 0 and 1.")
	}
	if (!is.numeric(y) || length(y) != 1 || y < 0 || y > 1) {
		stop("'y' must be a single number between 0 and 1.")
	}
	if (!is.numeric(scale) || length(scale) != 1 || scale <= 0) {
		stop("'scale' must be a single positive number.")
	}
	
	k <- length(petal_sizes)
	angles <- seq(0, 2 * pi, length.out = k + 1)[1:k]
	
	petal_grobs <- lapply(1:k, function(i) {
		# Calculate petal tip coordinates
		tip_x <- x + scale * petal_sizes[i] * cos(angles[i])
		tip_y <- y + scale * petal_sizes[i] * sin(angles[i])
		
		# Squash racket shape - using xsplineGrob for smooth curves
		
		# Control points, designed for a narrower base and wider, rounded head.
		# We use *relative* control points for smooth curves.
		
		# Handle points (very narrow)
		handle_width <- p1 * scale  # Much narrower handle
		h1_x <- x + handle_width * cos(angles[i] - a1)
		h1_y <- y + handle_width * sin(angles[i] - a1)
		h2_x <- x + handle_width * cos(angles[i] + a1)
		h2_y <- y + handle_width * sin(angles[i] + a1)
		
		# Intermediate points (wider, for transition to the head)
		mid_width <- p2 * scale * petal_sizes[i]
		m1_x <- x + mid_width * cos(angles[i] - a2) # Adjusted angles
		m1_y <- y + mid_width * sin(angles[i] - a2)
		m2_x <- x + mid_width * cos(angles[i] + a2)
		m2_y <- y + mid_width * sin(angles[i] + a2)
		
		# Head points (widest part)
		head_width <- p3 * scale * petal_sizes[i] # Wider head
		hd1_x <- tip_x + head_width * cos(angles[i] + a1)
		hd1_y <- tip_y + head_width * sin(angles[i] + a1)
		hd2_x <- tip_x + head_width * cos(angles[i] - a1)
		hd2_y <- tip_y + head_width * sin(angles[i] - a1)
		
		# Control point for tip rounding
		round_fact <- p4 * scale * petal_sizes[i]
		r_x <- tip_x + round_fact*cos(angles[i]) # Control point *at* the tip
		r_y <- tip_y + round_fact*sin(angles[i])
		
		# Combine all points
		x_coords <- c(x, h1_x, m1_x, hd2_x, r_x, hd1_x, m2_x, h2_x, x)
		y_coords <- c(y, h1_y, m1_y, hd2_y, r_y, hd1_y, m2_y, h2_y, y)

		gList(
		pointsGrob(
			x = unit(x_coords, "npc"),
			y = unit(y_coords, "npc"),
			gp = gp,
			default.units = "npc"
		),
		xsplineGrob(
			x = unit(x_coords, "npc"),
			y = unit(y_coords, "npc"),
			shape = shape,  # Adjust for desired curvature. -1 can be too extreme.
			open = FALSE,
			gp = gp,
			default.units = "npc"
		))
	})
	
	# Create a circle for the center
	center_grob <- circleGrob(x = x, y = y, r = scale * 0.1, gp = gpar(fill = "yellow", col = "black"))
	
	# Combine all grobs into a gTree
	gTree(children = gList(do.call(gList, petal_grobs), center_grob), cl = "squashRacketFlowerGlyph")
}


# --- Examples ---

# Basic example
petal_lengths <- c(0.8, 0.5, 0.9, 0.3, 0.7)
my_flower <- flower_glyph(petal_lengths)
grid.newpage()
grid.draw(my_flower)

petal_lengths <- c(.4)
my_flower <- flower_glyph(petal_lengths, p1 = .1, p2 = 0.2, p3 = 0.8, p4 = 0.6, a1 = 1, a2 = .3, shape = 1, scale = 0.2)
#my_flower <- flower_glyph(petal_lengths, p1 = .5, p2 = 0.5, p3 = 0.5, p4 = 0.5, a1 = pi/4, a2 = pi/2, shape = 0, scale = 0.2)
grid.newpage()
grid.draw(my_flower)


# Different location, scale, and styling
petal_lengths2 <- runif(6)
my_flower2 <- flower_glyph(petal_lengths2, x = 0.2, y = 0.8, scale = 0.1,
										 gp = gpar(fill = "skyblue", col = "darkblue", lwd = 2))
grid.draw(my_flower2)

# Fewer petals
petal_lengths3 <- c(0.9, 0.5, 0.7)
my_flower3 <- flower_glyph(petal_lengths3, x = 0.7, y = 0.3, scale = 0.15, gp = gpar(fill = "orange", col = "red", lwd = 3))
grid.draw(my_flower3)


# Many flowers
draw_many_flowers <- function(flower_list) {
	grid.newpage()
	for (flower in flower_list) {
		grid.draw(flower)
	}
}

num_flowers <- 8
flower_data <- lapply(1:num_flowers, function(i) {
	petal_sizes <- runif(sample(3:7, 1))  # Random number of petals
	x_pos <- runif(1)
	y_pos <- runif(1)
	flower_scale <- runif(1, min = 0.08, max = 0.15)
	flower_color <- sample(colors(), 1)
	flower_glyph(petal_sizes, x = x_pos, y = y_pos, scale = flower_scale,
							   gp = gpar(fill = flower_color, col = "black", lwd = 1))
})
draw_many_flowers(flower_data)



library(shiny)
library(ggplot2)
library(shinythemes) # For nicer themes

# Function to generate the plot (replace with your actual plotting logic)
generate_plot <- function(p1, p2, p3, p4, angle1, angle2, shape) {
	
	petal_lengths <- c(0.8)
	my_flower <- flower_glyph(petal_lengths, p1 = p1, p2 = p2, p3 = p3, p4 = p4, a1 = angle1, a2 = angle2, shape = as.numeric(shape), scale = 0.2)
	grid.newpage()
	grid.draw(my_flower)
	
}


ui <- fluidPage(
	themeSelector(),
	titlePanel("Interactive Plotting App"),
	
	sidebarLayout(
		sidebarPanel(
			h4("Input Parameters"),
			sliderInput("p1", "p1 (0-1):", value = 0.5, min = 0, max = 1, step = 0.1),
			sliderInput("p2", "p2 (0-1):", value = 0.5, min = 0, max = 1, step = 0.1),
			sliderInput("p3", "p3 (0-1):", value = 0.5, min = -1, max = 1, step = 0.1),
			sliderInput("p4", "p4 (0-1):", value = 0.5, min = -1, max = 1, step = 0.1),
			sliderInput("angle1", "Angle 1 (0-pi):", value = pi/4, min = 0, max = pi, step = 0.1),
			sliderInput("angle2", "Angle 2 (0-pi):", value = pi/2, min = 0, max = pi, step = 0.1),
			sliderInput("shape", "Shape (-1 to 1):", value = 0, min = -1, max = 1, step = 0.1)
		),
		
		mainPanel(
			plotOutput("myplot")
		)
	)
)

server <- function(input, output) {
	
	# Reactive expression to generate the plot (now reactive, not eventReactive)
	my_plot <- reactive({ 
		generate_plot(input$p1, input$p2, input$p3, input$p4, input$angle1, input$angle2, input$shape)
	})
	
	output$myplot <- renderPlot({
		my_plot()
	})
}


shinyApp(ui = ui, server = server)

