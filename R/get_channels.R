#' @title List available channels
#' @description Retrieve a list of available channels for a job
#' @param id A character string containing an ID for job.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A list.
#' @examples 
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # list available channels
#' ch <- list_channels(j)
#' ch
#'
#' # add new channel
#' add_channel(j, ch[1])
#' 
#' # remove a channel
#' remove_channel(j, ch[1])
#' }
#' @seealso \code{\link{add_channel}}, \code{\link{remove_channel}}
#' @keywords channels
#' @export
list_channels <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/channels')
    out <- cf_query(endpoint, type = "GET", ...)
    
    return(out)
}
