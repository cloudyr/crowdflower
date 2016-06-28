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
#' j <- job_create(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # list available channels
#' ch <- job_channels(j)
#' ch
#'
#' # add new channel
#' channel_add(j, ch[1])
#' 
#' # remove a channel
#' job_channel_remove(j, ch[1])
#' }
#' @seealso \code{\link{channel_add}}, \code{\link{job_channel_remove}}
#' @keywords channels
#' @export
job_channels <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/channels')
    out <- cf_query(endpoint, type = "GET", ...)
    
    return(out)
}
