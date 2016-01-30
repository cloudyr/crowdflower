#' @rdname getStatus
#' @export
#'
#' @title 
#' Retrieve the status of a job
#'
#' @description
#' \code{getStatus} gets the status of the job identified by the 
#' id parameter of the request.
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return Details about a job.
#' 
#' @examples
#' \dontrun{
#' j <- createJob(title = 'Job Title', 
#'                instructions = 'Some instructions')
#' 
#' # get status
#' getStatus(j)
#' }
#'
#' @seealso \code{\link{getRows}}, \code{\link{getResults}}

getStatus <- function(id, ...){

    # API request
    endpoint <- paste0('jobs/', id, '/ping.json')
    jobinfo <- crowdflowerAPIQuery(endpoint, ...)

    return(structure(c(list(id = id), jobinfo), class = "crowdflower_job_status"))
}

print.crowdflower_job_status <- function(x, ...) {
    cat("Job ID:             ", x$id, "\n", sep = "")
    cat("Gold units:         ", x$golden_units, "\n", sep = "")
    cat("All units:          ", x$all_units, "\n", sep = "")
    cat("Ordered units:      ", x$ordered_units, "\n", sep = "")
    cat("Completed units:    ", x$completed_units_estimate, "\n", sep = "")
    cat("Judgments needed:   ", x$needed_judgments, "\n", sep = "")
    cat("Total judgments:    ", x$all_judgments, "\n", sep = "")
    cat("Tainted judgments:  ", x$tainted_judgments, "\n", sep = "")
    cat("Completed Gold:     ", x$completed_gold_estimate, "\n", sep = "")
    cat("Completed Non-Gold: ", x$completed_non_gold_estimate, "\n\n", sep = "")
    invisible(x)
}
