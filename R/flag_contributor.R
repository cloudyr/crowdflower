#' @rdname job_contributor_flag
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
#' job_contributor_flag(j, worker, "Looks problematic")
#'
#' # Unflag contributor
#' job_contributor_unflag(j, worker, "Actually, all is well")
#'
#' # Reject contributor
#' job_contributor_reject(j, worker, "This is unacceptable.")
#' }
#'
#' @seealso \code{\link{job_create}}
#' @keywords contributors
#' @export
job_contributor_flag <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(flag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname job_contributor_flag
#' @export
job_contributor_unflag <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(unflag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname job_contributor_flag
#' @export
job_contributor_reject <- function(id, worker, reason, ...){

    # preparing body of request
    body <- list(reject = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', worker, '/reject.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}
