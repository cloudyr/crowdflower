#' @title Copy a job and, optionally, its data to a new job ID.
#' @description \code{job_copy} copies an existing job to a new job ID.
#' @param id A character string containing an ID for job.
#' @param rows A logical indicating whether to copy rows from the original job.
#' @param gold A logical indicating whether to copy \emph{only} gold questions from the original job.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j1 <- job_create(title = "Job Title", 
#'                  instructions = readChar(f1, nchars = 1e8L),
#'                  cml = readChar(f2, nchars = 1e8L))
#'
#' # copy job w/rows
#' j2 <- job_copy(id = j1)
#' 
#' # copy job w/only gold questions
#' j3 <- job_copy(id = j1, rows = FALSE, gold = TRUE)
#' 
#' # copy job w/o any rows
#' j4 <- job_copy(id = j1, rows = FALSE)
#' 
#' # cleanup
#' job_delete(j1)
#' job_delete(j2)
#' job_delete(j3)
#' job_delete(j4)
#' }
#' @seealso \code{\link{job_create}}, \code{\link{job_update}}
#' @keywords jobs
#' @export
job_copy <- function(id, rows = TRUE, gold = FALSE, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/copy.json')
    query <- list()
    if (rows) {
        query[["all_units"]] <- "true"
    }
    if (gold) {
        query[["gold"]] <- "true"
    }
    newjob <- cf_query(endpoint, query = query, ...)
    
    if (verbose) {
        message("Job successfully created with ID = ", newjob$id)
    }
    return(newjob$id)
}
