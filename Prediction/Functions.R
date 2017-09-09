# Functions.R

# Loading required Libraries
library(dplyr)
library(quanteda)

# Transfer to quanteda corpus format and break into sentences
fun.corpus = function(x) {
  corpus(unlist(segment(x,'sentences')))
}

# Tokenize
fun.tokenize = function(x,ngramSize=1,simplify = T) {
  char_tolower(
    quanteda::tokenize(x,
                       remove_numbers = TRUE,
                       remove_punct = TRUE,
                       remove_separators = TRUE,
                       remove_twitter = TRUE,
                       ngrams = ngramSize,
                       concatenator = " ",
                       simplify = simplify
                       )
  )
}

# Parse tokens from input text
fun.input = function(x) {
  # If empty input,put both words empty
  if(x == "") {
    input1 = data_frame(word == "")
    input2 = data_frame(word == "")
  }
  
    # Tokenize with same functions as training data
    if(length(x)==1) {
      y = data_frame(word=fun.tokenize(corpus(x)))
    }
      # If only one word, put first word empty
      if(nrow(y)==1){
        input1 = data_frame(word = "")
        input2 = y
      }
        # Get last 2 words
        else if(nrow(y)>=1) {
          input1 = tail(y, 2)[1, ]
          input2 = tail(y, 1)
        }
  # Return data frame of inputs
  inputs = data_frame(words = unlist(rbind(input1,input2)))
  return(inputs)
}

# Predicting using Stupid Backoff Model
fun.predict = function(x,y, n=100){
  # predict using the top 1-gram words if no input given
  if(x == "" & y == "") {
    prediction = dftrain1 %>%
      dplyr::select(NextWord, freq)
  }
  
  # Predict using 3-gram model
    else if(x %in% dftrain3$word1 & y %in% dftrain3$word2) {
      prediction = dftrain3 %>% 
        filter(word1 %in% x & word2 %in% y) %>%
        dplyr::select(NextWord, freq)
    }
    # Predict using 2 gram model
      else if(y %in% dftrain2$word1) {
        prediction = dftrain2 %>% 
          filter(word1 %in% y) %>%
          dplyr::select(NextWord, freq)
      }
      # If no prediction found, predict the top 1-gram words
        else {
          prediction = dftrain1 %>%
            dplyr::select(NextWord, freq)
        }
  # Return predicted word in a data frame
  return(prediction[1:n, ])
}

