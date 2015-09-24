#' @rdname addData
#' @export
#'
#' @title 
#' Uploads data from a data frame to a CrowdFlower Job
#'
#' @param id ID for job to be updated.
#'
#' @param df Data frame with data to be uploaded
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#data}{Crowdflower API documentation}
#'
#' @return A character string contianing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' d <- data.frame(variable = 1:3)
#' addData(id = 'jobid', df = d)
#' }
#'
#' @seealso \code{\link{updateJob}}, \code{\link{getStatus}}, \code{\link{getResults}}


addData <- function(id, df, verbose = TRUE, ...){

	# loop over rows
	for (i in 1:nrow(df)){

		dd <- sapply(df[1,], as.list) # converting row to list
		endpoint <- paste0('jobs/', id, '/units.json')
		body <- list(unit = list('data' = dd))

		unit <- APIcall(endpoint, type="POST-DATA", body=body, ...)
	}

	if (verbose) message(nrow(df), " new rows successfully created.")
	
	return(invisible(unit)) # is this what we want?
}
