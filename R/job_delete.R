#' @title Delete a single job
#' @description Delete a single Crowdflower job
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # delete job
#' job_delete(j)
#' }
#' @seealso \code{\link{job_create}}, \code{\link{job_update}}
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
