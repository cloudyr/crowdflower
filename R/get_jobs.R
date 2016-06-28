#' @title 
#' Retrieve list of all jobs.
#' @description \code{cf_jobs_list} queries for all jobs under the account related to the API key for the authenticated user.
#' @param page A vector of integers specifying which page(s) of results to return. A page contains up to 10 jobs. The default (\code{NULL}) is to return all jobs.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A data.frame containing details of all jobs. The \code{id} 
#' column provides the Crowdflower Job ID for each job.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#account_information}{Crowdflower API documentation}
#' @examples
#' \dontrun{
#' # return first page of jobs
#' cf_jobs_list(page = 1)
#'
#' # return all jobs
#' cf_jobs_list()
#' }
#' @seealso \code{\link{cf_account}}
#' @keywords jobs
#' @export
cf_jobs_list <- function(page = NULL, ...){

    if (is.null(page)) {
        # return all jobs
        jobs <- cf_query("jobs.json", query = list(page = 1), ...)
        if (length(jobs)) {
            d <- list(jobDataToDF(jobs))
            if (nrow(d[[1]]) == 10) {
                p <- 2
                nr <- 10
                while (nr == 10) {
                    d[[p]] <- jobDataToDF(cf_jobs_list(page = p, ...))
                    nr <- nrow(d[[p]])
                    p <- p + 1
                }
                out <- do.call("rbind", d)
            } else {
                out <- d[[1]]
            }
        } else {
            out <- structure(list(id = integer(0), 
                                  title = character(0), 
                                  judgments_per_unit = integer(0), 
                                  units_per_assignment = integer(0), 
                                  max_judgments_per_worker = logical(0), 
                                  max_judgments_per_ip = logical(0), 
                                  gold_per_assignment = integer(0), 
                                  payment_cents = integer(0), 
                                  completed_at = logical(0), 
                                  state = character(0), 
                                  created_at = character(0), 
                                  units_count = integer(0), 
                                  golds_count = integer(0), 
                                  judgments_count = integer(0), 
                                  crowd_costs = numeric(0), 
                                  quiz_mode_enabled = logical(0), 
                                  completed = logical(0)), class = "data.frame")
            
        }
    } else {
        # return selected job pages
        out <- do.call("rbind", lapply(page, function(x) {
            a <- cf_query("jobs.json", query = list(page = x), ...)
            jobDataToDF(a)
        }))
    }
    
    return(out)
}
