#' @title Execute a Crowdflower API call
#' @description Connects to the CrowdFlower API and executes an API request, returning the content of the HTTP response.
#' @param endpoint A character string specifying the endpoint of API request relative to \code{base_url}
#' @param query A list containing named URL query parameters to add to request URL.
#' @param body Additional parameters to add to request body.
#' @param key A character string containing a Crowdflower API key.
#' @param type A character string specifying the type of HTTP request (\dQuote{GET}, \dQuote{POST}, \dQuote{PUT}, etc.).
#' @param parse A logical indicating whether to parse the response (\code{TRUE}, the default) or return a raw vector (\code{FALSE}).
#' @param base_url A character string specifying the base URL of API request.
#' @param ... Additional arguments passed to an HTTP request function (e.g, \code{\link[httr]{GET}}, \code{\link[httr]{POST}}, \code{\link[httr]{PUT}}).
#' @return A character string containing the content of the HTTP request.
#' @importFrom httr GET POST PUT DELETE stop_for_status content
#' @export
cf_query <- function(endpoint, 
                    query = NULL, 
                    body = NULL, 
                    type = "GET", 
                    parse = TRUE,
                    key = Sys.getenv("CROWDFLOWER_API_KEY"),
                    base_url = 'https://api.crowdflower.com/v1/', 
                    ...){

    # params for API call
    query <- c(list(key = key), query)
    url <- paste0(base_url, endpoint)
    
    # making API request
    r <- switch(type, 
                GET = httr::GET(url, query = query, ...),
                POST = httr::POST(url, query = query, ..., body = body),
                "POST-DATA" = httr::POST(url, query = query, ..., body = body, encode="json"),
                PUT = httr::PUT(url, query = query, ..., body = body),
                DELETE = httr::DELETE(url, query = query, ...),
                stop("Value of request 'type' unrecognized."))
    httr::stop_for_status(r)
    
    # trying to parse response
    if (isTRUE(parse)) {
        error <- tryCatch(httr::content(r),
                          error = function(e) e)
        if (!inherits(error, 'error')) {
            # if JSON contains embedded error message, return it
            if (length(error$error)){
                stop(error$error)
            }
            # else return the response value
            response <- error
        } else {
            # try returning raw text response
            warning("Response was not JSON")
            response <- httr::content(r, 'text')
        }
    } else {
        response <- httr::content(r, "raw")
    }
    return(response)
}
