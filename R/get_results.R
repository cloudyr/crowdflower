#' @rdname get_results
#' @title Generate and retrieve job results
#' @description
#' \code{get_results} regenerates one of six types of reports within
#' a job:
#' - \code{full}: Returns the Full report containing every judgment.
#' - \code{aggregated}: Returns the Aggregated report containing the 
#' aggregated response for each row.
#' - \code{json}: Returns the JSON report containing the aggregated 
#' response, as well as the individual judgments, for the first 50 rows.
#' - \code{gold_report}: Returns the Test Question report.
#' - \code{workset}: Returns the Contributor report.
#' - \code{source}: Returns a CSV of the source data uploaded to the job.
#' @param id A character string containing an ID for job.
#' @param report_type Type of report
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#get_results}{Crowdflower API documentation}
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # get results for job
#' get_results(id = j, report_type = "")
#' }
#' @seealso \code{\link{get_account}}
#' @export
get_results <- function(id, 
                       report_type = c("full", "aggregated", "json", "gold_report", "workset", "source"), 
                       verbose = TRUE, 
                       ...){

    endpoint2 <- paste0('jobs/', id, '.csv')
    cf_query(endpoint2, query = list(type = match.arg(report_type)), type="GET", ...)

}

#' @rdname get_results
#' @export
regenerate_report <- function(id, 
                             report_type = c("full", "aggregated", "json", "gold_report", "workset", "source"), 
                             verbose = TRUE, 
                             ...){

    if (verbose) {
        message("Generating results report...")
    }
    endpoint1 <- paste0('jobs/', id, '/regenerate')
    results <- cf_query(endpoint1, query = list(type = match.arg(report_type)), type="POST", ...)
    
    if (results != "OK") {
        stop("Report regeneration failed!")
    }
    return(TRUE)
    
}
