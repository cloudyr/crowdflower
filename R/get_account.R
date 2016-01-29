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
#' @param ... Additional arguments passed to \code{\link{crowdflowerAPIQuery}}.
#'
#' @return A list containing account details for the authenticated user.
#'
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#account_information}{Crowdflower API documentation}
#' 
#' @examples
#' \dontrun{
#' getAccount()
#' }

getAccount <- function(...){

    # initial API request
    account <- crowdflowerAPIQuery("account.json", ...)
    return(account)

}
