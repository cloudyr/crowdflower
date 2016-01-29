#' @rdname getJobLegend
#' @export
#'
#' @title 
#' Get Job Legend
#'
#' @description 
#' Get the \dQuote{legend} for a job
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return A list
#'
#' @examples 
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- createJob(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # get the legend
#' getJobLegend(id, title = "New Title")
#'
#' }
#'
#' @seealso \code{\link{createJob}}

getJobLegend <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/legend.json')
    out <- crowdflowerAPIQuery(endpoint, type = "GET", ...)
    
    return(out)

}
