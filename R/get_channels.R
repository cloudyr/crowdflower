#' @rdname listChannels
#'
#' @title 
#' List available channels
#'
#' @description 
#' Retrieve a list of available channels for a job
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.
#'
#' @return A list.
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
#' # list available channels
#' ch <- listChannels(j)
#' ch
#'
#' # add new channel
#' addChannel(j, ch[1])
#' 
#' # remove a channel
#' removeChannel(j, ch[1])
#' }
#'
#' @seealso \code{\link{addChannel}}, \code{\link{removeChannel}}
#' @export
listChannels <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/channels')
    out <- APIcall(endpoint, type = "GET", ...)
    
    return(out)

}
