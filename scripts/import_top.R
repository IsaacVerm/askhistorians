### preliminary

## packages

library(jsonlite)

## remarks

### import top questions

## function to get questions

get_top_questions <- function(after) {
  
                      # base url
  
                      base_url <- "https://www.reddit.com/r/AskHistorians/top/.json?sort=top&t=all&limit=100&after="
                      
                      # get json
                      
                      questions <- fromJSON(paste0(base_url,after))
                      
                      # get last id
                      
                      last_question_ind <- nrow(questions[["data"]][["children"]])

                      last_id <- questions[["data"]][["children"]][["data"]][["id"]][last_question_ind]
                      
                      # return
                      
                      result <- list(questions,last_id)
                      names(result) <- c("questions","last_id")
                      
                      return(result) }

test <- get_top_questions(after = "")

## repeat function to get more posts

questions <- get_top_questions()
questions <- c(questions, get_top_questions(after = questions[["last_id"]])


### import comments