#' @rdname channels
#' @title Get and set job channels
#' @description Get, set, and replace the \dQuote{tags} for a job
#' @param id A character string containing an ID for job.
#' @param channel A character string containing the name of a channel, as returned by \code{\link{list_channels}}.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A logical \code{TRUE}, or an error.
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
#' @seealso \code{\link{create_job}}
#' @export
add_channel <- function(id, channel, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/channels')
    out <- cf_query(endpoint, type = "POST", 
                   body = list(channels = channel), 
                   encode = "json", ...)
    if (verbose) {
        #message(out$success)
    }
    return(out)

}

#' @rdname channels
#' @export
remove_channel <- function(id, channel, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/disable_channel')
    out <- cf_query(endpoint, type = "POST", 
                   body = list(channel_name = channel), 
                   encode = "json", ...)
    if (verbose) {
        #message(out$success)
    }
    return(out)

}
