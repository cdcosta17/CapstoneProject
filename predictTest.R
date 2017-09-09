# Input text sample 
inputText = 'back to'

# Get inputs as separate strings
input1 = fun.input(inputText)[1, ]
input2 = fun.input(inputText)[2, ]
input1
input2

# Predict
nSuggestions = 5
fun.predict(input1, input2,5)


# Prediction without dplyr ####
fun.predict2 <- function(x, y, z = nSuggestions) {
  
  # Predict giving just the top 1-gram words, if no input given
  if(x == "" & y == "") {
    prediction = dftrain1$NextWord
    
    # Predict using 3-gram model
  }   else if(x %in% dftrain3$word1 & y %in% dftrain3$word2) {
    prediction = subset(dftrain3, dftrain3$word1 %in% x & dftrain3$word2 %in% y, NextWord)
    
    # Predict using 2-gram model
  }   else if(y %in% dftrain2$word1) {
    prediction = subset(dftrain2, dftrain2$word1 %in% y, NextWord)
    
    # If no prediction found before, predict giving just the top 1-gram words
  }   else{
    prediction <- dftrain1$NextWord
  }
  
  # Return predicted word in a data frame
  return(prediction[1:z])
}