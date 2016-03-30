library(shiny)
library(dplyr)
library(readr)
library(scales)
library(googleAuthR)
library(googleAnalyticsR)

check <- read.csv("gacheck.csv", stringsAsFactors = FALSE)

check <- data.frame(check, stringsAsFactors = FALSE)



shinyServer(function(input, output) {
  

  data1 <- eventReactive(input$do_ga, {
    #Marketing Reporting based on Refcodes

    options(googleAuthR.httr_oauth_cache = "token.auth") 
    
    gar_auth()
    
    start <- input$monthdate[1]
    end <- input$monthdate[2]

    withProgress(message = 'Grabbing GA Data.  Please wait...', value = 1, {
      # Number of times we'll go through the loop
      n <- nrow(check)
      

    res <- lapply(1:nrow(check), function(i) {
      
      ga_data <- google_analytics(check$profile[i], start = start, end = end,
                        dimensions = "ga:yearMonth",
                        metrics = "ga:sessions",
                        filters = check$filters[i])
      cbind(site = check$site[i],id = check$profile[i], source = check$source[i], ga_data)

    })

    
    })
    
    res <- data.table::rbindlist(res)
    
    projection <- comma_format()(round((res$sessions/(day(Sys.Date())-1))*as.numeric(days_in_month(Sys.Date())), digits = 0))
    
    res$sessions <- comma_format()(res$sessions)
    
    res <- cbind(res,projection)
    
    
    
})

    
output$table1 <- DT::renderDataTable({
  if (is.null(data1())) return(NULL)
  DT::datatable(data1(), options = list(paging = FALSE))


}
)

output$downloadData <- downloadHandler(
    filename = function() {
      paste('ga_data', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      write.csv(data1(), file)
    },
    contentType = "text/csv"
    )
   
})


