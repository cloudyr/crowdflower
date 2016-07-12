library("testthat")

if (Sys.getenv("CROWDFLOWER_API_KEY") != "") {
    library("crowdflower")
    #test_check("crowdflower")
}
