#' @rdname copyJob
#' @export
#'
#' @title 
#' Copy a job and, optionally, its data to a new job ID.
#'
#' @description
#' \code{copyJob} copies an existing job to a new job ID.
#'
#' @param id A character string containing an ID for job.
#'
#' @param rows A logical indicating whether to copy rows from the original job.
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string contianing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' copyJob(id = 'jobid')
#' }
#'
#' @seealso \code{\link{createJob}}, \code{\link{updateJob}}


copyJob <- function(id, rows = TRUE, verbose = TRUE, ...){

	# API request
	endpoint <- paste0('jobs/', id, '/copy.json')
	if (rows) {
		newjob <- APIcall(endpoint, params = "&all_units=true", ...)
	} else {
		newjob <- APIcall(endpoint, ...)
	}

	if (verbose) message("Job successfully created with ID = ", newjob$id)

	return(invisible(newjob$id))
}
