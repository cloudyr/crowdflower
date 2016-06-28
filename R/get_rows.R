#' @title Retrieve rows with judgment information for a job.
#' @description \code{results_get} retrieves rows with judgment information for the job ID indicated in the request. Specifying \code{unit} retrieves only judgments for a specific row (unit).
#' @param id A character string containing an ID for job.
#' @param n Number of rows to return. Specify only \code{n} or \code{unit}, but not both.
#' @param unit A \dQuote{unit id} for a specific row. Specify only \code{n} or \code{unit}, but not both.
#' @param type How responses should be aggregated ("aggregate", to take aggregated responses; or "full" for all responses)
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A data.frame containing judgment information
#' @examples
#' \dontrun{
#' results_get('jobid')
#' }
#' @seealso \code{\link{job_status}}, \code{\link{report_get}}
#' @keywords jobs data
#' @export
results_get <- function(id, n=Inf, unit = NULL, type="aggregated", verbose = TRUE, ...){


    if (!is.null(unit)) {
        # initial API request
        endpoint <- paste0('jobs/', id, 'units/', unit, '/judgments.json')
        rows <- cf_query(endpoint, ...)
        dat <- rowDataToDF(rows, type)
    } else {
        # initial API request
        endpoint <- paste0('jobs/', id, '/judgments.json')
        params <- "&page=1"
        rows <- newrows <- cf_query(endpoint, params, ...)

        if (verbose) {
            message(length(rows), ' rows downloaded')
        }

        if (n>100) {
            # if more than 100 are requested, continue until
            # n is reached, or when no more data is returned        
            page <- 2
            
            while (length(rows)<=n && length(newrows)>0) {
                
                params <- paste0('&page=', page)
                newrows <- cf_query(endpoint, params, ...)

                if (length(newrows)>0){
                    rows <- c(rows, newrows)
                    page <- page + 1
                    if (verbose) {
                        message(length(rows), ' rows downloaded')
                    }
                }
            }
        }
        dat <- rowDataToDF(rows, type)
    }
    return(dat)
}
