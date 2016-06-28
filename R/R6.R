#' @rdname R6
#' @title Job R6 Class
#' @description An R6 class for managing Crowdflower jobs using reference semantics
#' @details This is an experimental R6 interface for working with Crowdflower jobs
#' @seealso \code{\link{job_create}}
#' @importFrom R6 R6Class
#' @export
Job <- R6::R6Class("crowdflower_job",
    public = list(
        # add data
        add_data = function(data, ...) {
            job_add_data(private$id, data, ...)
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
        report = function(...) {
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
        sync = function(...) { },
        
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
        channels = function() {
            job_channel_list(private$id)
        },
        legend = function() {
            job_legend_get(private$id)
        },
        tags = function() {
            job_tags_get(private$id)
        },
        status = function() {
            job_status(private$id)
        }
    ),
    private = list(
        id = NULL,
        title = NULL,
        alias = NULL,
        judgments_per_unit = NULL,
        units_per_assignment = NULL,
        pages_per_assignment = NULL,
        max_judgments_per_worker = NULL,
        gold_per_assignment = NULL,
        created_at = NULL,
        updated_at = NULL,
        instructions = NULL,
        cml = NULL,
        js = NULL,
        css = NULL
        
    )
)

#' @rdname R6
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
