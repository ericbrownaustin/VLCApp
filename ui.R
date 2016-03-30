library(shinydashboard)
library(formattable)
library(shinyIncubator)
library(lubridate)


dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Visits & Leads Breakdown"),
  dashboardSidebar(
    


    (
    dateRangeInput('monthdate',
                   label = 'Date range input: yyyy-mm-dd',
                   start = Sys.Date()-1, end = Sys.Date()-1
    )),

    actionButton("do_ga", "Go!")
    
  ),
  
  dashboardBody(
    downloadButton('downloadData', 'Download'),
    DT::dataTableOutput("table1"),
    
    textOutput("text1")
    
  ))
