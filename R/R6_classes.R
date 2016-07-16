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
#'   \item \code{get_unit(unit)} Get data on a given unit (row) from the job using \code{\link{results_get}}
#'   \item \code{get_results(n = Inf)} Return a specified number of results from the job using \code{\link{results_get}}. Default is all results.
#'   \item \code{get_report()} Return a report document using \code{\link{report_get}}. Default is the \dQuote{full} report. \code{\link{report_regenerate}} is called automatically.
#'   \item \code{contributor} Initialize a new R6 \dQuote{Contributor} object in order to \code{flag()}, \code{unflag()}, \code{reject()}, \code{bonus()}, or \code{notify()} a contributor (worker).
#'   \item \code{update(...)} Update features of a job using \code{\link{job_update}}
#'   \item \code{sync()} Synchronize local information in the R6 object with Crowdflower. This is performed automatically during various method calls but may be useful to call directly to make sure all job details are up to date.
#' }
#' @section Active Fields:
#' Active fields are like list elements, but are \dQuote{active} meaning that they are updated against the Crowdflower API each time they accessed. This means that they are always current. They can also be set using the standard \code{<-} operator.
#' \itemize{
#'   \item \code{auto_launch} A logical specifying whether to auto-launch the job.
#'   \item \code{channels} A list of Crowdflower channels on which the job is available.
#'   \item \code{cml} A character string contianing the Crowdflower Markup Language (CML) describing the job.
#'   \item \code{instructions} A character string containing instructions shown to the worker.
#'   \item \code{legend} A list specifying the generated keys that will be submitted with your form. This cannot be modified.
#'   \item \code{payment_cents} A numeric value specifying the payment per unit.
#'   \item \code{tags} A character vector of tags for the job.
#'   \item \code{time_per_assignments} An integer specifying the length of time available per assignment, in seconds. Default is 1800 (i.e., 30 minutes).
#'   \item \code{title} A character string specifying the job's title.
#'   \item \code{units_per_assignment} A numeric value specifying the number of units per assignment.
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
        get_unit = function(unit, type = "aggregated", ...) {
            results_get(id = private$id, unit = unit, ...)
        },
        get_results = function(n = Inf, type = "aggregated", ...) {
            self$results = results_get(id = private$id, n = n, ...)
            results
        },
        get_report = function(report_type = "full", ...) {
            report_regenerate(private$id, ...)
            Sys.sleep(0.5)
            report_get(private$id, ...)
        },
        
        # contributor functions
        contributor = function(contributor) {
            Contributor$new(job = private$id, contributor = contributor)
        },
        
        # pretty print method
        print = function() {
            #self$sync(verbose = FALSE)
            cat("Job:", private$id, "\n")
            cat("Title:", private$local_details$title, "\n")
            cat("Units Per Assignment:", private$local_details$units_per_assignment, "\n")
            cat("Payment:", private$local_details$payment_cents, "\n")
            print(job_status(private$id))
        },
        
        # sync local copy with crowdflower
        sync = function(verbose = FALSE, ...) {
            private$local_details <- job_get(private$id, verbose = verbose, ...)
            private$local_details <- job_legend_get(private$id, verbose = verbose, ...)
            private$local_status <- job_status(private$id, verbose = verbose, ...)
        },
        
        # update job details
        update = function(...) {
            job_update(private$id, ...)
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
        auto_launch = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$auto_launch
            } else {
                self$update(auto_launch = x)
            }
        },
        channels = function(x) {
            if (missing(x)) {
                self$sync()
                job_channel_list(private$id)
            } else {
                # set the channels
            }
        },
        cml = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$cml
            } else {
                self$update(cml = x)
            }
        },
        instructions = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$instructions
            } else {
                self$update(instructions = x)
            }
        },
        legend = function() {
            self$sync()
            private$local_legend
        },
        payment_cents = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$payment_cents
            } else {
                self$update(payment_cents = x)
            }
        },
        tags = function(x) {
            if (missing(x)) {
                job_tags_get(id = private$id)
            } else {
                job_tags_replace(id = private$id, tags = x)
            }
        },
        time_per_assignment = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$time_per_assignment
            } else {
                self$update(time_per_assignment = x)
            }
        },
        title = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$title
            } else {
                self$update(title = x)
            }
        },
        units_per_assignment = function(x) {
            if (missing(x)) {
                self$sync()
                private$local_details$units_per_assignment
            } else {
                self$update(units_per_assignment = x)
            }
        }
    ),
    private = list(
        id = NULL,
        local_status = list(),
        local_legend = list(),
        local_details = list()
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
