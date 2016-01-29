if (Sys.info()["user"] != "kbenoit") {
    setwd("~/git/crowdflower")
}

library("testthat")
test_check("crowdflower")
