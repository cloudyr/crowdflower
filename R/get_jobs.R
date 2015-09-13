#' @rdname getJobs
#' @export
#'
#' @title 
#' Retrieve list of all jobs.
#'
#' @description
#' \code{getJobs} queries for all jobs under the account related 
#' to the API key for the authenticated user.
#'
#' @param n Number of recent jobs to return.


getJobs <- function(n=10){

	# initial API request
	jobs <- APIcall("jobs.json")
	df <- jobDataToDF(jobs)

	if (n>10){
		# if more than 10 are requested, continue until
		# n is reached, or when no more data is returned		
		page <- 2
		
		while (nrow(df)<=n && length(jobs)>0){
			
			params <- paste0('&page=', page)
			jobs <- APIcall("jobs.json", params)
			newdf <- jobDataToDF(jobs)
			df <- rbind(df, newdf)
			page <- page + 1
		}
	}		

	return(df)

}