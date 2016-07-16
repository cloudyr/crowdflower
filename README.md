# CrowdFlower API Client #

This repository will soon hold an R client package for the [CrowdFlower](http://www.crowdflower.com/) crowdsourcing platform.

To use the package, you will also need to obtain [a CrowdFlower API key](https://success.crowdflower.com/hc/en-us/articles/202703445-CrowdFlower-API-Integrating-with-the-API#api_key). This can be passed to any function using the `key` argument or set globally using the `CROWDFLOWER_API_KEY` environment variable. To set this from within R, simply do the following at the beginning of your R session:

```R
Sys.setenv("CROWDFLOWER_API_KEY" = "example12345apikeystring")
```

The package provides two basic interfaces to Crowdflower, one that uses a familiar functional programming style and another that relies on [R6 classes](https://cran.r-project.org/package=R6) with reference semantics. Both are equivalent but each might be more useful for a particular application.

### Functional Approach

The standard, functional approach provided by the package uses R functions to call Crowdflower API operations to create, modify, and launch Crowdflower jobs, and retrieve the results. To initialize a job, create a set of instructions and [a "CML" file](https://success.crowdflower.com/hc/en-us/articles/202817989-CML-CrowdFlower-Markup-Language-Overview), and create the job using `job_create()`:


```R
# load "instructions" file
f1 <- system.file("templates", "instructions1.html", package = "crowdflower")
# load "cml" file
f2 <- system.file("templates", "cml1.xml", package = "crowdflower")
j1 <- job_create(title = "Job Title", 
                 instructions = readChar(f1, nchars = 1e8L),
                 cml = readChar(f2, nchars = 1e8L))
```

The instructions file is an HTML document that describes a task to a Crowdflower worker. The CML (Crowdflower Markup Language) is an XML document that serves as a template for the content shown to workers, including any data fields and questions for workers to answer. A simple example CML file is included in the package:

```xml
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
```

Once the job is created, you can modify its features using `job_update()` and add data using `job_add_data()`:

```R
d <- data.frame(content = c("hello", "goodbye", "world")
job_add_data(j1, data = d)
```

From there, you can launch the job, wait for results (checking progress using `job_status()`), and retrieve the results:


```R
# launch job
job_launch(id = j1)

# check progress
job_status(id = j1)

# get results for job
report_regenerate(id = j1, report_type = "full")
report_get(id = j1, report_type = "full")
```

Once you no longer have a need for a job, it can be deleted using `job_delete()`.


### R6 Class and Reference Semantics

The R6 approach provides exactly the same functionality but can be particularly useful when working interactively because it uses "reference semantics" to simplify the code needed to modify a job. To work in this style, simply initialize a "Job"-class object using the Crowdflower job ID (for a job created as above, or via the Crowdflower web interface) or using a title and instructions file (as above:


```R
# initialize using an existing job
j2 <- Job$new(j1)

# create a new job from scratch
j2 <- Job$new(title = "Job Title", 
              instructions = readChar(f1, nchars = 1e8L),
              cml = readChar(f2, nchars = 1e8L))
```

Once the Job object is initialized, all the same operations as above can be performed using `$` notation without needing to specify the job ID:

```R
# modify
j2$update(title = "New Title")

# launch
j2$launch()

# pause
j2$pause()

# resume
j2$resume()

# get results
j2$get_report()
```

The Job class also has a set of "active binding" fields making it very easy to change job options using a familiar, list-like assignment style:

```R
j2$title
j2$title <- "Better Title"
j2$instructions
j2$tags <- c("sentiment", "tweets", "coding")
j2$tags
```




## Installation ##

[![CRAN Version](http://www.r-pkg.org/badges/version/crowdflower)](http://cran.r-project.org/package=crowdflower)
![Downloads](http://cranlogs.r-pkg.org/badges/crowdflower)
[![Travis-CI Build Status](https://travis-ci.org/cloudyr/crowdflower.png?branch=master)](https://travis-ci.org/cloudyr/crowdflower)
[![Build status](https://ci.appveyor.com/api/projects/status/3lwggwiv9xkhhb3p?svg=true)](https://ci.appveyor.com/project/leeper/crowdflower)
[![codecov.io](http://codecov.io/github/cloudyr/crowdflower/coverage.svg?branch=master)](http://codecov.io/github/cloudyr/crowdflower?branch=master)

The package will soon be available on [CRAN](http://cran.r-project.org/web/packages/crowdflower/) and can be installed directly in R using:

```R
install.packages("crowdflower")
```

To install the latest development version of **crowdflower** from GitHub:

```R
# latest stable version
install.packages("crowdflower", repos = c(getOption("repos"), "http://cloudyr.github.io/drat"))

# latest (unstable) version from GitHub
if(!require("ghit")){
    install.packages("ghit")
}
ghit::install_github("cloudyr/crowdflower")
```

[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
