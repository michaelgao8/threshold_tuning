# Demo Binary Classification Tuner for MSSP/Other projects built in Shiny

library(rbokeh)
library(shiny)
library(shinydashboard)

dashboardPage(
  ### DASHBOARD HEAD ###
  dashboardHeader(title = "Threshold Tuning Tool Demo"
),
  
  
  
  ### SIDEBAR ITEMS ###
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "Home", icon = icon("home")),
      menuItem("Tuning", tabName = "Tuning", icon = icon("bar-chart")
               
      
    )
  )),

dashboardBody(
  tabItems(
    
    # Home View
    tabItem(tabName = "Home",
            titlePanel("",windowTitle = "Threshold Tuning Demo"),
            mainPanel(
              h1("Model Tuning Platform"),
              br(),
              fileInput('historical', "Upload historical data here"),
              br(),
              uiOutput('historical_preview'),
              br(),
              fileInput('predictions', "Upload predictions here"),
              br(),
              uiOutput('prediction_preview')
              
            )
    ),
    tabItem(tabName = "Tuning",
            uiOutput("risk_slider"),#, "Risk Threshold", min = 0, max = 1, value = 0.5, step = 0.01),
            verbatimTextOutput("conf_mat"),
            rbokehOutput('roc')
    )
)
)
)

