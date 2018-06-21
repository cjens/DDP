#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Then follow the instructions in the App itself..
#
#

server <- function(input, output) {

  # Read data in and convert to country string, drop unnecessary vars
  setwd("/Users/ravenclaw/Desktop/")
  xrates <- read.csv("DP_LIVE_19062018172943951.csv", header=TRUE, colClasses =c(X...LOCATION="character", TIME="character", Value="numeric", NULL))
  xrates$COUNTRY <- as.character(xrates$X...LOCATION)
  xrates$YEAR <- as.POSIXct(xrates$TIME, format="%Y", origin="1989")
  myvars <- c("YEAR", "COUNTRY", "Value")
  xrates2 <- xrates[myvars]
  xrates2 <- xrates2 %>% group_by(COUNTRY) %>% mutate(Index=Value/Value[which.min(YEAR)])
  xrates3 <- dcast(xrates2, YEAR ~ COUNTRY, value.var="Value")


  # Set some colors

  plotcolor <- "#5F1DA"
  papercolor <- "#3DFC8"

  ## Plot time series chart

  output$timeseries <- renderPlotly({
    p <- plot_ly(source = "source") %>%
    add_lines(data=xrates2, x = ~YEAR, y = ~Index, color = ~COUNTRY, mode="lines", line=list(width=3))

  ## Add some layout details
  p <- p%>%
    layout(title="Exchange rates for some European transition countries",
           xaxis =list(title = "Year", gridcolor="#bfbfbf", domain = c(0,5)),
           yaxis = list(title = "Exchange rate, LCU:USD (index, first year=1)", gridcolor = "#bfbfbf"),
           plot_bgcolor = plotcolor,
           paper_bgcolor = papercolor)

  p

})

# Coupled hover event
output$correlation <- renderPlotly({

# Read in hover data
eventdata <- event_data("plotly_hover", source = "source")
validate(need(!is.null(eventdata), "Hover over the time series chart to populate this heatmap"))

# Get point number
datapoint <- as.numeric(eventdata$pointNumber)[1]

# Get window length
window <- as.numeric(input$window)

# Show correlation heatmap
rng <- (datapoint - window):(datapoint + window)
cormat <- round(cor(xrates3[rng, 2:7]), 2)

plot_ly(x = rownames(cormat), y = colnames(cormat), z = cormat, type = "heatmap",
        colors = colorRamp(c('#e3dfc8', '#808c6c'))) %>%
  layout(title = "Correlation heatmap",
         xaxis = list(title = ""),
         yaxis = list(title = ""))
})
}

