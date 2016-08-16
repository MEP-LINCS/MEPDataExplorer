#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("MEP-LINCS Data Explorer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("cell_line", label = 'Cell Line', choices = c("MCF10A"), selected = "MCF10A"),
       selectInput("cell_line", label = 'Cell Line', choices = c("SS1", "SS2", "SS3", "SS4", "Combined"), selected = "Combined")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("First Plot", plotOutput("firstPlot")),
        tabPanel("Second Plot", plotlyOutput("secondPlot"))
    )
  )
)))
