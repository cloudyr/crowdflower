#' @rdname notify
#' @title Contact Contributors
#' @description Contact a contributor via email or pay a contributor a bonus in U.S. cents
#' @param id A character string containing an ID for job to be updated.
#' @param contributor A character string containing a contributor/contributor ID.
#' @param amount A character string containing a bonus amount in U.S. cents.
#' @param msg A character string containing a message to be sent to the contributor.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples 
#' \dontrun{
#' # Send message
#' job_contributor_notify(j, w, "Great work!")
#'
#' # Pay bonus
#' job_contributor_bonus(j, w, "0.01")
#' }
#' @seealso \code{\link{job_create}}
#' @keywords contributors
#' @export
job_contributor_bonus <- function(id, contributor, amount, ...){

    # preparing body of request
    body <- list(message = amount)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', contributor, '/bonus.json')
    out <- cf_query(endpoint, type = "POST", body = body, ...)
    
    return(out)

}

#' @rdname notify
#' @export
job_contributor_notify <- function(id, contributor, msg, ...){

    # preparing body of request
    body <- list(message = msg)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', contributor, '/notify.json')
    out <- cf_query(endpoint, type = "POST", body = body, ...)
    
    return(out)

}
