#' @rdname report_get
#' @title Generate and retrieve job results
#' @description Results
#' @details
#' \code{report_get} regenerates one of six types of reports within a job. Here is how they are described by Crowdflower:
#' \itemize{
#'   \item \code{full}: Returns the Full report containing every judgment.
#'   \item \code{aggregated}: Returns the Aggregated report containing the aggregated response for each row.
#'   \item \code{json}: Returns the JSON report containing the aggregated response, as well as the individual judgments, for the first 50 rows.
#'   \item \code{gold_report}: Returns the Test Question report.
#'   \item \code{workset}: Returns the Contributor report.
#'   \item \code{source}: Returns a CSV of the source data uploaded to the job.
#' }
#' 
#' Where possible, the package tries to return a data.frame of the results.
#' 
#' @param id A character string containing an ID for job.
#' @param report_type Type of report
#' @param csv_args A list of arguments passed to \code{\link[utils]{read.csv}} when \code{report_type = 'source'}.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return If \code{report_type = 'json'}, a list. Otherwise a data.frame.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#report_get}{Crowdflower API documentation}
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                 instructions = readChar(f1, nchars = 1e8L),
#'                 cml = readChar(f2, nchars = 1e8L))
#'
#' # add data
#' d <- data.frame(variable = 1:3)
#' job_add_data(id = j, data = d)
#'
#' # launch job
#' job_launch(id = j)
#' 
#' # get results for job
#' report_regenerate(id = j, report_type = "full")
#' report_get(id = j, report_type = "full")
#' 
#' # delete job
#' job_delete(j)
#' }
#' @seealso \code{\link{cf_account}}
#' @keywords jobs data
#' @importFrom utils unzip
#' @importFrom jsonlite fromJSON
#' @export
report_get <- function(id, 
                       report_type = c("full", "aggregated", "json", "gold_report", "workset", "source"), 
                       csv_args = list(stringsAsFactors = FALSE, check.names = FALSE),
                       verbose = TRUE, 
                       ...){

    report_type <- match.arg(report_type)
    endpoint <- paste0('jobs/', id, '.csv')
    out <- cf_query(endpoint, query = list(type = report_type), type = "GET", parse = FALSE, ...)
    
    # save zip and extract content
    tmp <- tempfile(fileext = ".zip")
    on.exit(unlink(tmp))
    writeBin(out, tmp)
    f <- unzip(tmp, list = TRUE)
    unzip(tmp, files = f[1, "Name"], exdir = tempdir())
    f <- file.path(tempdir(), f[1, "Name"])
    on.exit(unlink(f))
    
    # parse the resulting file
    if (report_type == "json") {
        out <- fromJSON(f)
    } else {
        out <- do.call("read.csv", c(list(file = f), csv_args))
    }
    
    return(out)
    
}

#' @rdname report_get
#' @export
report_regenerate <- function(id, 
                             report_type = c("full", "aggregated", "json", "gold_report", "workset", "source"), 
                             verbose = TRUE, 
                             ...){

    if (verbose) {
        message("Generating results report...")
    }
    endpoint1 <- paste0('jobs/', id, '/regenerate')
    results <- cf_query(endpoint1, query = list(type = match.arg(report_type)), type = "POST", parse = FALSE, ...)
    if (rawToChar(results) != "OK") {
        stop("Report regeneration failed!")
    }
    return(TRUE)
}
