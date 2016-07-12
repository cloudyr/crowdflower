#' @title Get a single job
#' @description Get a single Crowdflower job
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A list containing details of all jobs. The \code{id} field provides the Crowdflower Job ID for each job.
#' @seealso \code{\link{cf_account}}
#' @keywords jobs
#' @export
job_get <- function(id, 
                    verbose = TRUE, 
                    ...){

    # API request to get job
    endpoint <- paste0('jobs/', id, '.json')
    job <- cf_query(endpoint, type = "GET", body = body, ...)
    
    if (verbose) {
        message("Job successfully retrieved with ID = ", job$id)
    }
    
    return(job)
}
