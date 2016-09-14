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
    dplyr::filter(file.CellLine == cellLine) %>% 
    head(1)
  
  df <- synGet(res$file.id)
  
  dt <- fread(getFileLocation(df), sep="\t", data.table=FALSE)
    
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
      # stainingSet <- input$staining_set
      
      dt <- memoizeGetData_(dataFiles, cellLine)
      
      # if (stainingSet != "SSC") {
      #   dt <- dt %>% 
      #     dplyr::filter(StainingSet == stainingSet)
      # }
      
      dt
      
    }, 
    message=sprintf("Getting %s data...", input$cell_line))
  })
  
  filteredData <- reactive({
    d <- data()
    
    if (input$filter_by != "None") {
      k <- d[[input$filter_by]] %in% input$filterList
      d <- d[k, ]
      d <- d %>% droplevels()
      print(input$filter_by)
      print(length(unique(d[, input$filter_by])))
    }
    
    d
  })
  
  output$boxPlot <- renderPlot({
    validate(
      need(input$updateButton > 0, "Please set options and click 'Update'.")
    )
    
    d <- filteredData()
    xAxis <- input$boxplot_x
    yAxis <- input$boxplot_y
    
    boxPlot(d, x=xAxis, y=yAxis)
  })

  output$boxPlotInfo <- renderUI({
    validate(
      need(input$updateButton > 0, "")
    )
    
    xFeat <- curatedFeatures %>% filter(FeatureName == input$boxplot_x)
    yFeat <- curatedFeatures %>% filter(FeatureName == input$boxplot_y)

    HTML(sprintf("X-axis (%s): %s<br/>Y-axis (%s): %s<br/>", 
                 xFeat$DisplayName, xFeat$Description, 
                 yFeat$DisplayName, yFeat$Description))
  })
  
  output$scatterPlot <- renderPlotly({

    validate(
      need(input$updateButton > 0, "Please set options and click 'Update'.")
    )

    d <- filteredData()
    xAxis <- input$scatterplot_x
    yAxis <- input$scatterplot_y
    color <- input$filter_by
    
    scatterPlot(d, x=xAxis, y=yAxis, color=color)
  })
  
  # output$staining_set_ctrls <- renderUI({
  #   cellLine <- input$cell_line
  #   
  #   filteredDataFiles <- dataFiles %>% filter(file.CellLine == cellLine)
  #   stainingSets <- c(filteredDataFiles$file.StainingSet)
  #   
  #   #names(stainingSets) <- paste("Staining Set", stainingSets)
  #   
  #   selectInput("staining_set", label = 'Staining Set', 
  #               choices = stainingSets, 
  #               selected = "SSC")
  # })
  
  output$plotParams <- renderUI({
    
    if (input$tabs == 'box') {
      list(h4("Boxplot Parameters"),
           selectInput("boxplot_x", label = 'X-axis', 
                       choices = curatedFeaturesListBoxX),
           selectInput("boxplot_y", label = 'Y-axis', 
                       choices = curatedFeaturesList)
           
      )
    } 
    else if (input$tabs == "scatter") {
      list(h4("Scatterplot Parameters"),
           selectInput("scatterplot_x", label = 'X-axis', 
                       choices = curatedFeaturesList),
           selectInput("scatterplot_y", label = 'Y-axis', 
                       choices = curatedFeaturesList)
           )
      
    }
  })
  
})
