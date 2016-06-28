#' @rdname cf_query
#' @title Execute API call to CrowdFlower API.
#' @description \code{cf_query} connects to the CrowdFlower API and executes an API request.
#' @param endpoint endpoint of API request.
#' @param query A list containing named URL query parameters to add to request URL.
#' @param body additional parameters to add to request body.
#' @param key A character string containing a Crowdflower API key.
#' @param type type of requests (GET, POST, PUT).
#' @param base_url Base URL of API request.
#' @param ... Additional arguments passed to an HTTP request function, e.g, \code{\link[httr]{GET}} or \code{\link[httr]{POST}}.
#' @return An integer specifying the new Crowdflower job ID.
#' @export
cf_query <- function(endpoint, 
                    query = NULL, 
                    body = NULL, 
                    type = "GET", 
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
                stop("Value of request 'type' unrecognized."))
    httr::stop_for_status(r)
    
    # trying to parse response
    error <- tryCatch(httr::content(r),
                      error = function(e) e)
    if (!inherits(error, 'error')){
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

    return(response)
}
