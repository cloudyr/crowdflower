#' @title Get Job Legend
#' @description Get the \dQuote{legend} (description) for a job
#' @param id A character string containing an ID for job.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A list
#' @examples 
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # get the legend
#' get_job_legend(id, title = "New Title")
#' }
#' @seealso \code{\link{create_job}}
#' @keywords jobs
#' @export
get_job_legend <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/legend.json')
    out <- cf_query(endpoint, type = "GET", ...)
    
    return(out)

}
