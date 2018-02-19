
library(rbokeh)
library(shiny)
library(caret)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Upload 1
  historical_upload <- reactive({
    upload1 <- input$historical
    if(is.null(upload1)){return()}
    read.csv(file=upload1$datapath, stringsAsFactors = FALSE)})
  
  # Preview
  
  output$historical_preview <- renderTable(head(historical_upload()))
  
    # Upload 2
  prediction_upload <- reactive({
    upload2 <- input$predictions
    if(is.null(upload2)){return()}
    read.csv(file=upload2$datapath, stringsAsFactors = FALSE)
  })
  
  # Preview
  output$prediction_preview <- renderTable(head(prediction_upload()))
  
  # Change slider input
  output$risk_slider <- renderUI({
    sliderInput("risk_threshold", "Risk Threshold", min = round(min(prediction_upload()[,2]), digits = 2), max = round(max(prediction_upload()[,2]), digits = 2), value = 0.5, step = 0.01)
  })
  
  observeEvent(prediction_upload(),{
    # Create the interactive ROC curve
    # Need sensitivity and specificity at all levels
    tp <- c()
    fp <- c()
    tn <- c()
    fn <- c()
    thresh <- c()
    
    
    for(th in seq(round(min(prediction_upload()[,2]),digits = 2), round(max(prediction_upload()[,2]), digits = 2), length.out = 100)){
      new_thresh <- ifelse(prediction_upload()[,2] >= th, 1, 0)
      tp <- c(tp, length(which(new_thresh == 1 & historical_upload()[,2] == 1)))
      fp <- c(fp, length(which(new_thresh == 1 & historical_upload()[,2] == 0)))
      tn <- c(tn, length(which(new_thresh == 0 & historical_upload()[,2] == 0)))
      fn <- c(fn, length(which(new_thresh == 0 & historical_upload()[,2] == 1)))
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
    thresholded_predictions <- ifelse(prediction_upload()[,2] >= risk(), 1, 0)
    output$conf_mat <- renderPrint({confusionMatrix(data = thresholded_predictions, reference = factor(historical_upload()[,2], levels = c(1, 0)))})
    
  
    
    
  }
  )
  output$roc <- renderRbokeh({figure(width = 800, height = 800) %>% 
      ly_points(roc_x, sensitivity, data = roc_df, hover = list(thresh, sensitivity, roc_x, ppv, npv))})
  
})
