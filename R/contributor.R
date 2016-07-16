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
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                 instructions = readChar(f1, nchars = 1e8L),
#'                 cml = readChar(f2, nchars = 1e8L))
#'
#' # add data
#' d <- data.frame(variable = 1:3)
#' job_add_data(id = j, data = d)
#'
#' # launch job
#' job_launch(id = j)
#' 
#' # get results
#' # get results for job
#' report_regenerate(id = j, report_type = "full")
#' r <- report_get(id = j, report_type = "full")
#' 
#' # Send message
#' job_contributor_notify(j, r[1, "_worker_id"], "Great work!")
#'
#' # Pay bonus
#' job_contributor_bonus(j, r[1, "_worker_id"], "0.01")
#'
#' # delete job
#' job_delete(j)
#' }
#' @seealso \code{\link{job_create}}, \code{\link{results_get}}, \code{\link{job_contributor_flag}}
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
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- job_create(title = "Job Title", 
#'                 instructions = readChar(f1, nchars = 1e8L),
#'                 cml = readChar(f2, nchars = 1e8L))
#'
#' # add data
#' d <- data.frame(variable = 1:3)
#' job_add_data(id = j, data = d)
#'
#' # launch job
#' job_launch(id = j)
#' 
#' # get results
#' # get results for job
#' report_regenerate(id = j, report_type = "full")
#' r <- report_get(id = j, report_type = "full")
#' 
#' # Flag contributor
#' job_contributor_flag(j, r[1, "_worker_id"], "Looks problematic")
#'
#' # Unflag contributor
#' job_contributor_unflag(j, r[1, "_worker_id"], "Actually, all is well")
#'
#' # Reject contributor
#' job_contributor_reject(j, r[1, "_worker_id"], "This is unacceptable.")
#'
#' # delete job
#' job_delete(j)
#' }
#'
#' @seealso \code{\link{job_create}}, \code{\link{results_get}}, \code{\link{job_contributor_bonus}}
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
