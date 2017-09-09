# ui.R 
# Coursera Data Science Capstone Project (https://www.coursera.org/course/dsscapstone)
# Shiny UI script
# Clifford D'costa
# 09/10/17

# Libraries and options ####
library(shiny)
library(shinythemes)

# Define the app ####

shinyUI(fluidPage(
  
  # Theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Word Predictor"),
  
  # Sidebar ####    
  sidebarLayout(
    
    sidebarPanel(
      
      # Text input
      textInput("text", label = ('Please enter some text'), value = ''),
      
      # Number of words slider input
      sliderInput('slider',
                  'Maximum number of words',
                  min = 0,  max = 10,  value = 5
      )),
  
     
    
    # Mainpanel ####
    
    mainPanel(
      
      wellPanel(
        h4("Instructions"),
        p("1. Enter a partially complete text in the text box."),
        p("2. Use the slider to choose the number of predicted words."),
        p("3. The next predicted word will be displayed in a table below."),
        
        # Link to report
        helpText(a('More information on the app',
                   href='http://rpubs.com/cdcosta17/PredictionSlideDeck', 
                   target = '_blank')
        )
        
        ),
        # Table output
        dataTableOutput('table'))
        
      )
    ) 
  )


