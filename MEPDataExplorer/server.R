library(data.table)
library(dplyr)
library(memoise)
library(shiny)
library(shinydashboard)
library(synapseClient)
synapseLogin()

source("load.R")
source("lib.R")

getData <- function(dataFiles, cellLine){
  
  res <- dataFiles %>% 
    dplyr::filter(file.CellLine == cellLine, file.StainingSet == "SSC") %>% 
    head(1)
  
  df <- synGet(res$file.id)
  
  dt <- fread(getFileLocation(df), data.table=FALSE)
    
  print(dim(dt))
  dt
}

memoizeGetData_ <- memoize(getData)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #dataList <- reactiveValues()
  #dataList[['data']] <- NULL
  
  data <- eventReactive(input$updateButton, {
    withProgress({
      cellLine <- input$cell_line
      stainingSet <- input$staining_set
      
      dt <- memoizeGetData_(dataFiles, cellLine)
      
      if (stainingSet != "SSC") {
        dt <- dt %>% 
          dplyr::filter(StainingSet == stainingSet)
      }
      
      dt
      
    }, 
    message=sprintf("Getting %s data...", input$cell_line))
  })
  
  output$boxPlot <- renderPlot({
    validate(
      need(input$updateButton > 0, "Please set options and click 'Update'.")
    )
    
    d <- data()
    yAxis <- input$boxplot_y
    
    
    boxPlot(d, yAxis)
  })
  
  output$scatterPlot <- renderPlotly({

    validate(
      need(input$updateButton > 0, "Please set options and click 'Update'.")
    )
    d <- data()
    yAxis <- input$scatterplot_y
    xAxis <- input$scatterplot_x
    
    scatterPlot(d, xAxis, yAxis)
  })
  
  output$staining_set_ctrls <- renderUI({
    cellLine <- input$cell_line
    
    filteredDataFiles <- dataFiles %>% filter(file.CellLine == cellLine)
    stainingSets <- c(filteredDataFiles$file.StainingSet)
    
    #names(stainingSets) <- paste("Staining Set", stainingSets)
    
    selectInput("staining_set", label = 'Staining Set', 
                choices = stainingSets, 
                selected = "SSC")
  })
  
  output$plotParams <- renderUI({
    
    if (input$tabs == 'box') {
      list(h4("Boxplot Parameters"),
           selectInput("boxplot_y", label = 'Y-axis', 
                       choices = boxPlot_yVars, selected = boxPlot_yVars[1])
      )
    } 
    else if (input$tabs == "scatter") {
      list(h4("Scatterplot Parameters"),
           selectInput("scatterplot_x", label = 'X-axis', 
                       choices = scatterPlot_xyVars, selected = scatterPlot_xyVars[1]),
           selectInput("scatterplot_y", label = 'Y-axis', 
                       choices = scatterPlot_xyVars, selected = scatterPlot_xyVars[2])
      )
      
    }
  })
  
})
