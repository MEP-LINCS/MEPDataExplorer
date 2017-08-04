library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("MEP-LINCS Data Explorer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      helpText("Display measurements from MEPs."),
      selectInput("study", label = 'Study', 
                  choices = dataFiles$Study, selected = dataFiles$Study[1]),
      actionButton("updateButton", "Get Data"),
      hr(),

      selectInput('filterListLigand', label='Select Ligands',
                  choices=ligands, 
                  selectize = TRUE, 
                  multiple = TRUE),
      
      selectInput('filterListECMp', label='Select ECM Proteins',
                  choices=ecmps, 
                  selectize = TRUE, 
                  multiple = TRUE),
      
      hr(),
      
      uiOutput('plotParams')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id="tabs",
                  tabPanel("Box Plot", value="box", 
                           plotOutput("boxPlot"),
                           htmlOutput('boxPlotInfo')),
                  tabPanel("Scatter Plot", value="scatter", 
                           plotlyOutput("scatterPlot", width = "100%", height = "600px"),
                           htmlOutput('scatterPlotInfo'))
      )
    )
)))
