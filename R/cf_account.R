#' @title Retrieve account information
#' @description Retrieves CrowdFlower account information for the registered user.
#' related to the API key for the authenticated user
#' @param ... Additional arguments passed to \code{\link{cf_query}}.
#' @return A list containing account details for the authenticated user.
#' @references \href{https://success.crowdflower.com/hc/en-us/articles/202703425-CrowdFlower-API-Requests-Guide#account_information}{Crowdflower API documentation}
#' @examples
#' \dontrun{
#' Sys.setenv("CROWDFLOWER_KEY" = "examplekey")
#' cf_account()
#' }
#' @seealso \code{\link{cf_jobs_list}}
#' @keywords account
#' @export
cf_account <- function(...){

    # initial API request
    account <- cf_query("account.json", ...)
    return(account)

}
