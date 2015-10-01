#' @rdname pauseJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{pauseJob} pauses a currently running job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' pauseJob('jobid')
#' }
#'
#' @seealso \code{\link{cancelJob}}, \code{\link{resumeJob}}

pauseJob <- function(id, ...){
	# API request
	endpoint <- paste0('jobs/', id, '/pause.json')
	jobinfo <- APIcall(endpoint, ...)

	if (verbose) message(sprintf("Job %s successfully paused", id))
	return(invisible(jobinfo$id))
}

#' @rdname cancelJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{pauseJob} cancels a currently running job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' cancelJob('jobid')
#' }
#'
#' @seealso \code{\link{pauseJob}}, \code{\link{resumeJob}}

cancelJob <- function(id, ...){
	# API request
	endpoint <- paste0('jobs/', id, '/cancel.json')
	jobinfo <- APIcall(endpoint, ...)

	if (verbose) message(sprintf("Job %s successfully cancelled", id))
	return(invisible(jobinfo$id))
}

#' @rdname resumeJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{resumeJob} resumes a currently paused job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' getStatus('jobid')
#' }
#'
#' @seealso \code{\link{cancelJob}}, \code{\link{pauseJob}}

resumeJob <- function(id, ...){
	# API request
	endpoint <- paste0('jobs/', id, '/resume.json')
	jobinfo <- APIcall(endpoint, ...)

	if (verbose) message(sprintf("Job %s successfully resumed", id))
	return(invisible(jobinfo$id))
}

