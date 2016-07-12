#' @rdname crowdflower_r6
#' @title Crowdflower Job R6 Class
#' @description An R6 class for managing Crowdflower jobs using reference semantics
#' @details This is an experimental R6 interface for working with Crowdflower jobs. The advantage of using a \dQuote{Job}-class object to manage your Crowdflower operations is that the local object is always up-to-date with remote changes and operations can be performed without specifying a job identifier. The semantics of R6 are slightly different from traditional R code, but will quickly make sense after working through some examples.
#' @section Methods:
#' \itemize{
#'   \item \code{add_data(data, ...)} Add a data.frame or CSV file of data to a job using \code{\link{job_add_data}}
#'   \item \code{convert_gold()} Convert uploaded questions to \dQuote{gold questions} using \code{\link{job_convert_gold}}
#'   \item \code{launch(channel = , units = 100)} Launch the job using \code{\link{job_launch}}.
#'   \item \code{pause()} Pause the job using \code{\link{job_pause}}
#'   \item \code{resume()} Resume the (paused) job using \code{\link{job_resume}}
#'   \item \code{cancel()} Cancel the job using \code{\link{job_cancel}}
#'   \item \code{get()} Get information about the job using \code{\link{job_get}}
#'   \item \code{get_unit(unit)} Get data on a given unit (row) from the job using \code{\link{results_get}}
#'   \item \code{get_results(n = Inf)} Return a specified number of results from the job using \code{\link{results_get}}. Default is all results.
#'   \item \code{get_report()} Return a report document using \code{\link{report_get}}. Default is the \dQuote{full} report.
#'   \item \code{report_regenerate()} Regenerate a report using \code{\link{report_regenerate}}.
#'   \item \code{contributor} Initialize a new R6 \dQuote{Contributor} object in order to \code{flag()}, \code{unflag()}, \code{reject()}, \code{bonus()}, or \code{notify()} a contributor (worker).
#' }
#' @section Active Fields:
#' Active fields are like list elements, but are \dQuote{active} meaning that they are updated against the Crowdflower API each time they accessed. This means that they are always current. They can also be set using the standard \code{<-} operator.
#' \itemize{
#'   \item \code{channels} A list of Crowdflower channels on which the job is available.
#'   \item \code{cml} The Crowdflower Markup Language (CML) describing the job
#'   \item \code{instructions} Instructions shown to the worker
#'   \item \code{legend} The legend text being displayed to workers for the job.
#'   \item \code{status} The job's status.
#'   \item \code{tags} A list of tags for the job.
#'   \item \code{title} A list of tags for the job.
#' }
#' @seealso \code{\link{job_create}}
#' @examples
#' \dontrun{
#' # initialize a 'job' object for an existing job
#' job <- Job$new(id = "examplejobid")
#' job
#' ## add data to job
#' job$add_data(data.frame(x = 1:3))
#' ## get and set a job's title
#' job$title
#' job$title <- "New Title"
#' job$title
#' 
#' ## control job
#' job$launch()
#' job$pause()
#' job$resume()
#' job$cancel()
#'
#' ## get results
#' job$get_results()
#' 
#' # initialize a 'contributor' object
#' worker <- job$contributor("example_contributor")
#' ## notify the worker
#' worker$notify("Hello, worker!")
#' }
#' @importFrom R6 R6Class
#' @export
Job <- R6::R6Class("crowdflower_job",
    public = list(
        # add data
        add_data = function(data, ...) {
            job_add_data(private$id, data, ...)
        },
        convert_gold = function(...) {
            job_convert_gold(private$id, ...)
        },
        
        # control functions
        launch = function(channel = "cf_internal", units = 100, ...) {
            job_launch(private$id, channel = channel, units = units, ...)
        },
        pause = function(...) {
            job_pause(private$id, ...)
        },
        cancel = function(...) {
            job_cancel(private$id, ...)
        },
        resume = function(...) {
            job_resume(private$id, ...)
        },
        
        # results functions
        get = function(...) {
            job_get(id = private$id, ...)
        },
        get_unit = function(unit, type = "aggregated", ...) {
            results_get(id = private$id, unit = unit, ...)
        },
        get_results = function(n = Inf, type = "aggregated", ...) {
            self$results = results_get(id = private$id, n = n, ...)
            results
        },
        get_report = function(report_type = "full", ...) {
            report_get(private$id, ...)
        },
        report_regenerate = function(report_type = "full", ...) {
            report_regenerate(private$id, ...)
        },
        
        # contributor functions
        contributor = function(contributor) {
            Contributor$new(job = private$id, contributor = contributor)
        },
        
        # pretty print method
        print = function() {
            print(job_status(private$id))
        },
        
        # sync local copy with crowdflower
        sync = function(...) {
            j <- job_get()
            private$title <- j$title
            private$instructions <- j$instructions
            private$cml <- j$cml
            private$payment_cents <- j$payment_cents
            private$units_per_assignment <- j$units_per_assignment
            private$auto_launch <- j$auto_launch
            private$cml <- j$cml
            
        },
        
        # initialization function
        initialize = function(id = NULL, title = NULL, instructions = NULL, cml = NULL, copy = NULL, rows = TRUE, gold = FALSE, ...) {
            if (!is.null(id)) {
                private$id <- job_get(id = id, ...)$id
            } else if (!is.null(title)) {
                private$id <- job_create(title = title, instructions = instructions, cml = cml, ...)
            } else {
                private$id <- job_copy(copy, rows = rows, gold = gold, ...)
            }
            private$id
        }
    ),
    active = list(
        channels = function(x) {
            if (missing(x)) {
                job_channel_list(private$id)
            } else {
                # set the channels
            }
        },
        cml = function(x) {
            if (missing(x)) {
                self$get()[["cml"]]
            } else {
                job_update(cml = x)
            }
        },
        instructions = function(x) {
            if (missing(x)) {
                self$get()[["instructions"]]
            } else {
                job_update(instructions = x)
            }
        },
        legend = function(x) {
            if (missing(x)) {
                job_legend_get(private$id)
            } else {
                # set the legend
            }
        },
        status = function() {
            job_status(private$id)
        },
        tags = function(x) {
            if (missing(x)) {
                job_tags_get(private$id)
            } else {
                # set the tags
            }
        },
        title = function(x) {
            if (missing(x)) {
                self$get()[["title"]]
            } else {
                job_update(title = x)
            }
        }
    ),
    private = list(
        id = NULL,
        alias = NULL,
        css = NULL,
        created_at = NULL,
        data = NULL,
        gold_per_assignment = NULL,
        js = NULL,
        judgments_per_unit = NULL,
        max_judgments_per_worker = NULL,
        pages_per_assignment = NULL,
        units_per_assignment = NULL,
        updated_at = NULL        
    )
)

#' @rdname crowdflower_r6
#' @export
Contributor <- R6::R6Class("crowdflower_contributor",
    public = list(
        # initialize
        initialize = function(job, contributor) {
            private$job = job
            private$id = contributor
        },
        # print
        print = function() {
            cat(paste0("Crowdflower contributor ", private$id, " for job ", private$job, "\n"))
            cat(paste0("Available methods: flag(), unflag(), reject(), notify(), bonus()\n"))
        },
        
        # flag
        flag = function(reason, ...) {
            job_contributor_flag(id = private$job, contributor = private$id, reason = reason, ...)
        },
        # unflag
        unflag = function(reason, ...) {
            job_contributor_unflag(id = private$job, contributor = private$id, reason = reason, ...)
        },
        # reject
        reject = function(reason, ...) {
            job_contributor_reject(id = private$job, contributor = private$id, reason = reason, ...)
        },
        # notify
        notify = function(msg, ...) {
            job_contributor_notify(id = private$job, contributor = private$id, msg = msg, ...)
        },
        # bonus
        bonus = function(amount, ...) {
            job_contributor_bonus(id = private$job, contributor = private$id, amount = amount, ...)
        }
    ),
    private = list(
        job = NULL,
        id = NULL 
    )
)
