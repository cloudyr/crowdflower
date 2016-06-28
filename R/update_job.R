#' @title Updates job settings.
#' @description Updates settings for a given job.
#' @param id A character string containing an ID for job to be updated.
#' @param title New title.
#' @param instructions New set of instructions.
#' @param cml New layout for job.
#' @param payment_cents Amount, in U.S. cents, that contributors will be paid per task.
#' @param units_per_assignment Number of rows that will comprise one page within a job.
#' @param auto_launch A logical indicating whether to automatically launch rows as they are added.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A character string containing the job ID, invisibly.
#' @examples 
#' \dontrun{
#' # update job's title
#' update_job(id, title = "New Title")
#'
#' # update job's payment
#' update_job(id, payment_cents = "0.1")
#'
#' # update job's instructions and units
#' update_job(id, instructions = "blank", units_per_assignment = 3)
#' }
#' @seealso \code{\link{create_job}}
#' @export
update_job <- function(id, 
                      title = NULL, 
                      instructions = NULL, 
                      cml = NULL, 
                      payment_cents = NULL, 
                      units_per_assignment = NULL, 
                      auto_launch = NULL,
                      verbose = TRUE, 
                      ...){

    # preparing body of request
    body <- list()
    if (!is.null(title)) {
        body['job[title]'] <- title
    }
    if (!is.null(instructions)) {
        body['job[instructions]'] <- instructions
    }
    if (!is.null(cml)) {
        body['job[cml]'] <- cml
    }
    if (!is.null(payment_cents)) {
        body['job[payment_cents]'] <- payment_cents
    }
    if (!is.null(units_per_assignment)) {
        body['job[units_per_assignment]'] <- units_per_assignment
    }
    if (!is.null(auto_launch)) {
        body['job[auto_order]'] <- auto_launch
    }
    
    # API request to create job
    endpoint <- paste0('jobs/', id, '.json')
    newjob <- cf_query(endpoint, type = "PUT", body = body, ...)
    
    if (verbose) {
        message("Job successfully updated with ID = ", newjob$id)
    }
    
    return(invisible(newjob$id))

}
