### preliminary

## packages

library(ggplot2)
library(dplyr)
library(chron)
library(tm)
library(wordcloud)

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

### is length of answer awarded (content disappears quickly)?

## calculate time it took to post

# add time post was created to comments

comments <- left_join(x = comments,
                      y = select(top_questions, one_of(c("name","created"))),
                      by = "name")

# calculate time from creation for each post

comments <- mutate(comments, hours_since_creation = (created.x - created.y)/(60*60))

## relate score to time post was created

graph_content_disappears <- ggplot(data = comments,
                                   aes(x = hours_since_creation, y = score)) +
                            geom_point() +
                            scale_x_continuous(limits = c(0,125))

### is length of answer awarded (longer answers take more time)?

## graph 

quality_takes_time <- ggplot(data = comments,
                             aes(x = length_answer, y = hours_since_creation))

graph_quality_takes_time <- quality_takes_time + geom_point()

graph_quality_takes_time_24h <- quality_takes_time + 
                                scale_y_continuous(limits = c(0,48)) +
                                geom_point(alpha = 0.1)

### do weekend posts have an advantage?

## frequency posts by weekday

posts_by_weekday <- as.data.frame(table(weekdays(top_questions$created)))

names(posts_by_weekday) <- c("day","frequency")

## graph

graph_weekend_advantage <- ggplot(data = posts_by_weekday,
                                  aes(x = day, y = frequency)) + geom_bar(stat = "identity")

### what type of questions are popular?

## preprocessing text

# corpus

titles <- Corpus(VectorSource(top_questions$title))

# remove superfluous info (punctuation,...)

titles <- titles %>% 
                tm_map(function(x) iconv(x, to = "UTF-8", sub = "byte")) %>%
                        tm_map(removePunctuation) %>% 
                                  tm_map(tolower) %>% 
                                            tm_map(removeNumbers) %>% 
                                                    tm_map(removeWords, stopwords("english")) %>%
                                                            tm_map(stemDocument) %>%
                                                                    tm_map(stripWhitespace)

# treat as text

titles <- tm_map(titles, PlainTextDocument)

# stage

dtm_titles <- DocumentTermMatrix(titles)

## wordcloud

# calculate word frequency

word_freq <- sort(colSums(as.matrix(dtm_titles)), decreasing = TRUE)

# graph

png(file = file.path(base,"output","analysis","patterns","graph_titles_wordcloud.png"))
wordcloud(words = names(word_freq[1:100]),
          freq = word_freq[1:100])
dev.off()

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





