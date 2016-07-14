#' @title Delete a single job
#' @description Delete a single Crowdflower job
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical.
#' @keywords jobs
#' @export
job_delete <- function(id, verbose = TRUE, ...) {

    endpoint <- paste0('jobs/', id, '.json')
    job <- cf_query(endpoint, type = "DELETE", body = body, ...)
    
    if ("success" %in% names(job$message)) {
        if (verbose) {
            message(job$message$success)
        }
        return(TRUE)
    } else {
        return(FALSE)
    }
}
