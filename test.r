if (Sys.info()["user"] != "kbenoit")
    setwd("~/git/crowdflower")

# library(devtools)
# document()
# build()
# install.packages("../crowdflower_0.1.tar.gz", repo=NULL, type="source")

devtools::install_github('leeper/crowdflower', ref="dev")

# test
library(crowdflower)

# testing authentication
key <- readLines("api-key.txt")
authCF(key)

# what happens with wrong API key?
authCF('AAAAA')
authCF(key)

# getting list of jobs
jobs <- getJobs(n=100)
str(jobs)

# getting account info
account <- getAccount()
account$first_name

# create test job (with title, instructions, layout)
title <- "Judge The Sentiment Of Tweets"

instructions <- "
<p>Judge the sentiment of tweets about political candidates</p>

<h3>Overview</h3>

<p>In this job, you will be presented with tweets and other online posts that are 
about political candidates.</p>

<h3>Process</h3>

<ol>
  <li>Read the tweet.</li>

  <li>Determine if the tweet is relevant to the topic.</li>

  <li>Click all links found in the text for additional context.</li>

  <li>Determine if the tweet is positive, neutral, or negative.</li>
</ol>

<p>Posts can be classified as:</p>

<ul>
  <li>Very Positive The author is clearly excited about the topic of the tweet, 
  offers a strong recommendation for the product, expresses praise, or draws an 
  extremely favorable comparison with another product or topic.</li>

  <li>Slightly Positive Some aspects of the tweet uncover a positive mood; a 
  mildly positive comparison against another product; the tweet is positive 
  in nature but not ecstatic (like “Very Positive” above).</li>

  <li>Neutral The tweet is purely informative in nature and does not provide 
  any hints as to the mood of the writer; the topic is presented in a completely 
  neutral context - no indication of the merits or disadvantages of the topic is 
  present; or there is too little data to tell</li>

  <li>Slightly Negative The tweet that is slightly negative in tone; a moderately 
  negative comparison against another topic; mixed feedback that is more critical 
  than positive in nature</li>

  <li>Very Negative The author’s attitude is clearly negative; the writer is 
  describing a bad experience; writer uses slur words or diminishing comparisons 
  in respect to topic</li>
</ul>
"

cml <- "
<div class='html-element-wrapper'><div>
	<p><span style='font-weight: normal;'>
		Read the text below paying close attention to detail:
	</span></p>
	<p><strong>{{content}}</strong></p>
</div>
</div><cml:radios 
	label='What is the sentiment of the opinion expressed in the tweet?' 
	name='sentiment' aggregation='agg' validates='required' gold='true'>
	<cml:radio label='Very Positive' value='5' />
	<cml:radio label='Slightly Positive' value='4' />
	<cml:radio label='Neutral' value='3' />
	<cml:radio label='Slightly Negative' value='2' />
	<cml:radio label='Very Negative' value='1' />
	<cml:radio label='This post is not related to political candidates' 
		value='not_relevant' />
</cml:radios>
"

job <- createJob(title, instructions, cml)

# update title of job
updateJob(job, title="Judge The Sentiment Of Tweets About Candidates")

# adding data
df <- data.frame(
	tweet_id = c(1, 2, 3, 4, 5),
	content = c('tweet1', 'tweet2', 'tweet3', 'tweet4', 'tweet5'),
	stringsAsFactors=F)
addData(job, df)

# checking status of job
info <- getStatus(job)
info$all_units
info$completed_units_estimate

# downloading rows from existing job
results <- getRows(id='724144', type="aggregated")
results <- getRows(id='724144', type="full") # one coder
results <- getRows(id='754202', type="aggregated")
results <- getRows(id='754202', type="full") # multiple coders

