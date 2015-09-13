#' @rdname createJob
#' @export
#'
#' @title 
#' Creates a new job
#'
#' @description
#' \code{createJob} creates a new CrowdFlower Job.
#'
#' @param title Title for new job
#' 
#' @param instructions Instructions for new job
#'
#' @param cml Layout for new job.


createJob <- function(title=NULL, instructions=NULL, cml=NULL){

	# preparing body of request
	body <- list()
	if (!is.null(title)) body['job[title]'] <- title
	if (!is.null(title)) body['job[instructions]'] <- instructions
	if (!is.null(title)) body['job[cml]'] <- cml

	# API request to create job
	newjob <- APIcall("jobs.json", type="POST", body=body)
	message("Job successfully created with ID = ", newjob$id)

	return(invisible(newjob$id))

}