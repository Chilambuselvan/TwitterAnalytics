#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sentiment Analysis"), #Title
  textOutput("currentTime"),   #Here, I show a real time clock
  h4("Tweets:"),   #Sidebar title
  sidebarLayout(
    sidebarPanel(
      dataTableOutput('tweets_table') #Here I show the users and the sentiment
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
          sidebarPanel(
        plotOutput("neutral_wordcloud") #Cloud for neutral words
      ))
  )
))
