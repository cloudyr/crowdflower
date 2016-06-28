#' @rdname addData
#' @title Uploads data to a CrowdFlower Job
#' @description \code{addData} uploads data from a data.frame to a CrowdFlower Job
#' @param id ID for job to be updated.
#' @param data A filename or data.frame with data to be uploaded.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#data}{Crowdflower API documentation}
#' @return A character string containing the job ID, invisibly.
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
#' @seealso \code{\link{updateJob}}, \code{\link{getStatus}}, \code{\link{getResults}}
#' @export

addData <- function(id, data, verbose = TRUE, ...){

    if (is.character(data)) {
        if (!file.exists(data)) {
            stop(paste0("'data' file ", data, " does not exist."))
        }
    } else {
        f <- tempfile(fileext = ".csv")
        write.csv(data, file = f)
        on.exit(unlink(f))
        data <- f
    }
    
    out <- crowdflowerAPIQuery(paste0("jobs/upload.json"), type = "POST", 
                               body = list(x = upload_file(data)), 
                               content_type("text/csv"), ...)
    
    return(invisible(out$job_id))
}
