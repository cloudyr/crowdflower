#' @rdname launchJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{launchJob} launches a new job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param channel Either "on_demand" (for On Demand worforce), "cf_internal"
#' (for the Internal Channel) or "both"
#'
#' @param units Units to be launched.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' launchJob('jobid')
#' }
#'
#' @seealso \code{\link{pauseJob}}, \code{\link{cancelJob}}, \code{\link{resumeJob}}

launchJob <- function(id, channel="cf_internal", units=100, ...){
	
	# preparing body of request
	body <- list()
	if (channel=="on_demand") body['channels[0]'] <- "on_demand"
	if (channel=="cf_internal") body['channels[0]'] <- "cf_internal"
	if (channel=="both"){
		body['channels[0]'] <- "on_demand"
		body['channels[1]'] <- "cf_internal"
	}
	if (length(body)==0) stop("Wrong channel option?")
	body['debit[units_count]'] <- units


	# API request
	endpoint <- paste0('jobs/', id, '/orders.json')
	jobinfo <- APIcall(endpoint, type="POST", body=body, ...)

	if (verbose) message(sprintf("Job %s successfully launched", id))
	return(invisible(jobinfo$id))
}

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
#' @seealso \code{\link{launchJob}}, \code{\link{cancelJob}}, \code{\link{resumeJob}}

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
#' @seealso \code{\link{launchJob}}, \code{\link{pauseJob}}, \code{\link{resumeJob}}

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
#' @seealso \code{\link{launchJob}}, \code{\link{cancelJob}}, \code{\link{pauseJob}}

resumeJob <- function(id, ...){
	# API request
	endpoint <- paste0('jobs/', id, '/resume.json')
	jobinfo <- APIcall(endpoint, ...)

	if (verbose) message(sprintf("Job %s successfully resumed", id))
	return(invisible(jobinfo$id))
}

