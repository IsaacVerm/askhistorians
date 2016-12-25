# Questions

* What type of questions are most popular?
	* time period
	* short/long
	* nsfw
* Is length of answer awarded?
* Who has the most/longest answers?
* How many comments are removed?
* How fast do questions get an answer?

# Patterns

## Is length of answer awarded?

![](/output/analysis/patterns/graph_lenghty_answers_rewarded.png?raw=true)

There seems to be a slightly negative correlation between the length of an answer (displayed as number of characters) and the score the answer gets. We would expect the opposite. Longer answers are probably higher quality (not a certainty off course but we can imagine more sources being incorporated, etc...). I can see two reasons how this could be the case:

* either quality lenghty answers just don't get the recognition they deserve
* or writing lengthy answers takes time and in the mean time other answers already got the bulk of the attention

I'm more inclined toward the second reason. The Reddit system is such that content disappears relatively quickly as demonstrated by the following graph:

![](/output/analysis/patterns/graph_content_disappears.png?raw=true)

The earlier a comment is posted, the higher the probability that comment gets a high score (and so is visible as relevant to other users). After 24 hours the chances of a post getting some visibility become really slim. 

So a reasonable assumption would be that writing long answers takes time and so these answers miss out on the early post visibility bonus. To check this we can relate the length of an answer to the number of hours after the original post was created:

![](/output/analysis/patterns/graph_quality_takes_time_24h.png?raw=true)

Shorter answers are really skewed towards being posted early on while longer answers seem less skewed in that direction. This might explain why we didn't find the obvious relation between score and length of answer. However, this is just a quick look at the data, I wouldn't be too surprised if I'm missing some profound insights here.

## Do weekend posts have an advantage?

Assuming people have more time during the weekend, do questions posed during the weekend have a higher chance of being picked up?

![](/output/analysis/patterns/graph_weekend_advantage.png?raw=true)

Seems not be the case, a small drop on Saturday can even be noticed.

## What type of questions are popular?

Just a Word cloud. 

![](/output/analysis/patterns/graph_titles_wordcloud.png?raw=true)

# Users

## Which users contributed the most?

Contributing in two senses:

* number of comments written
* number of questions contributed to

The following graph only focused on the top 20 users regarding number of comments written:

![](/output/analysis/users/graph_user_contributions.png?raw=true)

It's a bit of a pity there's some overlap of username labels but I don't think there's an easy way to solve this issue and having the names on the graph itself is kind of nice.

Georgy_K_Zhukov seems to be in another league than everyone else. Having made nearly a thousand comments in roughly 1/4 of all top questions asked by users is quite a feat. In no way I want to underestimate the work done by other users, it's just that there really is a gap of about 500 comments with the second contender.

## When do user answer questions?

We can look at this question in some different ways:

* high-level: overview of all questions
* favourite days
* favourite hours

### Overview

Let's start with plotting an overview of the time created for all top 20 users:

![](/output/analysis/users/graph_time_overview.png?raw=true)

There are not a lot of users displaying the same level of activity all through their posting career. Some people gave up (e.g. Algernon_Asimov) and some slowly increased their level of activity (e.g. Searocksandtrees). Once again Georgy_K_Zhukov stands out for having a consistent level of minimum output (and this for several years). To a somewhat lesser amount this is also the case for users like Tiako, vertexoflife, yodatsracist,... Good thing is some real good contributors joined recently (e.g. commiespaceinvader, sunagainstgold, Iphikrates, ...). 

### Favourite days

Let's dive a bit deeper in the timestamps. Do users have favourite days for commenting? This might not be 100% correct since users probably come from all kinds of different places (so the timestamp should in fact be in another timezone). 

![](/output/analysis/users/graph_time_favourity_days.png?raw=true)

Some users have their preferred days of posting. For yodatsracist commenting seems like a Monday thing, while for Georgy_K_Zhukov Thursday is the most productive day. I would have accepted to observe some kind of a weekend effect but this rarely seems to exist.

### Favourite hours

So some users have their favourite days to post, is there also variation in what hour is preferred?

![](/output/analysis/users/graph_time_favourity_hours.png?raw=true)

Some things catch the eye immediately:

* some people seem to never sleep (sunagainstgold)
* users come from different timezones, a large gap can be noticed for almost all users
* users don't seem to have a specific time they take the time to reply

# Disclaimer

I just took a quick glance at the data so I can in no way guarantee I haven't made any error. If you find anything wrong or just very much not to your liking, please let me know.
