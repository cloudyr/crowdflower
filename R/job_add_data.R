#' @rdname job_add_data
#' @title Uploads data to a CrowdFlower Job
#' @description \code{job_add_data} uploads data from a data.frame to a CrowdFlower Job
#' @param id ID for job to be updated.
#' @param data A filename or data.frame with data to be uploaded.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#data}{Crowdflower API documentation}
#' @return A character string containing the job ID, invisibly.
#' @examples
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                 instructions = readChar(f1, nchars = 1e8L),
#'                 cml = readChar(f2, nchars = 1e8L))
#'
#' # add data
#' d <- data.frame(variable = 1:3)
#' job_add_data(id = j, data = d)
#'
#' # launch job
#' job_launch(id = j)
#' 
#' # get results for job
#' report_regenerate(id = j, report_type = "full")
#' report_get(id = j, report_type = "full")
#' 
#' # delete job
#' job_delete(j)
#' }
#' @seealso \code{\link{job_update}}, \code{\link{job_status}}, \code{\link{report_get}}
#' @keywords jobs data
#' @importFrom utils write.csv
#' @importFrom httr upload_file content_type
#' @export
job_add_data <- function(id, data, verbose = TRUE, ...){

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
    
    out <- cf_query(paste0("jobs/", id, "/upload.json"), type = "POST", 
                    body = upload_file(data), content_type("text/csv"), ...)
    
    return(invisible(out$job_id))
}
