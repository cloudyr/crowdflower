#' @rdname copyJob
#' @export
#'
#' @title 
#' Copy a job and, optionally, its data to a new job ID.
#'
#' @description
#' \code{copyJob} copies an existing job to a new job ID.
#'
#' @param id A character string containing an ID for job.
#'
#' @param rows A logical indicating whether to copy rows from the 
#' original job.
#'
#' @param gold A logical indicating whether to copy \emph{only} gold 
#' questions from the original job. Ignored if \code{rows = TRUE}.
#'
#' @param verbose A logical indicating whether to print additional 
#' information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return A character string containing the job ID, invisibly.
#' 
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", 
#'                   package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", 
#'                   package = "crowdflower")
#' j1 <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # copy job w/rows
#' j2 <- copyJob(id = j1)
#' 
#' # copy job w/only gold questions
#' j2 <- copyJob(id = j1, rows = FALSE, gold = TRUE)
#' 
#' # copy job w/o any rows
#' j2 <- copyJob(id = j1, rows = FALSE)
#' 
#' }
#'
#' @seealso \code{\link{createJob}}, \code{\link{updateJob}}


copyJob <- function(id, rows = TRUE, gold = FALSE, verbose = TRUE, ...){

    # API request
    endpoint <- paste0('jobs/', id, '/copy.json')
    if (rows) {
        newjob <- crowdflowerAPIQuery(endpoint, query = list("all_units" = "true"), ...)
    } else if (gold) {
        newjob <- crowdflowerAPIQuery(endpoint, query = list("gold" = "true"), ...)
    } else {
        newjob <- crowdflowerAPIQuery(endpoint, ...)
    }

    if (verbose) {
        message("Job successfully created with ID = ", newjob$id)
    }
    return(newjob$id)
}
