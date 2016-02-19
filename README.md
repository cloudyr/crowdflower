# CrowdFlower API Client #

This repository will soon hold an R client package for the [CrowdFlower](http://www.crowdflower.com/) crowdsourcing platform.

To use the package, you will also need to obtain [a CrowdFlower API key](https://success.crowdflower.com/hc/en-us/articles/202703445-CrowdFlower-API-Integrating-with-the-API#api_key). This can be passed to any function using the `key` argument or set globally using the `CROWDFLOWER_API_KEY` environment variable. To set this from within R, simply do the following at the beginning of your R session:

```R
Sys.setenv("CROWDFLOWER_API_KEY" = "example12345apikeystring")
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
