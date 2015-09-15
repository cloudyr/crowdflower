#' @rdname getAccount
#' @export
#'
#' @title 
#' Retrieve account information
#'
#' @description
#' \code{getAccount} retrieves the CrowdFlower account information
#' related to the API key for the authenticated user
#'
#' @param ... Additional arguments passed to \code{\link{APIcall}}.

getAccount <- function(...){

	# initial API request
	account <- APIcall("account.json", ...)
	return(account)

}