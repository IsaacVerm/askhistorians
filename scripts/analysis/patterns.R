### preliminary

## packages

library(ggplot2)
library(dplyr)

## clean workspace

rm(list=setdiff(ls(), "base"))

## load data

load_path <- file.path(base,"output","data")

load(file.path(load_path, "comments_top_questions_alltime.RData"))
load(file.path(load_path, "top_questions_alltime.RData"))

### is length of answer awarded (naive attempt)?

## filter out removed comments

comments <- filter(comments, body != "[removed]")

## calculate length of answer

comments <- mutate(comments, length_answer = nchar(body))

## scatterplot: length_answer vs score

graph_lenghty_answers_rewarded <- ggplot(data = comments,
                                         aes(x = length_answer, y = score)) + geom_point(alpha = 0.1)

### is length of answer awarded (lengthy answers take time)?

## calculate time it took to post

# add time post was created to comments

comments <- left_join(x = comments,
                      y = select(top_questions, one_of(c("name","created"))),
                      by = "name")

# calculate time from creation for each post

comments <- mutate(comments, hours_since_creation = (created.x - created.y)/(60*60))

## what is a lengthy answer

graph_lengthy_answer <- ggplot(data = comments, aes(x = length_answer)) + geom_histogram(binwidth = 200)

## scatterplot: time to answer vs score (taking into account length of answer)

graph_time_to_answer_score <- ggplot(data = comments,
                                     aes(x = hours_since_creation, y = score)) + geom_point(aes(colour = length_answer))

graph_length_takes_time <- ggplot(data = comments,
                                  aes(x = length_answer, y = hours_since_creation)) + geom_point() + scale_x_continuous(limits = c(2500, 17500))

graph_length_takes_times <- ggplot(data = filter(comments, length_answer > 2500),
                                   aes(x = hours_since_creation)) + geom_histogram(binwidth = 25)

### save

## graphs

graphs <- mget(ls()[grep(pattern = "graph_", x = ls())])

save_path_graphs <- file.path(base,"output","analysis","patterns")

mapply(ggsave, file = paste0(file.path(save_path_graphs, names(graphs)), ".png"), plot = graphs)

## reusable data

reusable <- c()

save_path_reusable <- file.path(base,"output","analysis","reusable data")

for(r in reusable) {
  save(list = r, file = paste0(save_path_reusable,"/", r, ".RData"))
}





