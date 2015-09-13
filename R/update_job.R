#' @rdname updateJob
#' @export
#'
#' @title 
#' Updates settings for a given job.
#'
#' @param id ID for job to be updated.
#'
#' @param title New title.
#' 
#' @param instructions New set of instructions.
#'
#' @param cml New layout for job.


updateJob <- function(id, title=NULL, instructions=NULL, cml=NULL){

	# preparing body of request
	body <- list()
	if (!is.null(title)) body['job[title]'] <- title
	if (!is.null(title)) body['job[instructions]'] <- instructions
	if (!is.null(title)) body['job[cml]'] <- cml

	# API request to create job
	endpoint <- paste0('jobs/', id, '.json')
	newjob <- APIcall(endpoint, type="PUT", body=body)
	message("Job successfully updated with ID = ", newjob$id)

	return(invisible(newjob$id))

}