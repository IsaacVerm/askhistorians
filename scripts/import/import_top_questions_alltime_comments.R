### preliminary

## packages

library(jsonlite)
library(anytime)
library(data.table)
library(pbapply)

## load data

load(file.path(base,"output","data","top_questions_alltime.RData"))

### function to extract comments

extract_comments <- function(url_post) {
  
        ## load post
  
        post <- fromJSON(paste0(url_post,".json?limit=500"))
        post <- post[2, ]
  

        ## variables of interest

        interesting_var <- c("author","score","body","author_flair_css_class","author_flair_text","created")

        ## put json comments in searchable format

        # just a vector

        post <- unlist(post)

        # only end of tree is important

        names(post) <- lapply(X = strsplit(names(post), split = "\\."),
                              FUN = function(x) x[length(x)])

        ## turn variables of interest into regex

        regex_interesting_var <- paste0(interesting_var,"\\d+|",interesting_var,"\\b")

        ## extract

        comments <- lapply(regex_interesting_var, function(x) post[grep(pattern = x, names(post))])

        names(comments) <- interesting_var
        comments <- as.data.frame(comments)
        
        return(comments) }

### function to clean comments

clean_comments <- function(comments) {

        ## correct type

        # character

        comments$author <- as.character(comments$author)
        comments$body <- as.character(comments$body)

        # numeric

        comments$score <- as.numeric(as.character(comments$score))

        # date

        comments$created <- anytime(as.numeric(as.character(comments$created))) 
        
        return(comments) }

### extract, clean and bind

## extract

# extract

comments <- pblapply(top_questions$url,
                   function(x) try(extract_comments(x)))

# remove failed requests

failed_requests_ind <- which(sapply(comments, class) == "try-error")

comments <- comments[-failed_requests_ind]

## clean

comments <- lapply(comments, function(x) clean_comments(x))

## bind

# add name so you know to what post it refers

comments <- mapply(function(comment_df,name) {comment_df[["name"]] <- name; return(comment_df)},
                   comment_df = comments,
                   name = top_questions$name[-failed_requests_ind],
                   SIMPLIFY = FALSE)

# bind

comments <- rbindlist(comments)

### save

save(comments, file = file.path(base,"output","data","comments_top_questions_alltime.RData"))

