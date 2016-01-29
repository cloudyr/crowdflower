#' @rdname tags
#'
#' @title 
#' Get and set job tags
#'
#' @description 
#' Get, set, and replace the \dQuote{tags} for a job
#'
#' @param id A character string containing an ID for job.
#'
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return For \code{getJobTags}, a character vector of tags. Otherwise, a logical \code{TRUE}, or an error.
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
#' # get tags
#' getJobTags(j)
#'
#' # add new tag
#' addJobTags(j, "textanalysis")
#' 
#' # replace tags
#' addJobTags(j, c("foo", "bar"))
#' getJobTags(j)
#' }
#'
#' @seealso \code{\link{createJob}}
#' @export
getJobTags <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- crowdflowerAPIQuery(endpoint, type = "GET", ...)
    
    out2 <- unlist(lapply(out, `[[`, "name"))
    if (is.null(out2)) {
        return(character())
    }
    return(out2)

}

#' @rdname tags
#' @param tags For \code{addJobTags}, a character vector specifying one or more tags to add. For \code{replaceJobTags}, the same but to \emph{replace} rather than \emph{add} the tags.
#'
#' @param verbose A logical indicating whether to print additional information about the request.
#'
#' @export
addJobTags <- function(id, tags, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- crowdflowerAPIQuery(endpoint, type = "POST", 
                   body = list(tags = paste(tags, collapse = ",")), 
                   encode = "multipart", ...)
    if (verbose) {
        message(out$success)
    }
    return(TRUE)

}

#' @rdname tags
#' @export
replaceJobTags <- function(id, tags, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- crowdflowerAPIQuery(endpoint, type = "PUT", 
                   body = list(tags = paste(tags, collapse = ",")), 
                   encode = "multipart", ...)
    if (verbose) {
        message(out$success)
    }
    return(TRUE)

}
