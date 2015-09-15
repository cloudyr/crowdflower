# CrowdFlower API Client #

This repository will soon hold an R client package for the [CrowdFlower](http://www.crowdflower.com/) crowdsourcing platform.

## Installation ##

The package will soon be available on [CRAN](http://cran.r-project.org/web/packages/crowdflower/) and can be installed directly in R using:

```R
install.packages("crowdflower")
```

The latest development version on GitHub can be installed using **devtools**:

```R
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("cloudyr/crowdflower")
```

To use the package, you will also need to obtain [a CrowdFlower API key](https://success.crowdflower.com/hc/en-us/articles/202703445-CrowdFlower-API-Integrating-with-the-API#api_key). This can be passed to any function using the `key` argument or set globally using the `CROWDFLOWER_API_KEY` environment variable. To set this from within R, simply do the following at the beginning of your R session:

```R
Sys.setenv("CROWDFLOWER_API_KEY" = "example12345apikeystring")
```

[![CRAN Version](http://www.r-pkg.org/badges/version/crowdflower)](http://cran.r-project.org/package=crowdflower)
![Downloads](http://cranlogs.r-pkg.org/badges/crowdflower)
[![Travis-CI Build Status](https://travis-ci.org/cloudyr/crowdflower.png?branch=master)](https://travis-ci.org/cloudyr/crowdflower)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/3lwggwiv9xkhhb3p/branch/master?svg=true)](https://ci.appveyor.com/project/cloudyr/crowdflower/branch/master)

## Examples ##

More soon...


[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
