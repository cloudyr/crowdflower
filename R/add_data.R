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


addData <- function(id, df){

	# loop over rows
	for (i in 1:nrow(df)){

		dd <- sapply(df[1,], as.list) # converting row to list
		endpoint <- paste0('jobs/', id, '/units.json')
		body <- list(unit = list('data' = dd))

		unit <- APIcall(endpoint, type="POST-DATA", body=body)
	}

	message(nrow(df), " new rows successfully created.")

}
