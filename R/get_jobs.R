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
#' @param n An integer specifying the number of recent jobs to return.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A data.frame containing details of all jobs.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#account_information}{Crowdflower API documentation}
#' 
#' @examples
#' \dontrun{
#' getJobs(n = 10)
#' }
#'
#' @seealso \code{\link{getAccount}}


getJobs <- function(n=10, ...){

	# initial API request
	jobs <- APIcall("jobs.json")
	df <- jobDataToDF(jobs)

	if (n>10){
		# if more than 10 are requested, continue until
		# n is reached, or when no more data is returned		
		page <- 2
		
		while (nrow(df)<=n && length(jobs)>0){
			
			params <- paste0('&page=', page)
			jobs <- APIcall("jobs.json", params, ...)
			newdf <- jobDataToDF(jobs)
			df <- rbind(df, newdf)
			page <- page + 1
		}
	}		

	return(df)

}