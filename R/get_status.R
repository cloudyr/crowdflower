#' @rdname getStatus
#' @export
#'
#' @title 
#' Retrieve the status of a job
#'
#' @description
#' \code{getStatus} gets the status of the job identified by the 
#' id parameter of the request.
#'
#' @param id ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.


getStatus <- function(id, ...){

	# API request
	endpoint <- paste0('jobs/', id, '/ping.json')
	jobinfo <- APIcall(endpoint, ...)

	return(jobinfo)
}