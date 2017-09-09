library(tidyr)
library(caTools)
## Setting the working directory and loading the data
setwd("~/Documents/R /final/en_US")

# Loading the blog data
fileName="en_US.blogs.txt"
con=file(fileName,open="r")
lineBlogs=readLines(con)
close(con)

# Loading the news data
fileName="en_US.news.txt"
con=file(fileName,open="r")
lineNews=readLines(con)
close(con)

# Loading the twitter data
fileName="en_US.twitter.txt"
con=file(fileName,open="r")
lineTwitter=readLines(con)
close(con)

## Data Cleaning and Tokenization
# Combining and sampling the data
combinedLines = c(lineBlogs,lineNews,lineTwitter)
set.seed(2017)

n = 1/1000
combined = sample(combinedLines, length(combinedLines)*n)

# Spliting the data
split = sample.split(combined,0.8)
train = subset(combined, split == T)
test = subset(combined, split == F)

# Convert into quanteda corpus format and data processing
train=fun.corpus(train)

# Tokenization
train1 = fun.tokenize(train)
train2 = fun.tokenize(train, 2)
train3 = fun.tokenize(train, 3)

# Freqency Table
fun.frequency = function(x, minCount = 1) {
  x = x %>% 
    group_by(NextWord) %>%
    summarize(count = n()) %>%
    filter(count >= minCount)
  x = x %>% 
    mutate(freq = count/sum(x$count)) %>%
    dplyr::select(-count) %>%
    arrange(desc(freq))
}

dftrain1 = data.frame(NextWord = train1)
dftrain1 = fun.frequency(dftrain1)

dftrain2 = data.frame(NextWord = train2)
dftrain2 = fun.frequency(dftrain2) %>%
  separate(NextWord, c('word1', 'NextWord')," ")

dftrain3 = data.frame(NextWord = train3)
dftrain3 = fun.frequency(dftrain3) %>%
  separate(NextWord, c('word1','word2','NextWord')," ")

# Filtering out profanities
dirty7 <- c('shit', 'piss', 'fuck', 'cunt', 'cocksucker', 'motherfucker', 'tits')
dftrain1 <- filter(dftrain1, !NextWord %in% dirty7)
dftrain2 <- filter(dftrain2, !'word1' %in% dirty7 & !NextWord %in% dirty7)
dftrain3 <- filter(dftrain3, !'word1' %in% dirty7 & !'word2' %in% dirty7 & !NextWord %in% dirty7)

# Save the data to disk
saveRDS(dftrain1, file = 'dftrain1.rds')
saveRDS(dftrain2, file = 'dftrain2.rds')
saveRDS(dftrain3, file = 'dftrain3.rds')


