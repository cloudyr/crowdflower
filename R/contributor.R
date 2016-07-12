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

#' @rdname job_contributor_flag
#' @title Flag/unflag/reject Contributors
#' @description  Flag/unflag or reject a contributor
#' @param id A character string containing an ID for job to be updated.
#' @param contributor A character string containing a contributor/contributor ID.
#' @param reason A character string containing a reason for flagging/unflagging/rejecting.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples 
#' \dontrun{
#' # Flag contributor
#' job_contributor_flag(j, contributor, "Looks problematic")
#'
#' # Unflag contributor
#' job_contributor_unflag(j, contributor, "Actually, all is well")
#'
#' # Reject contributor
#' job_contributor_reject(j, contributor, "This is unacceptable.")
#' }
#'
#' @seealso \code{\link{job_create}}
#' @keywords contributors
#' @export
job_contributor_flag <- function(id, contributor, reason, ...){

    # preparing body of request
    body <- list(flag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', contributor, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname job_contributor_flag
#' @export
job_contributor_unflag <- function(id, contributor, reason, ...){

    # preparing body of request
    body <- list(unflag = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', contributor, '.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}

#' @rdname job_contributor_flag
#' @export
job_contributor_reject <- function(id, contributor, reason, ...){

    # preparing body of request
    body <- list(reject = reason)
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '/workers/', contributor, '/reject.json')
    out <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    return(out)

}
