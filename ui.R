#Libreria requerida
require(plotly)
require(readr)
require(DT)
require(markdown)
require(rmarkdown)

#Carga librerias
library(shiny)
library(plotly)
library(readr)
library(DT)
library(markdown)
library(rmarkdown)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Customer Simple Description"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("dt", "Choose a topic:",
                        choices = c("Age", "Annual Income", "Spending Score")),
            br(),
            
            helpText("Note: while the data view will show only the specified",
                     "summary of observations, the results will still be based",
                     "on the full dataset.", "Also, you can view the full dataset",
                     "in the 'Data Table' tab."),
            
            actionButton("update","Update View")
        ),
    
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Descriptive Stats", textOutput("describe")),
                        tabPanel("Customer by Age", plotlyOutput(outputId = "gdts3")),
                        tabPanel("Spending and Income", plotlyOutput(outputId = "gdts7")),
                        tabPanel("Data Table", DTOutput('tbl')),
                        tabPanel("Instructions",
                                 fluidRow(column(12, includeMarkdown('instructions.md'))))
            )
        )
    )
)