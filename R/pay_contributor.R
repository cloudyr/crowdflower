#' @rdname notify
#' @title Contact Contributors
#' @description Contact a contributor via email or pay a contributor a bonus in U.S. cents
#' @param id A character string containing an ID for job to be updated.
#' @param worker A character string containing a worker/contributor ID.
#' @param amount A character string containing a bonus amount in U.S. cents.
#' @param msg A character string containing a message to be sent to the contributor.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples 
#' \dontrun{
#' # Send message
#' notify_contributor(j, w, "Great work!")
#'
#' # Pay bonus
#' pay_bonus(j, w, "0.01")
#' }
#' @seealso \code{\link{create_job}}
#' @export
pay_bonus <- function(id, worker, amount, ...){

    # preparing body of request
    body <- list(message = amount)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/bonus.json')
    out <- cf_query(endpoint, type = "POST", body = body, ...)
    
    return(out)

}

#' @rdname notify
#' @export
notify_contributor <- function(id, worker, msg, ...){

    # preparing body of request
    body <- list(message = msg)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/notify.json')
    out <- cf_query(endpoint, type = "POST", body = body, ...)
    
    return(out)

}
