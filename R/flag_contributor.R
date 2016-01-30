#' @rdname flagContributor
#' @export
#'
#' @title 
#' Flag Contributors
#'
#' @description 
#' Flag/unflag or reject a contributor
#'
#' @param id A character string containing an ID for job to be updated.
#'
#' @param worker A character string containing a worker/contributor ID.
#' 
#' @param reason A character string containing a reason for flagging/unflagging/rejecting.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return A character string containing the job ID, invisibly.
#'
#' @examples 
#' \dontrun{
#' # Flag contributor
#' flagContributor(j, worker, "Looks problematic")
#'
#' # Unflag contributor
#' unflagContributor(j, worker, "Actually, all is well")
#'
#' # Reject contributor
#' rejectContributor(j, worker, "This is unacceptable.")
#' }
#'
#' @seealso \code{\link{createJob}}
flagContributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(flag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- crowdflowerAPIQuery(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname flagContributor
#' @export
unflagContributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(unflag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- crowdflowerAPIQuery(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname rejectContributor
#' @export
unflagContributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(reject = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/reject.json')
    out <- crowdflowerAPIQuery(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}
