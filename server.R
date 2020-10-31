#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Read the data that is needed
library(ggplot2)
library(forecast)
library(tsbox)
library(plotly)

data <- read.csv("Data/NCHS_-_AADR_Major_Causes_of_Death.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    v <- reactiveValues(doPlot = FALSE)
    
    observeEvent(input$go, {
        # 0 will be coerced to FALSE
        # 1+ will be coerced to TRUE
        v$doPlot <- input$go
    })
    
    fit <- reactive({
        
        # generate bins based on input$bins from ui.R
        selected_disease <- input$disease_name
        y    <- subset(data, 
                       Cause == input$disease_name, select = c(Year, Age.Adjusted.Death.Rate))

        fit <- ets(ts_ts(ts_long(y)), allow.multiplicative.trend = TRUE)
        
    })
    
    output$forecastPlot <- renderPlot({
        if (v$doPlot == FALSE) return()
        
        isolate({
           
            # draw the histogram with the specified number of bins
            autoplot(forecast(fit(), h = input$forecast_window)) + geom_forecast() +
                ggtitle("Forecast of Age Adjusted Death Rate") + xlab("Years") +
                ylab("Age Adjusted Death Rate") +
                theme(text = element_text(size=20))
        })
    })
    
    output$pastDataPlot <- renderPlotly({

        data %>% plot_ly(x = ~Year, y = ~Age.Adjusted.Death.Rate,
                color = ~Cause, type = "scatter",
                mode = "lines") %>%
        layout(title = "All causes", xaxis = list(title = "Years", titlefont = 20),
               yaxis = list(title = "Age Adjusted Death Rate", titlefont = 20))
    })
})
