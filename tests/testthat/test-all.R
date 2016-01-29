context("Account information")
test_that("Get account information", {
    expect_true(is.list(getAccount()))
})

context("Create Job")
test_that("Create basic job", {
    f1 <- system.file("templates/instructions1.html", package = "crowdflower")
    f2 <- system.file("templates/cml1.xml", package = "crowdflower")
    title <- paste0("Test Job", Sys.Date())
    instructions <- readChar(f1, nchars = 1e8L)
    cml <- readChar(f2, nchars = 1e8L)
    expect_true(is.integer(j <- createJob(title, instructions, cml)))
})
# https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#create_with_json
#test_that("Create Job from JSON", {})
# https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#create_with_csv
#test_that("Create Job from CSV", {})
# https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#create_with_feed
#test_that("Create Job from Data Feed", {})

context("Copy Job")
test_that("Copy Job", {
    expect_true(is.integer(copyJob(j, rows = TRUE)))
})
test_that("Copy Job without Rows", {
    expect_true(is.integer(copyJob(j, rows = FALSE)))
})
test_that("Copy Job with only test questions", {
    expect_true(is.integer(copyJob(j, rows = FALSE, gold = TRUE)))
})


context("Update Job")
test_that("Update job title", {
    updateJob(j, title = "")
})
test_that("Update job instructions", {
    updateJob(j, instructions = "")
})
test_that("Update job CML", {
    updateJob(j, cml = "")
})
test_that("Update job title, instructions, and cml", {
    updateJob(j, title = "", instructions = "", cml = "")
})
test_that("Set task payment", {
    updateJob(j, payment_cents = "0.1")
})
test_that("Set rows per page", {
    updateJob(j, units_per_assignment = 3)
})
test_that("Toggle auto launch on/off", {
    updateJob(j, auto_launch = FALSE)
})
#test_that("Set dynamic judgments", {})

context("Control Job")
test_that("Get all jobs", {
    expect_true(is.data.frame(getJobs(page = NULL)), label = "return all jobs")
    expect_true(is.data.frame(getJobs(page = 1)), label = "return 1st page of jobs")
})
#test_that("Launch to on-demand workforce", {})
#test_that("Launch to internal channel", {})
#test_that("Launch to on-demand and internal", {})
test_that("Get job status", {
    expect_true(is.list(getStatus(j)))
})
test_that("Control job", {
    expect_true(is.list(launchJob(j, units = 1)), label = "launch job")
    expect_error(pauseJob(j), label = "pause job")
    expect_error(resumeJob(j), label = "resume job")
    expect_error(cancelJob(j), label = "cancel job")
})

context("Results")
test_that("Job reports", {
    # full
    # aggregated
    # json
    # gold_report
    # workset
    # source
# downloading rows from existing job
#results <- getRows(id='724144', type="aggregated")
#results <- getRows(id='724144', type="full") # one coder
#results <- getRows(id='754202', type="aggregated")
#results <- getRows(id='754202', type="full") # multiple coders
})
test_that("Get job legend", {
    expect_true(is.list(getJobLegend(j)))
})
test_that("Get judgments per row", {})
test_that("Get judgments rows and judgments", {})



context("Job tags")
test_that("View tags", {
    expect_true(is.character(getJobTags(j)))
})
test_that("Add new tag to job", {
    expect_true(addJobTags(j, "foo"))
    expect_true(addJobTags(j, c("foo","bar")))
})
test_that("Replace tags", {
    expect_true(replaceJobTags(j, c("boo", "far"))
})

context("Add data to job")
#test_that("Add CSV data to job", {})
#test_that("Add JSON data to job", {})
# adding data
df <- data.frame(
    tweet_id = c(1, 2, 3, 4, 5),
    content = c('tweet1', 'tweet2', 'tweet3', 'tweet4', 'tweet5'),
    stringsAsFactors=F)
#addData(j, df)


context("Row operations")
test_that("Create new row", {})
test_that("Copy row", {})
test_that("Get rows count", {})
test_that("Get rows for a job", {})
test_that("Change state of job", {
    # new
    # golden
    # finalized
    # canceled
})


test_that("Cancel a unit", {})
test_that("Convert to test questions", {})



context("Channels")
test_that("Get all channels", {
    expect_true(is.character(listChannels(j)))
})
test_that("Add channel to job", {
    ch <- listChannels(j)
    expect_true(addChannel(j, ch[1]))
})
test_that("Remove channel from job", {
    expect_true(addChannel(j, ch[1]))
})

context("Contributors")
test_that("Pay a bonus", {})
test_that("Notify a contributor", {})
test_that("Flag a contributor", {})
test_that("Unflag a contributor", {})
test_that("Reject a contributor", {})
