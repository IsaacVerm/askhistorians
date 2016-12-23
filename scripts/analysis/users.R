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

### which users contributed the most?

## calculate contribution as number of comments

comments_by_user <- comments %>% 
                            filter(author!="[deleted]") %>% 
                                    group_by(author) %>% 
                                            summarize(nr_comments = n()) %>% 
                                                    arrange(desc(nr_comments))

## calculate contribution as number of questions contributed to

# absolute number

question_contributions_by_user <- comments %>% 
                                            filter(author!="[deleted]") %>% 
                                                    group_by(author) %>%
                                                            summarize(nr_questions = n_distinct(name)) %>%
                                                                  arrange(desc(nr_questions))

# relative number as percentage of all top questions

question_contributions_by_user <- question_contributions_by_user %>%
                                              mutate(perc_questions = nr_questions / nrow(top_questions)) %>%
                                                    arrange(desc(perc_questions))

## join both types of contributions

contributions_by_user <- left_join(x = comments_by_user,
                                   y = question_contributions_by_user,
                                   by = "author")

## graph

# only select top 20 contributors

contributions_by_top_user <- contributions_by_user[1:20, ]

# graph

graph_user_contributions <- ggplot(data = contributions_by_top_user,
                                   aes(x = nr_comments, y = nr_questions)) + 
                                   geom_point(colour = "grey50") +
                                   geom_text(aes(label = author), size = 2, hjust = "inward")

### save

## graphs

graphs <- mget(ls()[grep(pattern = "graph_", x = ls())])

save_path_graphs <- file.path(base,"output","analysis","users")

mapply(ggsave, file = paste0(file.path(save_path_graphs, names(graphs)), ".png"), plot = graphs)



