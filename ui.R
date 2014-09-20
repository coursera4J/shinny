shinyUI(pageWithSidebar(
  
  headerPanel("Motor Trend Data Regression Modeling"),
 
  
  sidebarPanel(
    helpText("A user may select one of the feature from the following list to build a linear regression model to predict the mpg value."),
    
    selectInput("variable", "Feature Selection:",
                list("Number of cylinders" = "cyl", 
                     "Transmission Type" = "am", 
                     "Number of forward gears" = "gear",
                     "Displacement (cu.in.)" = "disp",
                     "Gross horsepower" = "hp",
                     "Rear alxe ratio" = "drat",
                     "Weight (lb/1000)" = "wt",
                     "1/4 mile time" = "qsec",
                     "Number of carburetors" = "carb"
                     )
                ),

    sliderInput("training", 
                "Training data (% of entire dataset):", 
                value = 60,
                min = 30, 
                max = 90),
    helpText("The slider above provides a convenienct way of partitioning the orginal mtcars dataset into two different subsets, for the purpose of training the model and testing the model respectively. We assume that the reasonable size of training data is between 30% and 90% of the entire dataset.")
    
  ),
  
       
  mainPanel(
    tabsetPanel(
      tabPanel("Modeling", plotOutput("modelPlot")), 
      tabPanel("Model Summary", tableOutput("regTab")), 
      tabPanel("Testing", plotOutput("testingPlot")),
      tabPanel("Help", verbatimTextOutput("help")))
    )
))