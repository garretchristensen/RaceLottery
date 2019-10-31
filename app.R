library(shiny)
library(tidyverse)
library(dplyr)
library(tibble)
library(ggplot2)
library(readxl)


#####################################################
#SET EVERYTHING UP BEFORE DOING THE SHINY PART
#######################################################
n<-125 #SET THE TOTAL NUMBER TO PICK
#I COULD MAKE THIS AN INTERACTIVE PART TOO LATER

temp<-read.csv("./fakedata.csv", stringsAsFactors = FALSE) #LOAD THE DATA
df<-as_tibble(temp)
#THERE IS SOME STUPID NON-ASCII CHARACTER BEGINNING-OF-FILE 
#NONSENSE GOING ON HERE
#CHEAP WORKAROUND IS JUST TO MAKE SURE FIRST_NAME IS NOT THE FIRST VARIABLE!
#names(df) <- iconv(names(df), to='ASCII', sub='')
#df$First_Name<-df$..First_Name

df$fullname<-paste( df$First_Name, df$Last_Name, sep=" ", collapse = NULL)
head(df)

#NUMBER OF MEN AND WOMEN APPLICANTS
n_men_app=nrow(men<-df[which(df$gender=="M"),])
n_women_app=nrow(women<-df[which(df$gender=="F"),])

#WHO HAS MORE APPLICANTS AND WOULD GET THE ODD SLOT, IF APPLICABLE?
if (n_men_app > n_women_app) {
  largest<-"men"
} else {
  largest<-"women"
}

#FIRST, DO WE EVEN HAVE TO BOTHER RUNNING A LOTTERY?
if (n_men_app+n_women_app<n) {
  print ("THERE IS NO REASON TO RUN A LOTTERY! Everyone gets in!")
  n_women_pick<-n_women_app
  n_men_pick<-n_men_app
  knitr::knit_exit()
} else {
  
  #IS THE ENTRY CAP EVEN?
  #IF SO, WHICH SEX HAS MORE APPLICANTS?
  #AND DO WOMEN HAVE ENOUGH APPLICANTS?
  if((n %% 2) == 0) {
    #print("Entry cap is even.")
    #CAP IS EVEN
    #DO WOMEN HAVE ENOUGH APPLICANTS?
    if (n_women_app>=n/2) {
      #print("Women have enough applicants to fill their race.")
      #YES THEY DO
      n_women_pick<-n/2
      n_men_pick<-n/2
    }   else {
      #print("Women don't have enough applicants to fill their race.")
      #NO THEY DON'T, GIVE EXTRA SLOTS TO MEN
      n_women_pick<-n_women_app
      n_men_pick=n-n_women_pick
    }
  } 
  
  #IS THE ENTRY CAP ODD?
  #IF SO, WHICH SEX HAS MORE APPLICANTS?
  #AND DO WOMEN HAVE ENOUGH APPLICANTS? 
  #NOTE WE DON'T CHECK IF MEN HAVE ENOUGH--IT'S ASSUMED.
  if ((n %% 2) == 1) {
    #print("Entry cap is odd.")
    if (n_women_app>n/2) {
      #print("Women have enough applicants to fill their race.")
      
      if (n_men_app>n_women_app) {  
        #print("Men have more applicants and get the rounding slot.")
        n_men_pick<-round((n/2+.00001), digits = 0)
        n_women_pick<-round((n/2)-1, digits = 0)
      } else {
        #print("Women have at least equal applicants and get the rounding slot.")
        n_women_pick<-round((n/2+.00001), digits = 0)
        n_men_pick<-round((n/2)-1, digits = 0)
      } #END WOMEN HAVE ENOUGH
    } else {
      #print("Women don't have enough applicants to fill their race.")
      n_women_pick<-n_women_app
      n_men_pick=n-n_women_pick
    }  
  }
  
} # END OVERALL NEED TO RUN LOTTERY

#For 2020 nobody has unsuccessful applications, this is the first lottery
df$Applications<-0 

#k is defined according to the following rule:
# k=0 if finishes==0
#k=0.5 if finishes==1
#k=1 if finishes==2
#k=1.5 if finishes==3
#k=1 if finishes>=4
df$k <- ifelse(df$Previous_Finishes==0 , 0,
               ifelse(df$Previous_Finishes==1,  0.5,
                      ifelse(df$Previous_Finishes==2, 1, 
                             ifelse(df$Previous_Finishes==3, 1.5,
                                    ifelse(df$Previous_Finishes>=4, 1, 0)))))
#Tickets=2^(n+k+1)+2ln(v+t+1) where n, k, v, and t are defined as follows:
df$tickets <-2^(df$k+df$Applications+1) + 2*log(df$Volunteer_Shifts+
                                                 df$Extra_Trailwork+1)

#SPLIT THE DATA INTO MENS AND WOMENS
men<-df[which(df$gender=="M"),]
women<-df[which(df$gender=="F"),]


##############################################################
#THE SHINY PART
ui<-fluidPage(
  includeMarkdown("include.md"),  
  # Copy the line below to make a number input box into the UI.
  numericInput("num", label = h3("Enter the seed"), value = NULL),
  
  hr(),
  fluidRow(verbatimTextOutput("value")),
  #what do I have to do to get this printed above the data tables?
  mainPanel(paste("2020 High Lonesome Lottery Winners")),
  fluidRow(dataTableOutput("women")),
  #and something inbetween them would be nice.
  fluidRow(dataTableOutput("men"))
  
)

server<- function(input, output) {
    # You can access the value of the widget with input$num, e.g.
    output$value <- renderPrint({ input$num 
      set.seed(input$num) #SET THE SEED WITH DICE!
    
      #dplyr function sample_n will work with weights, normalize automatically
      #syntax:sample_n(tbl, size, replace = FALSE, weight = NULL, .env = NULL, ...)
      #Run the separate lotteries
      women_winners<-sample_n(women, n_women_pick, replace = FALSE, weight=women$tickets)
      men_winners<-sample_n(men, n_men_pick, replace = FALSE, weight=men$tickets)
      
      women_winners_names<-women_winners$fullname
      men_winners_names<-men_winners$fullname
      write.csv(women_winners_names)
      write.csv(men_winners_names)
      #Print the winners' names
      output$women <- renderDataTable(women_winners_names)
      output$men <- renderDataTable(men_winners$fullname) 
      
    })
}

shinyApp(ui = ui, server = server)

