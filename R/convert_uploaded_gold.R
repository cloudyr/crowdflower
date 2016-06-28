

#' convert uploaded gold for a job
#' 
#' Convert to test questions all rows where column "_golden" is set to "true".
#' Corresponds to the "Convert Uploaded Test Questions" button on the Data page
#' of the web interface. 
#' @export
job_convert_gold <- function(id) {
    msg <- try(cf_query(endpoint <- paste0("jobs/", id, "/gold"), type = "PUT"))
    if (class(msg) == "try-error")
        message(attr(msg, "condition")$message)
    else
        message(paste(msg$success$message))
}
