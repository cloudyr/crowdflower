#' @rdname flag_contributor
#' @title Flag/unflag/reject Contributors
#' @description  Flag/unflag or reject a contributor
#' @param id A character string containing an ID for job to be updated.
#' @param worker A character string containing a worker/contributor ID.
#' @param reason A character string containing a reason for flagging/unflagging/rejecting.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples 
#' \dontrun{
#' # Flag contributor
#' flag_contributor(j, worker, "Looks problematic")
#'
#' # Unflag contributor
#' unflag_contributor(j, worker, "Actually, all is well")
#'
#' # Reject contributor
#' reject_contributor(j, worker, "This is unacceptable.")
#' }
#'
#' @seealso \code{\link{create_job}}
#' @export
flag_contributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(flag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname flag_contributor
#' @export
unflag_contributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(unflag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname flag_contributor
#' @export
reject_contributor <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(reject = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/reject.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}
