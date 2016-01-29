#' @rdname addData
#' @export
#'
#' @title 
#' Uploads data to a CrowdFlower Job
#'
#' @description
#' \code{addData} uploads data from a data.frame to a CrowdFlower Job
#'
#' @param id ID for job to be updated.
#'
#' @param data A data.frame with data to be uploaded
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#data}{Crowdflower API documentation}
#'
#' @return A character string containing the job ID, invisibly.
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
#' d <- data.frame(variable = 1:3)
#' addData(id = j, data = d)
#' }
#'
#' @seealso \code{\link{updateJob}}, \code{\link{getStatus}}, \code{\link{getResults}}


addData <- function(id, data, verbose = TRUE, ...){

    if (verbose) {
        pb <- txtProgressBar(min=1, max=nrow(data), style=3)
    }
    
    # loop over rows
    for (i in 1:nrow(data)){

        dd <- sapply(data[i,], as.list) # converting row to list
        endpoint <- paste0('jobs/', id, '/units.json')
        body <- list(unit = list('data' = dd))

        unit <- crowdflowerAPIQuery(endpoint, type="POST-DATA", body=body, ...)
        Sys.sleep(0.02) # adding small pause to avoid hitting rate limit
                        # (40 requests per second)

        if (verbose) {
            setTxtProgressBar(pb, i)
        }
    }

    if (verbose) {
        message(nrow(data), " new rows successfully created.")
    }
    
    #return(invisible(unit)) # is this what we want?
    return(invisible(unit$job_id))     # returning job ID (consistent with other functions; 
                                    # we can use pipe operator ?)
}
