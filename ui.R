# Demo Binary Classification Tuner for MSSP/Other projects built in Shiny

library(rbokeh)
library(shiny)
library(shinydashboard)
library(DT)

dashboardPage(
  ### DASHBOARD HEAD ###
  dashboardHeader(title = "Basic Threshold Tuning Tool"
),
  
  
  
  ### SIDEBAR ITEMS ###
  dashboardSidebar(
    sidebarMenu(
      menuItem("Upload", tabName = "Upload", icon = icon("Usage")),
      menuItem("Tuning", tabName = "Tuning", icon = icon("bar-chart")
               
      
    )
  )),

dashboardBody(
  tabItems(
    
    # Usage View
    tabItem(
      tabName = "Upload",
              fluidRow(
                column(width = 12,
              
                       h1("Threshold Tuning"),
                       h3("Introduction"),
                       p("Binary Classification models often output probabilties as their output, meaning that the results are between 0 and 1. Depending \
                         on what threshold is chosen, the performance of the model may change. For example, setting higher thresholds (only above .7 counts as a prediction of class 1) may have \
                         the effect of increasing the positive predictive value while lowering the recall. This tool is designed to help you select the correct threshold for your \
                         model once you have the results."),
                       h3("Upload your data"),
                       p("You can upload a csv file that contains, at minimum, a column with the correct class (0 or 1) and one with the probabilties that your \
                         model is outputting. If the csv does not have a header, make sure to uncheck the box below to ensure that you don't clip the first row"),
                       checkboxInput("header", label = "Does your file have a header?", value = TRUE),
                       fileInput('historical', "Upload historical data here"),
                       uiOutput('select_reference'),
                       uiOutput('select_model_output'),
                       DTOutput('historical_preview')
                       
                       )
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

