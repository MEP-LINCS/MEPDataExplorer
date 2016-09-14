library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("MEP-LINCS Data Explorer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      helpText("Display measurements from MEPs."),
      selectInput("cell_line", label = 'Cell Line', 
                  choices = c("MCF10A", "HMEC122L", "HMEC240L"), selected = "MCF10A"),
      # uiOutput('staining_set_ctrls'),
      actionButton("updateButton", "Update"),
      hr(),
      selectInput("filter_by", label = 'Filter by', 
                  choices = c("None", "Ligand", "ECMp")),

      conditionalPanel("input.filter_by=='Ligand'",
                       selectInput('filterListLigand', label='Ligands',
                                   choices=ligands, 
                                   selectize = TRUE, 
                                   multiple = TRUE)),
      
      conditionalPanel("input.filter_by=='ECMp'",
                       selectInput('filterListECMp', label='ECMp',
                                   choices=ecmps, 
                                   selectize = TRUE, 
                                   multiple = TRUE)),
      
      uiOutput('plotParams')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id="tabs",
                  tabPanel("Box Plot", value="box", 
                           plotOutput("boxPlot"),
                           htmlOutput('boxPlotInfo')),
                  tabPanel("Scatter Plot", value="scatter", 
                           plotlyOutput("scatterPlot"),
                           textOutput('scatterPlotInfo'))
      )
    )
)))
