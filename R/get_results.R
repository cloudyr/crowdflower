#' @rdname getResults
#' @export
#'
#' @title 
#' Generate and retrieve job results
#'
#' @description
#' \code{getResults} regenerates one of six types of reports within
#' a job:
#' - \code{full}: Returns the Full report containing every judgment.
#' - \code{aggregated}: Returns the Aggregated report containing the 
#' aggregated response for each row.
#' - \code{json}: Returns the JSON report containing the aggregated 
#' response, as well as the individual judgments, for the first 50 rows.
#' - \code{gold_report}: Returns the Test Question report.
#' - \code{workset}: Returns the Contributor report.
#' - \code{source}: Returns a CSV of the source data uploaded to the job.
#'
#' @param id A character string containing an ID for job.
#' 
#' @param report_type Type of report
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#get_results}{Crowdflower API documentation}
#' 
#' @examples
#' \dontrun{
#' getResults(id = "jobid", report_type = "")
#' }
#'
#' @seealso \code{\link{getAccount}}


getResults <- function(id, report_type, verbose = TRUE, ...){

	if (verbose) message("Generating results report...")

	# Step 1: regenerate report
	endpoint <- paste0('jobs/', id, '/regenerate')
	params <- paste0("&type=", report_type)
	results <- APIcall(endpoint, params, type="POST", ...)

	if (verbose) message(results, '\n')

	# Step 2: download report
	if (report_type=="full") filename <- paste0('f', id, '.csv')

	### I was not able to figure out how to do this ###

}