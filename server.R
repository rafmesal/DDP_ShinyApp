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

#Functions for this app

describe <- function(dt) {
    
    #Tendencia central
    avg <- round(mean(dt),2)
    med <- round(median(dt),2)
    mda <- round(DescTools::Mode(dt),2)
    
    #Dispersion
    vr <- round(var(dt),2)
    ds <- round(sd(dt),2)
    rgi <- round(IQR(dt),2)
    rg <- round(max(dt) - min(dt),2)
    mi <- round(min(dt),2)
    ma <- round(max(dt),2)
    
    #Salida
  
    s1 <- c(avg, med, mda, rg, mi, ma, vr, ds, rgi)
    s2 <- c("The data mean is: ",
            "its median is: ",
            "and the mode is:",
            "Its Range is: ",
            "its minimum value:",
            "and its maximun value:",
            "The variance is: ",
            "its Standar devition: ",
            "and its IQR: ")

    s3 <- paste(s2, s1, sep = '\n')
    sal <- paste(s3, sep = '\n', collapse = '\n')
    
    return(sal)
}
    

# Server logic
shinyServer(function(input, output) {
    
    datos <- read_csv("Mall_Customers.csv")
    
    #Data table with DT

    output$tbl <- renderDT(
        datos, options = list(lengthChange = FALSE)
    )
    
    #Ploting data with Plotly
    
    output$gdts3 <- renderPlotly(
        plot_ly(datos, x = ~Age, 
                color = ~Gender, 
                type = "box", 
                colors = "Set1") %>%
            layout(title = 'Customers Age by Genre'),
        #api_create(gdts3, filename = "simple-graph0")
    ) 
    
    output$gdts7 <- renderPlotly(
        plot_ly(data = datos, 
                x= ~Age, 
                y= ~`Spending Score (1-100)`, 
                color = ~Gender, 
                colors = "Set1", 
                type = 'scatter', 
                text =  ~`Annual Income (k$)`,
                mode = 'markers',
                marker = list(size = ~`Annual Income (k$)`*0.20, opacity = 0.5)) %>%
            layout(title = 'Spending Score and Annual  Income by Age'),
        #api_create(gdts7, filename = "simple-graph")
    )
    
    #Some simple descriptive statistics
    
    datasetInput <- eventReactive(input$update, {
        switch(input$dt,
               "Age" = datos$Age,
               "Annual Income" = datos$`Annual Income (k$)`,
               "Spending Score" = datos$`Spending Score (1-100)`)
    }, ignoreNULL = FALSE)
    
    output$describe <- renderText({
        dt <- datasetInput()
        describe(dt)
    })
})
