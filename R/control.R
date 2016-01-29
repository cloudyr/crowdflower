#' @rdname launchJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{launchJob} launches a new job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param channel Either "on_demand" (for On Demand worforce), "cf_internal"
#' (for the Internal Channel) or "both"
#'
#' @param units Units to be launched.
#'
#' @param verbose A logical indicating whether to print details of the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A list containing details of the job.
#' 
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launchJob(j)
#'
#' # pause the job
#' pauseJob(j)
#'
#' # resume the job
#' resumeJob(j)
#' 
#' # cancel the job
#' cancelJob(j)
#' }
#'
#' @seealso \code{\link{pauseJob}}, \code{\link{cancelJob}}, \code{\link{resumeJob}}

launchJob <- function(id, channel="cf_internal", units=100, verbose = FALSE, ...){
    
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
    jobinfo <- APIcall(endpoint, type="POST", body=body, ...)

    if (verbose) {
        message(sprintf("Job %s successfully launched", id))
    }
    return(jobinfo)
}

#' @rdname pauseJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{pauseJob} pauses a currently running job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param verbose A logical indicating whether to print details of the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A logical indicating the operation was successful, otherwise an error.
#' 
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launchJob(j)
#'
#' # pause the job
#' pauseJob(j)
#'
#' # resume the job
#' resumeJob(j)
#' 
#' # cancel the job
#' cancelJob(j)
#' }
#'
#' @seealso \code{\link{launchJob}}, \code{\link{cancelJob}}, \code{\link{resumeJob}}

pauseJob <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/pause.json')
    jobinfo <- APIcall(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully paused", id))
    }
    return(invisible(TRUE))
}

#' @rdname cancelJob
#' @export
#'
#' @title 
#' Cancel a job
#'
#' @description
#' \code{pauseJob} cancels a currently running job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param verbose A logical indicating whether to print details of the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A logical indicating the operation was successful, otherwise an error.
#' 
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launchJob(j)
#'
#' # pause the job
#' pauseJob(j)
#'
#' # resume the job
#' resumeJob(j)
#' 
#' # cancel the job
#' cancelJob(j)
#' }
#'
#' @seealso \code{\link{launchJob}}, \code{\link{pauseJob}}, \code{\link{resumeJob}}

cancelJob <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/cancel.json')
    jobinfo <- APIcall(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully cancelled", id))
    }
    return(invisible(TRUE))
}

#' @rdname resumeJob
#' @export
#'
#' @title 
#' Pause a job
#'
#' @description
#' \code{resumeJob} resumes a currently paused job.
#'
#' @param id A character string containing an ID for job.
#'
#' @param verbose A logical indicating whether to print details of the request.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A logical indicating the operation was successful, otherwise an error.
#' 
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#' 
#' # launch the job
#' launchJob(j)
#'
#' # pause the job
#' pauseJob(j)
#'
#' # resume the job
#' resumeJob(j)
#' 
#' # cancel the job
#' cancelJob(j)
#' }
#'
#' @seealso \code{\link{launchJob}}, \code{\link{cancelJob}}, \code{\link{pauseJob}}

resumeJob <- function(id, verbose = FALSE, ...){
    # API request
    endpoint <- paste0('jobs/', id, '/resume.json')
    jobinfo <- APIcall(endpoint, ...)

    if (verbose) {
        message(sprintf("Job %s successfully resumed", id))
    }
    return(invisible(TRUE))
}

