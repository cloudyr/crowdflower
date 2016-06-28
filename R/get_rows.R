#' @title  Retrieve rows with judgment information for a job.
#' @description \code{get_rows} retrieves rows with judgment information for the job ID indicated in the request.
#' @param id A character string containing an ID for job.
#' @param n Number of rows to return.
#' @param type How responses should be aggregated ("aggregate", to take aggregated responses; or "full" for all responses)
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A data.frame containing judgment information
#' @examples
#' \dontrun{
#' get_rows('jobid')
#' }
#' @seealso \code{\link{get_status}}, \code{\link{get_results}}
#' @export
get_rows <- function(id, n=Inf, type="aggregated", verbose = TRUE, ...){

    # initial API request
    endpoint <- paste0('jobs/', id, '/judgments.json')
    params <- "&page=1"
    rows <- newrows <- cf_query(endpoint, params)

    if (verbose) message(length(rows), ' rows downloaded')

    if (n>100){
        # if more than 100 are requested, continue until
        # n is reached, or when no more data is returned        
        page <- 2
        
        while (length(rows)<=n && length(newrows)>0){
            
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

    df <- rowDataToDF(rows, type)

    return(df)

}
