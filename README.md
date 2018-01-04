# A Rstats Twitter sorting hat/ sorting stat.

As a result of a Twitter discussion, I have put together some code that analyses a Twitter timeline and sorts the account into a Hogwarts House (see Harry Potter books for inspiration).

This is expressly not for everyone, it is intended for R using Twitter people who are comfortable using the rtweet package to download (up to) the last 1000 posts for an account.

The code then sorts them on the basis of how the account compares to accounts found by searching for the use of the hash-tag #rstats. This, then, does not reflect Twitter generally, instead only the rstats part (but Hogwarts is for wizards so there is thematic justification). But in terms of inherent biases in the data, it is based on the 1298 unique accounts I found searching for the last 2000 Tweets containing #rstats.

In examining the source data, I noticed the accounts included "feed" accounts making announcements which did not engage in interaction with the community. So I then excluded those accounts where replies to others was less than 1% of the collected tweets. The 1084 accounts used are in the csv file "corpus_people.csv", and the accounts I have excluded are in the file "corpus_excluded.csv". If you want to run it with the full data just combine together the csv files when loading the corpus(es).

I invented a metric for each house, and calculated it for each account. The "sort" takes place by working out the metrics for a nominated account and sees how it compares to the over #rstats community. If you ever want to rebuild the corpus, just run the code for calculating the metrics on a whole bunch of accounts.

## The sorting stat (I mean hat) metrics

For each house, there is a semi-exclusive (there is some overlap) calculation 

### Slytherin

The metric for Slytherin is the proportion of tweets that are replies to someone else- this is based on the premise that Slytherin are interested in building and maintaining personal networks. Replies to self are excluded as such tweets tend to be run on thoughts.

I am 0.984 Slytherin, which is another way of say I am in the top 2% of people who reply to others in their network (compared to #rstats folk)

### Gryffindor

Gryffindor is based on original tweets (tweets that are not replies nor retweets). What is said is not measured, only the boldness in saying it.

I am 0.846 Gryffindor, which is to say I post a great deal more original posts than other #rstats users (but make no claims as to the relative quality).

### Ravenclaw

Ravenclaw is characterized by study, and is represented by the proportion of tweets that contain a link to a site outside of Twitter (and are not retweets, because you need to have done the homework yourself).

I am 0.538 Ravenclaw, as I am about average for the #rstats community in the amount of external links I post (I have no idea how this compares with wider non-spambot Twitter, but it would be easy to find out).

### Hufflepuff

Hufflepuff keep the entire system working be making sure things get through. The Hufflepuff metric is the proportion of the account tweets that are retweets.

I am 0.006 Hufflepuff (well, I was pretty high in some of the others), which is to say I almost never retweet things (it is just not the way I use my account).

## A final score

The final sorting stat is calculated by working out the percentage that each proportion is of the combined four proportions. So I am 41.4 Slytherin, 35.6 Gryffindor. And being high in both arguably puts me in a Harry range.

## The code 

To run code, in sorting_code.R, you are going to need to use R, have the csvs from this repo, be comfortable enough with the rtweet package to set up your own access token, and modify line 9 to put in the account you are analyzing.


### Docker

A [Dockerfile](Dockerfile) has been added to build a container to run this for you, and the container is also available on Docker Hub. To build locally:

```
docker build -t vanessa/sorting-hat .
```

You then want to map to localhost (port 80) so the browser can easily open and authenticate with rtweet OAuth. Interestingly, I didn't need to use the code for this (and got weird errors when I tried). To run, run the container and provide the Twitter user you want to analyze:

```
docker run -p 80:80 vanessa/sorting-hat vsoch
```
