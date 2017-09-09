#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# server.R ####
# Coursera Data Science Capstone Project (https://www.coursera.org/course/dsscapstone)
# Shiny server script
# 2016-01-23

# Libraries and options ####
source('Functions.R')

library(shiny)

# Define application ####

shinyServer(function(input, output) {
  
  # Reactive statement for prediction function when user input changes ####
  prediction =  reactive( {
    
    # Get input
    inputText = input$text
    input1 =  fun.input(inputText)[1, ]
    input2 =  fun.input(inputText)[2, ]
    nSuggestion = input$slider
    
    # Predict
    prediction = fun.predict(input1, input2, n = nSuggestion)
  })
  
  # Output data table ####
  output$table = renderDataTable(prediction(),
                                 option = list(pageLength = 5,
                                               lengthMenu = list(c(5, 10), c('5', '10')),
                                               columnDefs = list(list(visible = F, targets = 1)),
                                               searching = F
                                 )
  )
  
  # Output word cloud ####
  wordcloud_rep = repeatable(wordcloud)
  output$wordcloud = renderPlot(
    wordcloud_rep(
      prediction()$NextWord,
      prediction()$freq,
      colors = brewer.pal(8, 'Dark2'),
      scale=c(4, 0.5),
      max.words = 300
    )
  )
})

  
