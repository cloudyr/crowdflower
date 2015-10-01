#' @rdname APIcall
#' @export
#'
#' @title 
#' Execute API call to CrowdFlower API.
#'
#' @description
#' \code{APIcall} connects to the CrowdFlower API and executes an
#' API request.
#'
#' @param endpoint endpoint of API request.
#'
#' @param params additional text to add to request URL.
#'
#' @param body additional parameters to add to request body.
#'
#' @param key A character string containing a Crowdflower API key.
#'
#' @param type type of requests (GET, POST, PUT).
#'
#' @param base_url Base URL of API request.
#'
#' @return A character string containing the JSON response from the Crowdflower API.

APIcall <- function(endpoint, params=NULL, body=NULL, type="GET", 
                    key = Sys.getenv("CROWDFLOWER_API_KEY"),
                    base_url='https://api.crowdflower.com/v1/'){

	# params for API call
	url <- paste0(base_url, endpoint, '?key=', key)
	if (!is.null(params)) url <- paste0(url, params)
	
	# making API request
	if (type=="GET") r <- httr::GET(url)
	if (type=="POST") r <- httr::POST(url, body=body)
	if (type=="POST-DATA") r <- httr::POST(url, body=body, encode="json")
	if (type=="PUT") r <- httr::PUT(url, body=body)

	# trying to parse response
	error <- tryCatch(response <- httr::content(r),
		error = function(e) e)
	# if response contains error message, return that message
	if (!inherits(error, 'error')){
		if (length(response$error)>0){
			stop(response$error$message)
		}
	}
	# if content was not properly parsed with default (json),
	# try raw text
	if (inherits(error, 'error')){
		response <- httr::content(r, 'text')
	}

	return(response)

}


