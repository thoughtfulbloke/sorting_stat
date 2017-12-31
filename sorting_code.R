library(rtweet)
library(dplyr)

# This is written on the assumption that R users have set the working directory
# to the folder containing the csv file, know how to use the rtweet package,
# have created an authorisation token called twitter_token,
# and can change the user part of the next line 

evidence <- get_timeline(user="your_account_goes_here", n=1000, token=twitter_token)

compare_with <- read.csv("corpus_people.csv") %>% mutate(isSortee = FALSE)

candidate <- evidence %>% 
  mutate(has_external_links = !is.na(urls_url),
         has_reply = !is.na(reply_to_screen_name),
         has_reply_to_self = screen_name == reply_to_screen_name & !is.na(reply_to_screen_name),
         has_retweet = !is.na(quoted_status_id) | !is.na(retweet_status_id)) %>%
  group_by(screen_name) %>%
  summarise(
    slyth = sum(has_reply & !has_reply_to_self) / n(),
    huffl = sum(has_retweet) / n(),
    raven = sum(has_external_links & !has_retweet) / n(),
    griff = (n() - sum(has_reply |
                         has_retweet |
                         has_external_links |
                         has_reply_to_self)
    ) / n()
  )  %>% mutate(isSortee = TRUE)


slyth <- bind_rows(compare_with, candidate) %>% arrange(slyth) %>% select(slyth,isSortee)
Sly <- round(which(slyth$isSortee)/nrow(slyth),3)

griff <- bind_rows(compare_with, candidate) %>% arrange(griff) %>% select(griff,isSortee)
Gry <-  round(which(griff$isSortee)/nrow(griff),3)

huffl <- bind_rows(compare_with, candidate) %>% arrange(huffl) %>% select(huffl,isSortee)
Huf <- round(which(huffl$isSortee)/nrow(huffl),3)

raven <- bind_rows(compare_with, candidate) %>% arrange(raven) %>% select(raven,isSortee)
Rav <- round(which(raven$isSortee)/nrow(raven),3)

result <- data.frame(House = c("Slytherin", "Gryffindor", "Hufflepuff", "Ravenclaw"),
                     Proportion = c(Sly, Gry, Huf, Rav)) %>% arrange(-Proportion) %>%
  mutate(Score = round(100 * Proportion/ sum(Proportion),1))
result
