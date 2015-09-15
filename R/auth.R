#' Authenticate connection to CrowdFlower API.
#'
#' \code{authCF} stores the user's API Key in a local environment
#' and checks that the connection was successful.  
#'
#' @param api_key User's API key to connect to CrowdFlower's API, available in
#' \url{https://make.crowdflower.com/account/user}.
#' @rdname authCF
#' @seealso \url{https://success.crowdflower.com/hc/en-us/articles/202703445-CrowdFlower-API-Integrating-with-the-API#api_key}
#' @export
authCF <- function(api_key = NULL) { 

# 	# get the key if none supplied
#     if (is.null(api_key)) return(getKey())
#     
    # API key will be stored in new environment
	#cf_key_cache$api_key <- api_key
	assign("api_key", api_key, envir = cf_key_cache)

	# testing that it works
	key <- getKey()
	account <- APIcall("account.json")

	# returning information message
	if ('auth_key' %in% names(account) && account$auth_key == key) {
		message('Authentication successful.')
	} 
	else {
		stop('Authentication not successful. Wrong API key?')
	}

}

#' @rdname getKey
#' @export
#'
#' @title 
#' Return API key from local environment.
getKey <- function() {

	# returns api key from cf_key_cache environment
	error <- tryCatch(key <- get("api_key", envir=cf_key_cache),
		error=function(e) e)
	# if it cannot find the key, prompts user to read documentation
	if (inherits(error, "error")){
		stop('User not authenticated. See ?authCF.')
	}
	return(key)
}

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
#' @param type type of requests (GET, POST, PUT).
#'
#' @param base_url Base URL of API request.
#'
APIcall <- function(endpoint, params=NULL, body=NULL, type="GET", base_url='https://api.crowdflower.com/v1/'){

	# params for API call
	key <- getKey()
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






