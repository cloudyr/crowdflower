#' @title Convert uploaded gold for a job
#' @description Convert to test questions all rows where column \dQuote{_golden} is set to \dQuote{true}. Corresponds to the \dQuote{Convert Uploaded Test Questions} button on the Data page of the web interface.
#' @param id A character string specifying the ID for job whose gold questions will be converted.
#' @param verbose A logical indicating whether to print status information regarding the request.
#' @param \dots Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical.
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
#' d <- data.frame(content = c("hello", "goodbye", "world")
#' d[, "_golden"] <- c("true", "false", "false")
#' job_add_data(id = j, data = d)
#'
#' # convert gold questions
#' job_convert_gold(id = j)
#' 
#' # launch job
#' job_launch(id = j)
#' 
#' # get results for job
#' report_regenerate(id = j, report_type = "full")
#' report_get(id = j, report_type = "full")
#' 
#' # delete job
#' job_delete(id = j)
#' }
#' @keywords jobs
#' @export
job_convert_gold <- function(id, verbose = TRUE, ...) {
    msg <- try(cf_query(endpoint <- paste0("jobs/", id, "/gold"), type = "PUT", ...))
    if (inherits(msg, "try-error")) {
        if (verbose) {
            message(attr(msg, "condition")$message)
        }
        return(FALSE)
    } else {
        if (verbose) {
            message(paste(msg$success$message))
        }
        return(TRUE)
    }
}
