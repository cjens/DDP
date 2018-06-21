#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Then follow the instructions in the App itself..

library(shiny)
library(plotly)
library(shinythemes)
library(dplyr)
library(reshape2)

ui <- fluidPage(
  # Set theme
  theme = shinytheme("spacelab"),

  # Some help text
  h2("Coupled hover-events in plotly charts using Shiny"),
  h4("This Shiny app showcases coupled hover-events using Plotly's", tags$code("event_data()"), "function."),

  # Vertical space
  tags$hr(),

  # Window length selector
  selectInput("window", label ="Select Window Length", choices = c(1, 2, 3, 4, 5, 6), selected = 1),

  # Plotly Chart Area
  fluidRow(
    column(6, plotlyOutput(outputId = "timeseries", height = "600px")),
    column(6, plotlyOutput(outputId = "correlation", height = "600px"))),

  tags$hr(),
  tags$blockquote("Hover over time series chart to fix a specific date. Correlation chart will update with historical
                  correlations (time span will hover over date +/- selected window length)")
  )
