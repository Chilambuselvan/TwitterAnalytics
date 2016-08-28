library(shiny) 
library(tm)
library(wordcloud)
library(twitteR)
library(RWeka)
library(ggplot2)


shinyServer(function(input, output, session) {
  consumerKey <- ""
  consumerSecret <- ""
  accessToken <- ""
  accessTokenSecret <- ""
  
  setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)

  output$currentTime <- renderText({invalidateLater(1000, session) #Here I will show the current time
    paste("Current time is: ",Sys.time())})
  KONESearch= searchTwitteR("accident+india",n=500,lang = "en",resultType = "recent")

#Convert List to Vector
KONESearch_text=sapply(KONESearch,function(x) x$getText())
#Create corpus from Vector

dat3 <- grep("KONESearch_text", iconv(KONESearch_text, "latin1", "ASCII", sub="KONESearch_text"))
# subset original vector of words to exclude words with non-ASCII char
KONESearch_text <- KONESearch_text[-dat3]

KONE_Corpus=Corpus(VectorSource(KONESearch_text))
# convert Lower case, remove numbers, remove stopwords, remove punctuation, strip whitespace
KONE_cleanText=tm_map(KONE_Corpus,removePunctuation)
KONE_cleanText=tm_map(KONE_cleanText,content_transformer(tolower))
KONE_cleanText=tm_map(KONE_cleanText,removeWords,c("safety"))
KONE_cleanText=tm_map(KONE_cleanText,removeWords,stopwords("en"))
KONE_cleanText=tm_map(KONE_cleanText,removeNumbers)
#KONE_cleanText=tm_map(KONE_cleanText,stemDocument)
KONE_cleanText=tm_map(KONE_cleanText,removePunctuation)
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm.bigram=TermDocumentMatrix(KONE_cleanText,control = list(tokenize=BigramTokenizer))

freq = sort(rowSums(as.matrix(tdm.bigram)),decreasing = TRUE)
freq.df = data.frame(word=names(freq), freq=freq)
head(freq.df, 20)
pal=brewer.pal(8,"Blues")
pal=pal[-(1:3)]

wordcloud(freq.df$word,freq.df$freq,max.words=100,random.color = TRUE,random.order = F)
wordcloud(KONE_cleanText)
ggplot(head(freq.df,15), aes(reorder(word,freq), freq)) +
  geom_bar(stat = "identity") + coord_flip() +
  xlab("Bigrams") + ylab("Frequency") +
  ggtitle("Most frequent bigrams")
#### Option 2
pal2 <- brewer.pal(8,"Dark2")
wordcloud(freq.df$word,freq.df$freq,min.freq=2,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)




})