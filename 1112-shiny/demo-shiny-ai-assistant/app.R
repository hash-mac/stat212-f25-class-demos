library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Sample UI Demo",
  sidebar = sidebar(
    h4("Controls"),
    selectInput("dataset", "Choose dataset:",
                choices = c("mtcars", "iris", "faithful")),
    numericInput("obs", "Number of observations:",
                 value = 10, min = 1, max = 100),
    checkboxInput("header", "Show column names", TRUE),
    hr(),
    radioButtons("format", "Table format:",
                 choices = c("HTML" = "html",
                             "CSV" = "csv"),
                 selected = "html")
  ),

  layout_columns(
    col_widths = c(8, 4),
    card(
      card_header("Data Table"),
      tableOutput("table")
    ),
    card(
      card_header("Summary"),
      verbatimTextOutput("summary")
    )
  ),

  card(
    card_header("Plot"),
    plotOutput("plot")
  )
)

server <- function(input, output, session) {
  # Reactive data
  datasetInput <- reactive({
    switch(input$dataset,
           "mtcars" = mtcars,
           "iris" = iris,
           "faithful" = faithful)
  })

  # Table output
  output$table <- renderTable({
    head(datasetInput(), input$obs)
  }, rownames = TRUE)

  # Summary output
  output$summary <- renderPrint({
    summary(datasetInput())
  })

  # Plot output
  output$plot <- renderPlot({
    data <- datasetInput()
    if (ncol(data) >= 2) {
      plot(data[, 1], data[, 2],
           main = paste("Plot of", input$dataset),
           xlab = names(data)[1],
           ylab = names(data)[2])
    }
  })
}

shinyApp(ui = ui, server = server)
