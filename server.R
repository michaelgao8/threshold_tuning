
library(rbokeh)
library(shiny)
library(caret)
library(DT)

options(shiny.maxRequestSize=30*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output){

  # Upload 1
  historical_upload <- reactive({
    upload1 <- input$historical
    if(is.null(upload1)){return()}
    read.csv(file=upload1$datapath, stringsAsFactors = FALSE)}
    )
  
  # Preview
  
  output$historical_preview <- renderDT(historical_upload())
  
  
  output$select_reference <- renderUI({
    placeholder <- historical_upload()
    if (is.null(placeholder)) return(NULL)
    selectInput('select_reference', 'Select the name of the column corresponding to the reference columns (0 and 1)', choices = names(historical_upload()))})
  
  output$select_model_output <- renderUI({
    placeholder2 <- historical_upload()
    if (is.null(placeholder2)) return(NULL)
    selectInput('select_model_output', 'Select the name of the column corresponding to the model output', choices = names(historical_upload()))})
  
  # Change slider input
  output$risk_slider <- renderUI({
    sliderInput("risk_threshold", "Risk Threshold", min = round(min(historical_upload()[[input$select_model_output]]), digits = 2), max = round(max(historical_upload()[[input$select_model_output]]), digits = 2), value = 0.5, step = 0.01)
  })
  
  
  observeEvent(input$select_model_output,{
    # Create the interactive ROC curve
    # Need sensitivity and specificity at all levels
    tp <- c()
    fp <- c()
    tn <- c()
    fn <- c()
    thresh <- c()
    
    
    for(th in seq(round(min(historical_upload()[[input$select_model_output]]),digits = 2), round(max(historical_upload()[[input$select_model_output]]), digits = 2), length.out = 100)){
      new_thresh <- ifelse(historical_upload()[[input$select_model_output]] >= th, 1, 0)
      tp <- c(tp, length(which(new_thresh == 1 & historical_upload()[[input$select_reference]] == 1)))
      fp <- c(fp, length(which(new_thresh == 1 & historical_upload()[[input$select_reference]] == 0)))
      tn <- c(tn, length(which(new_thresh == 0 & historical_upload()[[input$select_reference]] == 0)))
      fn <- c(fn, length(which(new_thresh == 0 & historical_upload()[[input$select_reference]] == 1)))
      thresh <- c(thresh, th)
    }
    
    sensitivity <- tp/(tp+fn)
    roc_x <- 1 - tn/(tn + fp)
    ppv <- tp/(tp + fp)
    npv <- tn/(tn + fn)
    
    roc_df <<- data.frame(cbind(tp, fp, tn, fn, sensitivity, roc_x, thresh, ppv, npv))
  
    
  })
  

  risk <- reactive({input$risk_threshold})
  observeEvent(risk(),{
    thresholded_predictions <- ifelse(historical_upload()[[input$select_model_output]] >= risk(), 1, 0)
    output$conf_mat <- renderPrint({confusionMatrix(data = factor(thresholded_predictions), reference = factor(historical_upload()[[input$select_reference]]))})
    
  
    
    
  }
  )
  
  observeEvent(input$select_model_output,{
    output$roc <- renderRbokeh({figure(width = 800, height = 800) %>% 
    ly_points(roc_x, sensitivity, data = roc_df, hover = list(thresh, sensitivity, roc_x, ppv, npv))})
    
  })
  
})
