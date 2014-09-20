library(shiny)
require(stats); 
require(graphics)
data(mtcars)

shinyServer(function(input, output) {
  
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  trainingSize<-reactive(floor(dim(mtcars)[1]*input$training/100))
  trainingData<-reactive(mtcars[1:trainingSize(),])
  testingData<-reactive(mtcars[trainingSize()+1:dim(mtcars)[1],])
  testingPlot=reactive(mtcars[trainingSize()+1:dim(mtcars)[1],names(mtcars)==input$variable])
  
  lmModel<- reactive({lm(as.formula(paste("mpg ~", input$variable)),data=trainingData())})
  
  modelTitle <- renderText({
    paste(paste("Regression Model: lm(", formulaText()), ", data=trainingData)")
  })
  
  output$modelPlot <- renderPlot({
    plot(as.formula(formulaText()), 
            data = trainingData(), main=modelTitle(), pch=19)
    abline(lmModel(), col="blue", lwd=3)
    
  })
  
  output$regTab <- renderTable({
    summary(lmModel())$coefficients
  })
  
  testTitle <- renderText({
    "Regression Model Testing Data Plot (Predicted mpg in BLUE)"
  })
  
  output$testingPlot <- renderPlot({
    plot(as.formula(formulaText()), 
         data = testingData(), pch=19, col="red", main=testTitle())
    points(testingPlot(),predict(lmModel(), testingData()), pch=15, col="blue")
    
  })
  
  output$help<-renderText({
    "This is an application aims at helping users to build simple regression models to predict the mpg, given a selected paticular feature.

1. Selection a feature:
A user may pick one of the features from a drop-down list to build a predictive model. Available feature include \"Number of cylinders\", \"Transmission Type\", \"Number of forward gears\", \"Displacement (cu.in.)\", \"Gross horsepower\", \"Rear alxe ratio\", \"Weight (lb/1000)\", \"1/4 mile time\", and \"Number of carburetors\".
If a user changes the selection of the feature, a new model will be created based on the user's selection. 
    
2. Select size of training dataset:
A use may use a slider to pick an appropriate size of the training dataset by partitioning the original dataset into to different subsets. The slider indicates the pecentage of the training dataset. We assume that the minimum of the training data will be 30% of the entire dataset, and the maximum of the training data will be 90% of th entire dataset.
If a user changes the selection of training dataset, the model will be re-trained, and the results will be shown in different plots.

3. Modeling Tab
The \"Modeling\" tab presents a plot that represents all data points in the training dataset(black dots), along with a blue line representing the linear model.

4. Model summary Tab
The \"Model Summary Tab\" presents a summary of the predictive model, given the selected feature and the size of training dataset.

5. Testing Tab
The \"Testing dataset\" presents a plot that represents the testing results of corresponding model. All the testing data are presented by the \"red dots\", while all predicted mpg values are presented by the \"blue squares\".
    
"
  })
  
})