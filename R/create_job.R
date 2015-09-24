#' @rdname createJob
#' @export
#'
#' @title 
#' Creates a new job
#'
#' @description
#' \code{createJob} creates a new CrowdFlower Job.
#'
#' @param title A character string containing the title for a new job.
#' 
#' @param instructions A character string containing instructions for a new job.
#'
#' @param cml Layout for new job.
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string contianing the job ID, invisibly.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide}{Crowdflower API documentation}
#' 
#' @examples
#' \dontrun{
#' createJob(title = 'Job Title', 
#'           instructions = 'Some instructions')
#' }
#'
#' @seealso \code{\link{updateJob}}, \code{\link{getStatus}}, \code{\link{getResults}}

createJob <- function(title=NULL, instructions=NULL, cml=NULL, verbose = TRUE, ...){

	# preparing body of request
	body <- list()
	if (!is.null(title)) body['job[title]'] <- title
	if (!is.null(instructions)) body['job[instructions]'] <- instructions
	if (!is.null(cml)) body['job[cml]'] <- cml

	# API request to create job
	newjob <- APIcall("jobs.json", type="POST", body=body, ...)
	if (verbose) message("Job successfully created with ID = ", newjob$id)

	return(invisible(newjob$id))
}
