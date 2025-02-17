library(grid)
library(shiny)

raindrop_flower_glyph <- function(petal_sizes, x = 0.5, y = 0.5, scale = 0.2,
								  body_width_factor = 0.6, body_angle_offset = pi/3,
								  shape_factor = -0.7, base_angle_offset = pi/6,
								  base_width_factor = 0.1,
								  gp = gpar(fill = "skyblue", col = "black")) {
	
	# Input validation
	if (!is.numeric(petal_sizes) || any(petal_sizes < 0) || any(petal_sizes > 1)) stop("Invalid petal_sizes.")
	if (!is.numeric(scale) || scale <= 0) stop("Invalid scale")
	if (!is.numeric(body_width_factor) || body_width_factor <= 0) stop("Invalid body_width_factor")
	if (!is.numeric(body_angle_offset) || body_angle_offset < 0) stop("Invalid body_angle_offset")
	if (!is.numeric(shape_factor)) stop("Invalid shape_factor")
	if (!is.numeric(base_angle_offset)) stop("Invalid base_angle_offset")
	if (!is.numeric(base_width_factor) || base_width_factor <=0) stop("Invalid base_width_factor")
	
	k <- length(petal_sizes)
	angles <- seq(0, 2 * pi, length.out = k + 1)[1:k]
	
	petal_grobs <- lapply(1:k, function(i) {
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
		
		xsplineGrob(
			x = unit(x_coords, "npc"),
			y = unit(y_coords, "npc"),
			shape = as.numeric(shape_factor),
			open = FALSE,
			gp = gp,
			default.units = "npc"
		)
	})
	
	center_grob <- circleGrob(x = x, y = y, r = scale * 0.1, gp = gpar(fill = "yellow", col = "black"))
	gTree(children = gList(do.call(gList, petal_grobs), center_grob), cl = "raindropFlowerGlyph")
}



# --- Shiny App ---

ui <- fluidPage(
	titlePanel("Raindrop Flower Glyph"),
	sidebarLayout(
		sidebarPanel(
			sliderInput("num_petals", "Number of Petals:", min = 3, max = 12, value = 6, step = 1),
			sliderInput("scale", "Scale:", min = 0.05, max = 0.5, value = 0.2, step = 0.01),
			sliderInput("body_width_factor", "Body Width Factor:", min = 0.1, max = 1, value = 0.6, step = 0.01),
			sliderInput("body_angle_offset", "Body Angle Offset (radians):", min = 0, max = pi / 2, value = pi / 3, step = 0.01),
			sliderInput("base_angle_offset", "Base Angle Offset (radians):", min = 0, max = pi / 2, value = pi / 6, step = 0.01),
			sliderInput("base_width_factor", "Base Width Factor:", min = 0.01, max = 0.4, value = 0.1, step = 0.01), # NEW
			sliderInput("shape_factor", "Shape Factor:", min = -1, max = 1, value = -0.7, step = 0.01),
			actionButton("randomize", "Randomize Petal Sizes"),
			hr(),
			h4("Petal Sizes (Adjust Manually):"),
			uiOutput("petal_sliders")
		),
		mainPanel(
			plotOutput("flowerPlot", width = "500px", height = "500px")
		)
	)
)

server <- function(input, output, session) {
	
	petal_sizes <- reactive({
		if (input$randomize > 0) {
			isolate({
				runif(input$num_petals, min = 0.3, max = 1)
			})
		} else {
			unlist(lapply(1:input$num_petals, function(i) {
				input[[paste0("petal_", i)]]
			}))
		}
	})
	
	output$petal_sliders <- renderUI({
		num_petals <- input$num_petals
		current_sizes <- isolate(petal_sizes())
		
		lapply(1:num_petals, function(i) {
			sliderInput(
				inputId = paste0("petal_", i),
				label = paste("Petal", i),
				min = 0,
				max = 1,
				value = ifelse(is.null(current_sizes) || length(current_sizes) < i, 0.7, current_sizes[i]),
				step = 0.01
			)
		})
	})
	
	output$flowerPlot <- renderPlot({
		sizes <- petal_sizes()
		if (is.null(sizes) || length(sizes) != input$num_petals) {
			return(NULL)
		}
		
		grid.newpage()
		my_flower <- raindrop_flower_glyph(
			petal_sizes = sizes,
			scale = input$scale,
			body_width_factor = input$body_width_factor,
			body_angle_offset = input$body_angle_offset,
			shape_factor = input$shape_factor,
			base_angle_offset = input$base_angle_offset,
			base_width_factor = input$base_width_factor
		)
		grid.draw(my_flower)
	})
}

shinyApp(ui, server)