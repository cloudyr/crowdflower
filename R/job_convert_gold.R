#' @title Convert uploaded gold for a job
#' @description Convert to test questions all rows where column \dQuote{_golden} is set to \dQuote{true}. Corresponds to the \dQuote{Convert Uploaded Test Questions} button on the Data page of the web interface.
#' @param id A character string specifying the ID for job whose gold questions will be converted.
#' @param verbose A logical indicating whether to print status information regarding the request.
#' @param \dots Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical.
#' @keywords jobs
#' @export
job_convert_gold <- function(id, verbose = TRUE, ...) {
    msg <- try(cf_query(endpoint <- paste0("jobs/", id, "/gold"), type = "PUT", ...))
    if (class(msg) == "try-error") {
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
