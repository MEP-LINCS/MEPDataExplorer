getData <- function(dataFiles, cellLine){
  
  res <- dataFiles %>% 
    dplyr::filter(CellLine == cellLine) %>% 
    head(1)
  
  df <- synGet(res$id)
  
  dt <- fread(getFileLocation(df), sep="\t", data.table=FALSE)
    
  dt
}

memoizeGetData_ <- memoize(getData)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #dataList <- reactiveValues()
  #dataList[['data']] <- NULL
  
  session$sendCustomMessage(type="readCookie", message=list())
  
  ## Show message if user is not logged in to synapse
  unauthorized <- observeEvent(input$authorized, {
    showModal(
      modalDialog(
        title = "Not logged in",
        HTML("You must log in to <a href=\"https://www.synapse.org/\">Synapse</a> to use this application. Please log in, and then refresh this page.")
      )
    )
  })
  
  foo <- observeEvent(input$cookie, {
    
    synLogin(sessionToken=input$cookie)
    source("load.R")
    
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
      
      if(length(input$filterListECMp) > 0) {
        k <- d[['ECMp']] %in% input$filterListECMp
        d <- d[k, ]
      }
      if(length(input$filterListLigand) > 0) {
        k <- d[['Ligand']] %in% input$filterListLigand
        d <- d[k, ]
      }
      
      d <- d %>% droplevels()
      
      d
    })
    
    output$boxPlot <- renderPlot({
      validate(
        need(input$updateButton > 0, "Please set options and click 'Update'.")
      )
      
      d <- filteredData()
      xAxis <- input$boxplot_x
      yAxis <- input$boxplot_y
      color <- input$color_by
      
      boxPlot(d, x=xAxis, y=yAxis, color=color)
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
      color <- input$color_by
      
      scatterPlot(d, x=xAxis, y=yAxis, color=color)
    })
  
    output$scatterPlotInfo <- renderUI({
      validate(
        need(input$updateButton > 0, "")
      )
      
      xFeat <- curatedFeatures %>% filter(FeatureName == input$scatterplot_x)
      yFeat <- curatedFeatures %>% filter(FeatureName == input$scatterplot_y)
      
      HTML(sprintf("X-axis (%s): %s<br/>Y-axis (%s): %s<br/>", 
                   xFeat$DisplayName, xFeat$Description, 
                   yFeat$DisplayName, yFeat$Description))
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
        plotParams <- list(h4("Boxplot Parameters"),
                           selectInput("boxplot_x", label = 'X-axis', 
                                       choices = curatedFeaturesListBoxX),
                           selectInput("boxplot_y", label = 'Y-axis', 
                                       choices = curatedFeaturesList)
             
        )
      } 
      else if (input$tabs == "scatter") {
        plotParams <- list(h4("Scatterplot Parameters"),
                           selectInput("scatterplot_x", label = 'X-axis', 
                                       choices = curatedFeaturesList,
                                       selected='Spot_PA_SpotCellCountLog2RUVLoess'),
                           selectInput("scatterplot_y", label = 'Y-axis', 
                                       choices = curatedFeaturesList,
                                       selected="Nuclei_PA_Gated_EdUPositiveProportionLogitRUVLoess")
        )
        
      }
      
      plotParams[['colorby']]<- selectInput('color_by', 'Color (if < 8 selected)', 
                                            choices=c("Ligands"="Ligand", "ECM Proteins"="ECMp"))
      
      plotParams
    })
  
  })
})
