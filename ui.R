# Demo Binary Classification Tuner for MSSP/Other projects built in Shiny

library(rbokeh)
library(shiny)
library(shinydashboard)
library(e1071)

dashboardPage(
  ### DASHBOARD HEAD ###
  dashboardHeader(title = "Basic Threshold Tuning Tool"
),
  
  
  
  ### SIDEBAR ITEMS ###
  dashboardSidebar(
    sidebarMenu(
      menuItem("Usage", tabName = "Usage", icon = icon("Usage")),
      menuItem("Tuning", tabName = "Tuning", icon = icon("bar-chart")
               
      
    )
  )),

dashboardBody(
  tabItems(
    
    # Usage View
    tabItem(tabName = "Usage",
            titlePanel("",windowTitle = "Usage Information"),
            mainPanel(
              h1("Model Tuning Platform"),
              h3("Introduction"),
              p("This tool is designed to help tune binary classification models by uploading the data in a specified format."),
              h4("Reference Data (Historical)"),
              p("The file you upload should be an excel file (extension .xlsx) that is formatted with the first column containing a unique ID that ties together the reference and the second column containing a 1 for a positive event and 0 for a negative event"),
              fileInput('historical', "Upload historical data here"),
              uiOutput('historical_preview'),
              br(),
              h4("Prediction Data (Risk Scores)"),
              p("The prediction file should have the same first column as the first file (unique ID) and the second column should contain the risk score (does not need to be normalized)"),
              fileInput('predictions', "Upload predictions here"),
              br(),
              uiOutput('prediction_preview')
              
            )
    ),
    tabItem(tabName = "Tuning",
            textOutput("file_name"),
            uiOutput("risk_slider"),#, "Risk Threshold", min = 0, max = 1, value = 0.5, step = 0.01),
            verbatimTextOutput("conf_mat"),
            rbokehOutput('roc')
    )
)
)
)

