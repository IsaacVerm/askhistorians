### preliminary

## packages

library(jsonlite)

## remarks

### load post

top_post <- fromJSON("https://www.reddit.com/r/AskHistorians/comments/4xj6fc/michael_phelps_beat_a_2000_year_old_olympic/.json?limit=500")

### extract comments

## variables of interest

interesting_var <- c("author","parent_id","score","body","author_flair_css_class","author_flair_text")

## put json comments in searchable format

# just a vector

top_post <- unlist(top_post)

# only end of tree is important

names(top_post) <- lapply(X = strsplit(names(top_post), split = "\\."),
                          FUN = function(x) x[length(x)])

## turn variables of interest into regex

regex_interesting_var <- paste0(interesting_var,"\\d+|",interesting_var,"\\b")

## extract

length(top_post[grep(pattern = regex_interesting_var[6], names(top_post))])
