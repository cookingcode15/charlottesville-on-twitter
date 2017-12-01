# new file, Rscript

# working directory

# declare packages
library(tidyverse)
library(lubridate)

# bring data in - 5 csvs and combine into one dataset - is the working directory the same as the folder that 
# called in list.files?

files <- list.files("charlottesville-on-twitter/",pattern = "csv")
files

#combining all csv files into a dataset called tweets
tweets <- do.call(rbind,lapply(paste0("charlottesville-on-twitter/",files[1:4]),read.csv))
tweets

# take a look at the dataset, gives us observatons and variables (24), str() is better because there is no error?
glimpse(tweets)
str(tweets)

# set up so we don't have to read tweets everytime
saveRDS(tweets,"tweets.rds")

# call tweets.rds - i would like to understand what rds does exactly
tweets <- readRDS("tweets.rds")

# take a look at all column names
#resource used: https://blog.exploratory.io/selecting-columns-809bdd1ef615
colnames(tweets)
# i know i want to remove the unneeded columns - id, "user_profile_background_color", "user_location" ,"user_profile_text_color"
# "quoted_status_text" 

#just in case - call dplyer
library(dplyr)
#remove / drop columns - this didn't work BUT idk why
tweets %>% select(-id, -user_profile_background_color, -user_location,-user_profile_text_color, -quoted_status_text)

#remove columns 2nd way
tweets$id <- NULL
tweets$user_profile_text_color <- NULL
tweets$user_profile_background_color <- NULL
tweets$user_location <- NULL
tweets$quoted_status_id <- NULL

# look at existing names so we can change them
names(tweets)
names(tweets)[7]<- "followers"
names(tweets)[6]<- "following"
names(tweets)[9]<- "time zone"
names(tweets)[4]<- "totaltweets"
names(tweets)[5]<- "totallikes"
names(tweets)[16]<- "repliesto"
names(tweets)[12]<- "retweet"
names(tweets)[1]<- "userid"
names(tweets)[8]<- "description"
names(tweets)[10]<- "text"
names(tweets)[11]<- "time_created"
names(tweets)[13]<- "retweet_text"
names(tweets)[14]<- "retweet_id"
names(tweets)[15]<- "quote_retweet"
names(tweets)[17]<- "reply_to_tweet"
names(tweets)[18]<- "reply_to_user_id"


# values for each column must make sense
str(tweets)


#description as character not factor, change this.
tweets$description = as.character(tweets$description)
tweets$description

#text column as character for tweets
tweets$text = as.character(tweets$text)

#reopened project but tweets is not in global environment and neither is the tweets.csv. Did I need to save that?
#check for NA's in columns
head(tweets)
tail(tweets)
any(is.na(tweets))

#save tweets as csv
write.csv(tweets)

#check columns with all na's as appears in str()
sum(is.na(tweets))
#check total columns that have the most NA's
colSums(is.na(tweets))
#remove the columns with the NA's - do this once so the numbers won't change. This is the incorrect syntax.Breaks the table up completely and thereis no more dataframe or csv. fuck. I have ruined the table on tweets because of this exercise and have to start over again.won't get logicals, correct?
tweets <- tweets[-17]
tweets <- tweets[-13]
tweets <- unlist(tweets[-14])
tweets <- tweets[-18]

colnames(tweets)
# REMOVE the NA's in the following columns:
tweets$retweet_id <- NULL
tweets$retweet_text <- NULL
tweets$reply_to_tweet <- NULL
tweets$reply_to_user_id <- NULL

#retweet table - only has 'f' which won't give us a clear indication of the number of retweets (it is a 
#factor with 1 level so i will remove the column)
class(tweets$retweet)
str(tweets$retweet)
tweets$retweet <- NULL

#look at quote retweet colunm, it is a factor but we want a character 
class(tweets$quote_retweet)
tweets$quote_retweet = as.character(tweets$quote_retweet)
tweets$quote_retweet

#finding blank entries on quote retweet - is this the same as NA or null. 
tweets$quote_retweet[is.na(tweets$quote_retweet)] #gives us character(0)

# look at replies to column 
str(tweets$repliesto) #factor with 5568 levels - want to change this to character
tweets$repliesto = as.character(tweets$repliesto)
tweets$repliesto #lots of empty "" - what can I do to clean this up more?

#replace "" in repliesto column with none
#gsub obviously didn't work and I ran the code and found there is no undo command. Not good.
is.na(tweets$repliesto)
#http://uc-r.github.io/missing_values#na_test used this.
colSums(is.na(tweets))
#Questions
# says 0 for all. but what about the Null and the blanks spaces - that is different than missing values. That
# is what I do not understand and need to understand. It's not an NA value, it is just blank. Or it says Null. I can't find how to deal with 
# that. Change character back to factor? I don't know! An example is the blank spaces in repliesto and hashtag columns. The 
# Null is the time zone. 

# Also, I want to get rid of the characters that are emoji so the text is clear: an example: Pres. Trump lashes out at the <e4><f3><d6>alt-left' - the
# <e4><f3><d6> commands I want to remove but not the text.

#Questions: how can i change the time zone 'null' to OFF
#Questions: how can I remove unwanted <> characters in text/retweet text?
#Questions: How can I find the empty Quote Retweet numbers?
write.csv(tweets, "tweets.csv")
#How do I save this document called tweets.csv in my local directory
# Why is git showing the wrong location and my entire computer (again)?
# Will I ever get this? 