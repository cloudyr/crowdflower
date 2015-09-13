#' @rdname getRows
#' @export
#'
#' @title 
#' Retrieve rows with judgment information for a job.
#'
#' @description
#' \code{getRows} retrieves rows with judgment information for the 
#' job ID indicated in the request.
#'
#' @param id ID for job.
#'
#' @param n Number of rows to return.
#'
#' @param type How responses should be aggregated ("aggregate", to take
#' aggregated responses; or "full" for all responses)
#'


getRows <- function(id, n=Inf, type="aggregated"){

	# initial API request
	endpoint <- paste0('jobs/', id, '/judgments.json')
	params <- "&page=1"
	rows <- newrows <- APIcall(endpoint, params)

	message(length(rows), ' rows downloaded')

	if (n>100){
		# if more than 100 are requested, continue until
		# n is reached, or when no more data is returned		
		page <- 2
		
		while (length(rows)<=n && length(newrows)>0){
			
			params <- paste0('&page=', page)
			newrows <- APIcall(endpoint, params)

			if (length(newrows)>0){
				rows <- c(rows, newrows)
				page <- page + 1
				message(length(rows), ' rows downloaded')
			}
		}
	}		

	df <- rowDataToDF(rows, type)

	return(df)

}