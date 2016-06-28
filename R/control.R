#' @title Pause a job
#' @description \code{launch_job} launches a new job.
#' @param id A character string containing an ID for job.
#' @param channel Either "on_demand" (for On Demand worforce), \dQuote{cf_internal} (for the Internal Channel) or "both"
#' @param units Units to be launched.
#' @param verbose A logical indicating whether to print details of the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A list containing details of the job.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launch_job(j)
#'
#' # pause the job
#' pause_job(j)
#'
#' # resume the job
#' resume_job(j)
#' 
#' # cancel the job
#' cancel_job(j)
#' }
#' @seealso \code{\link{pause_job}}, \code{\link{cancel_job}}, \code{\link{resume_job}}
#' @export

launch_job <- function(id, channel="cf_internal", units=100, verbose = FALSE, ...){
    
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

#' @title Pause a job
#' @description \code{pause_job} pauses a currently running job.
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print details of the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical indicating the operation was successful, otherwise an error.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launch_job(j)
#'
#' # pause the job
#' pause_job(j)
#'
#' # resume the job
#' resume_job(j)
#' 
#' # cancel the job
#' cancel_job(j)
#' }
#' @seealso \code{\link{launch_job}}, \code{\link{cancel_job}}, \code{\link{resume_job}}
#' @export
pause_job <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/pause.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully paused", id))
    }
    return(invisible(TRUE))
}

#' @title Cancel a job
#' @description \code{pause_job} cancels a currently running job.
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print details of the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical indicating the operation was successful, otherwise an error.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launch_job(j)
#'
#' # pause the job
#' pause_job(j)
#'
#' # resume the job
#' resume_job(j)
#' 
#' # cancel the job
#' cancel_job(j)
#' }
#'
#' @seealso \code{\link{launch_job}}, \code{\link{pause_job}}, \code{\link{resume_job}}
#' @export
cancel_job <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/cancel.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully cancelled", id))
    }
    return(invisible(TRUE))
}

#' @title Pause a job
#' @description \code{resume_job} resumes a currently paused job.
#' @param id A character string containing an ID for job.
#' @param verbose A logical indicating whether to print details of the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical indicating the operation was successful, otherwise an error.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launch_job(j)
#'
#' # pause the job
#' pause_job(j)
#'
#' # resume the job
#' resume_job(j)
#' 
#' # cancel the job
#' cancel_job(j)
#' }
#' @seealso \code{\link{launch_job}}, \code{\link{cancel_job}}, \code{\link{pause_job}}
#' @export
resume_job <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/resume.json')
    jobinfo <- cf_query(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully resumed", id))
    }
    return(invisible(TRUE))
}

