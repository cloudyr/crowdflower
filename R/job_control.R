#' @rdname job_launch
#' @title Control a job
#' @description Launch, pause, resume, or cancel a job
#' @details \code{job_launch} launches a new job. \code{job_pause} pauses a currently running job. \code{job_resume} resumes a job. \code{job_cancel} cancels a job.
#' @param id A character string containing an ID for job.
#' @param channel Either "on_demand" (for On Demand worforce), \dQuote{cf_internal} (for the Internal Channel) or "both"
#' @param units Units to be launched.
#' @param verbose A logical indicating whether to print details of the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return For \code{job_launch}, a list containing details of the job. Otherwise, a logical indicating the operation was successful, otherwise an error.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' job_launch(j)
#'
#' # pause the job
#' job_pause(j)
#'
#' # resume the job
#' job_resume(j)
#' 
#' # cancel the job
#' job_cancel(j)
#' }
#' @seealso \code{\link{job_pause}}, \code{\link{job_cancel}}, \code{\link{job_resume}}
#' @keywords jobs
#' @export
job_launch <- function(id, channel="cf_internal", units=100, verbose = FALSE, ...){
    
    # preparing body of request
    body <- list()
    if (channel=="on_demand") body['channels[0]'] <- "on_demand"
    if (channel=="cf_internal") body['channels[0]'] <- "cf_internal"
    if (channel=="both"){
        body['channels[0]'] <- "on_demand"
        body['channels[1]'] <- "cf_internal"
    }
    if (length(body)==0) stop("Wrong channel option?")
    body['debit[units_count]'] <- units


    # API request
    endpoint <- paste0('jobs/', id, '/orders.json')
    jobinfo <- cf_query(endpoint, type="POST", body=body, ...)

    if (verbose) {
        message(sprintf("Job %s successfully launched", id))
    }
    return(jobinfo)
}

#' @rdname job_launch
#' @export
job_pause <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/pause.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully paused", id))
    }
    return(invisible(TRUE))
}

#' @rdname job_launch
#' @export
job_cancel <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/cancel.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully cancelled", id))
    }
    return(invisible(TRUE))
}

#' @rdname job_launch
#' @export
job_resume <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/resume.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully resumed", id))
    }
    return(invisible(TRUE))
}

