#' @rdname payBonus
#' @export
#'
#' @title 
#' Contact Contributors
#'
#' @description 
#' Contact a contributor via email or pay a contributor a bonus in U.S. cents
#'
#' @param id A character string containing an ID for job to be updated.
#'
#' @param worker A character string containing a worker/contributor ID.
#' 
#' @param amount A character string containing a bonus amount in U.S. cents.
#'
#' @param msg A character string containing a message to be sent to the contributor.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return A character string containing the job ID, invisibly.
#'
#' @examples 
#' \dontrun{
#' # Send message
#' notifyContributor(j, w, "Great work!")
#'
#' # Pay bonus
#' payBonus(j, w, "0.01")
#' }
#'
#' @seealso \code{\link{createJob}}
payBonus <- function(id, worker, amount, ...){

    # preparing body of request
    body <- list(message = amount)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/bonus.json')
    out <- crowdflowerAPIQuery(endpoint, type = "POST", body = body, ...)
    
    return(out)

}

#' @rdname payBonus
#' @export
notifyContributor <- function(id, worker, msg, ...){

    # preparing body of request
    body <- list(message = msg)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/notify.json')
    out <- crowdflowerAPIQuery(endpoint, type = "POST", body = body, ...)
    
    return(out)

}
