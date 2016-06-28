#' @rdname tags
#' @title Get and set job tags
#' @description Get, set, and replace the \dQuote{tags} for a job
#' @param id A character string containing an ID for job.
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return For \code{get_tags}, a character vector of tags. Otherwise, a logical \code{TRUE}, or an error.
#' @examples 
#' \dontrun{
#' # create new job
#' f1 <- system.file("templates/instructions1.html", package = "crowdflower")
#' f2 <- system.file("templates/cml1.xml", package = "crowdflower")
#' j <- create_job(title = "Job Title", 
#'                instructions = readChar(f1, nchars = 1e8L),
#'                cml = readChar(f2, nchars = 1e8L))
#'
#' # get tags
#' get_tags(j)
#'
#' # add new tag
#' add_tags(j, "textanalysis")
#' 
#' # replace tags
#' add_tags(j, c("foo", "bar"))
#' get_tags(j)
#' }
#' @seealso \code{\link{create_job}}
#' @keywords tags
#' @export
get_tags <- function(id, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- cf_query(endpoint, type = "GET", ...)
    
    out2 <- unlist(lapply(out, `[[`, "name"))
    if (is.null(out2)) {
        return(character())
    }
    return(out2)

}

#' @rdname tags
#' @param tags For \code{add_tags}, a character vector specifying one or more tags to add. For \code{replace_tags}, the same but to \emph{replace} rather than \emph{add} the tags.
#' @param verbose A logical indicating whether to print additional information about the request.
#' @export
add_tags <- function(id, tags, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- cf_query(endpoint, type = "POST", 
                   body = list(tags = paste(tags, collapse = ",")), 
                   encode = "multipart", ...)
    if (verbose) {
        message(out$success)
    }
    return(TRUE)

}

#' @rdname tags
#' @export
replace_tags <- function(id, tags, verbose = TRUE, ...){

    endpoint <- paste0('jobs/', id, '/tags')
    out <- cf_query(endpoint, type = "PUT", 
                   body = list(tags = paste(tags, collapse = ",")), 
                   encode = "multipart", ...)
    if (verbose) {
        message(out$success)
    }
    return(TRUE)

}
