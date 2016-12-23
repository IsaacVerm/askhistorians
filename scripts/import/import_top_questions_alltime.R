### preliminary

## packages

library(jsonlite)
library(data.table)
library(anytime)

## remarks

### import top questions

## function to get top questions

get_top_questions <- function(after) {
  
                      # base url
  
                      base_url <- "https://www.reddit.com/r/AskHistorians/top/.json?sort=top&t=all&limit=100&after="
                      
                      # get json
                      
                      questions <- fromJSON(paste0(base_url,after))
                      
                      # get last id
                      
                      last_question_ind <- nrow(questions[["data"]][["children"]])

                      last_id <- questions[["data"]][["children"]][["data"]][["name"]][last_question_ind]
                      
                      # return
                      
                      result <- list(questions,last_id)
                      names(result) <- c("questions","last_id")
                      
                      return(result) }

## import

questions <- get_top_questions(after = "")

nr_comments <- 1000

while(length(questions) < nr_comments/50)  {
  
            Sys.sleep(3)
  
            additional_questions <- get_top_questions(after = questions[[length(questions)]])
  
            questions <- c(questions, additional_questions) }

### clean top questions

## remove last ids

questions <- questions[-grep(pattern = "last_id", x = names(questions))]

## information available

names(questions[[1]][["data"]][["children"]][["data"]])

## extract interesting information

# interesting variables

interesting_var <- c("selftext","gilded","author","name","score","over_18","edited","link_flair_css_class",
                     "author_flair_css_class","archived","url","author_flair_text","title","link_flair_text",
                     "num_comments","ups","created")

# extract

interesting_info <- lapply(questions,
                           function(x) {
                                        df <- as.data.frame(lapply(interesting_var,
                                                                   function(y) x[["data"]][["children"]][["data"]][[y]]))
                                        names(df) <- interesting_var
                                        
                                        return(df)
                                        }
                           )

## bind as dataframe

top_questions <- rbindlist(interesting_info)

## correct data types

# date

top_questions$created <- anytime(top_questions$created)

### save

save(top_questions, file = file.path(base,"output","data","top_questions_alltime.RData"))

