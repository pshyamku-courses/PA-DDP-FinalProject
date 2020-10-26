#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("US major causes of death"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p("Select the disease for which you would like to forecast 
              death rates."),
            selectInput("disease_name", "Major Disease:",
                        c("Heart Disease" = "Heart Disease",
                          "Cancer" = "Cancer",
                          "Accidents" = "Accidents",
                          "Stroke" = "Stroke",
                          "Influenza and Pneumonia" = 
                              "Influenza and Pneumonia")),
            p("Select the number of years into the future that you would
              like to project death rates"),
            sliderInput("forecast_window",
                        "Years to Forecast:",
                        min = 1,
                        max = 30,
                        value = 30),
            p("Click on the Update forecast button to generate the forecast 
              plot for the chosen disease and the forecast period"),
            actionButton("go", "Update forecast")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("pastDataPlot"), plotOutput("forecastPlot")
        )
    )
))
