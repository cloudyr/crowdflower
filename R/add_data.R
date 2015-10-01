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
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' d <- data.frame(variable = 1:3)
#' addData(id = 'jobid', df = d)
#' }
#'
#' @seealso \code{\link{updateJob}}, \code{\link{getStatus}}, \code{\link{getResults}}


addData <- function(id, df, verbose = TRUE, ...){

	if (verbose) pb <- txtProgressBar(min=1, max=nrow(df), style=3)

	# loop over rows
	for (i in 1:nrow(df)){

		dd <- sapply(df[i,], as.list) # converting row to list
		endpoint <- paste0('jobs/', id, '/units.json')
		body <- list(unit = list('data' = dd))

		unit <- APIcall(endpoint, type="POST-DATA", body=body, ...)
		Sys.sleep(0.02) # adding small pause to avoid hitting rate limit
						# (40 requests per second)

		if (verbose) setTxtProgressBar(pb, i)
	}

	if (verbose) message(nrow(df), " new rows successfully created.")
	
	#return(invisible(unit)) # is this what we want?
	return(invisible(unit$job_id)) 	# returning job ID (consistent with other functions; 
									# we can use pipe operator ?)
}
