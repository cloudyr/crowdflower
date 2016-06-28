#' @docType package
#' @description R Crowdflower API Client
#' @details The crowdflower package provides programmatic access to
#' the \href{https://success.crowdflower.com/hc/en-us/categories/200176379-CrowdFlower-REST-API}{Crowdflower API}.
#' Crowdflower is a prominent crowdsourcing platform that connects \dQuote{customers}
#' to a large universe of \dQuote{channels}, where \dQuote{contributors}
#' complete small tasks in exchange for money. Unlike some other 
#' crowdsourcing platforms, Crowdflower can distribute work to 
#' multiple \href{http://www.crowdflower.com/labor-channels}{\dQuote{channels}},
#' enabling you to draw a diverse, international set of crowdworkers.
#' 
#' Crowdflower works through \dQuote{jobs}, where one job can involve 
#' multiple \dQuote{rows} or \dQuote{units} of input data. For example,
#' in a sentiment analysis task, a customer (you) might have 1000 tweets
#' to be coded for sentiment. This would constitute one job with 
#' 1000 rows/units that will be completed by contributors.
#' 
#' The basic workflow is to create a job, add data to the job, configure
#' the \dQuote{channels} that the job will be distributed to, and
#' to finally retrieve the results. All of these actions can be performed
#' with the crowdflower package.
#'
#' The first step is to create a Crowdflower requester account and retrieve 
#' \href{https://success.crowdflower.com/hc/en-us/articles/202703445-CrowdFlower-API-Integrating-with-the-API#api_key}{an API key} 
#' from your account. To begin working, load the crowdflower package and
#' specify your API key as an environment variable. Within R, this can 
#' be set with: \code{Sys.setenv("CROWDFLOWER_API_KEY" = "example12345apikeystring")}.
#'
#' Users may also be interested in the \href{https://cran.r-project.org/web/packages/MTurkR/index.html}{MTurkR}
#' package, which provides access to the \href{http://www.mturk.com}{Amazon Mechanical Turk}
#' crowdsourcing platform.
#'
#' @references
#' \href{https://success.crowdflower.com/hc/en-us/categories/200176379-CrowdFlower-REST-API}{API Overview}
#' \href{https://success.crowdflower.com/hc/en-us/articles/201856229#http_status}{API Response Codes}
#' \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide}{API Request Guide}
#'
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # add one or more channels
#' add_channel(j, "neobux")
#' 
#' # upload data
#' d <- data.frame(variable = 1:3)
#' add_data(id = j, data = d)
#'
#' # launch the job
#' launch_job(j)
#'
#' # monitor the job
#' get_status(j)
#'
#' # get results once completed
#' get_results(j)
#' }
#'
#' @seealso \code{\link{create_job}}, \code{\link{getChannels}}, \code{\link{add_data}}, \code{\link{get_status}}, \code{\link{get_results}}
"_PACKAGE"
