unlistWithNA <- function(lst, field){

    # takes elements of list with names 'field' and returns a vector
    # where NULL elements are converted to NAs

    if (length(field) == 1) {
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst, function(x) x[[field]]))
    }
    if (length(field) == 2) {
        notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field[1]]][[field[2]]])))
        vect <- rep(NA, length(lst))
        vect[notnulls] <- unlist(lapply(lst, function(x) x[[field[1]]][[field[2]]]))
    }
    return(vect)
}

jobDataToDF <- function(jobs){

    # converts list with jobs data in list format to a data.frame
    # (some fields are omitted)

    df <- data.frame(
        id = unlistWithNA(jobs, 'id'),
        title = unlistWithNA(jobs, 'title'),
        judgments_per_unit = unlistWithNA(jobs, 'judgments_per_unit'),
        units_per_assignment = unlistWithNA(jobs, 'units_per_assignment'),
        max_judgments_per_worker = unlistWithNA(jobs, 'max_judgments_per_worker'),
        max_judgments_per_ip = unlistWithNA(jobs, 'max_judgments_per_ip'),
        gold_per_assignment = unlistWithNA(jobs, 'gold_per_assignment'),
        payment_cents = unlistWithNA(jobs, 'payment_cents'),
        completed_at = unlistWithNA(jobs, 'completed_at'),
        state = unlistWithNA(jobs, 'state'),
        created_at = unlistWithNA(jobs, 'created_at'),
        units_count = unlistWithNA(jobs, 'units_count'),
        golds_count = unlistWithNA(jobs, 'golds_count'),
        judgments_count = unlistWithNA(jobs, 'judgments_count'),
        crowd_costs = unlistWithNA(jobs, 'crowd_costs'),
        quiz_mode_enabled = unlistWithNA(jobs, 'quiz_mode_enabled'),
        completed = unlistWithNA(jobs, 'completed'),
            stringsAsFactors=F)

    return(df)
}


rowDataToDF <- function(rows, type="aggregated"){
    
    # converts list with responses to a job in list format to a data frame

    # find response- and unit-level variables from a random sample of 3 units
    vars <- unique(c(names(rows[[sample(length(rows), 1)]]), 
        names(rows[[sample(length(rows), 1)]]), names(rows[[sample(length(rows), 1)]])))
    # response variables are those that are of class=list
    # NOTE: choosing a unit halfway through the task to avoid edge cases in gold questions, which
    # tend to be among first or last units of task.
    selected <- floor(length(rows)/2)
    response.vars <- vars[sapply(rows[[selected]], is.list)]
    # excluding gold questions, which are always unit variables
    response.vars <- response.vars[!grepl("_gold", response.vars)]
    # identifying multiple choice questions:
    # A) questions without 'res' field
    multiple.choice <- vars[sapply(rows[[selected]], function(x) 'res' %in% names(x) == FALSE)]
    multiple.choice <- response.vars[response.vars %in% multiple.choice]
    # B) questions where first response has 2+ values
    more.multiple.choice <- vars[sapply(rows[[selected]], function(x) 'res' %in% names(x) && length(x$res[[1]])>1)]
    multiple.choice <- unique(c(multiple.choice, more.multiple.choice))
    response.vars <- response.vars[-which(response.vars %in% multiple.choice)]
    # unit variables are the rest
    unit.vars <- vars[vars %in% c(response.vars, multiple.choice) == FALSE]
    df <- list()
    
    for (i in 1:length(rows)) {

        # first, replace NULLs with NAs
        rows[[i]] <- changeNULLtoNA(rows[[i]], response.vars=response.vars)

        if (type == "aggregated") {

            df[[i]] <- data.frame()

            # step 0: collapsing response IDs into a single variable
            if (length(rows[[i]][['_ids']])>1){
                suppressWarnings(rows[[i]][['_ids']] <- paste(unlist(rows[[i]][['_ids']]), collapse=","))
            }

            # _ids is always unit-level variable with aggregated responses
            if ("_ids" %in% unit.vars == FALSE){
                unit.vars <- c(unit.vars, "_ids")
            }
            if ("_ids" %in% response.vars == TRUE){
                response.vars <- response.vars[-which(response.vars=="_ids")]
            }

            # step 1: DF w/unit-level variables & multiple choice questions
            for (var in c(unit.vars, multiple.choice)) {
                df[[i]][1,var] <- paste0(unlist(rows[[i]][[var]]), collapse='\n')
                if ('agg' %in% names(rows[[i]][[var]])){
                    df[[i]][,paste0(var, ".agg")] <- rows[[i]][[var]]$agg
                }
            }
            # step 2: find aggregated responses
            for (var in response.vars) {
                df[[i]][,paste0(var, '.agg')] <- rows[[i]][[var]]$agg
            }
        } else if (type == "full") {
            # step 0: _ids is NOT a unit-level variable
            if ('_ids' %in% unit.vars) unit.vars <- unit.vars[-which(unit.vars=="_ids")]
            if ('_ids' %in% response.vars == FALSE) response.vars <- c(response.vars, '_ids')
            # step 1: DF w/unit-level variables
            df[[i]] <- data.frame()
            for (var in unit.vars){
                # export value if it's not NULL (it might be NULL for non-gold questions)
                df[[i]][1,var] <- ifelse(!is.null(rows[[i]][[var]]), rows[[i]][[var]], NA)
            }
            # step 2: find number of codings and expand DF
            codings <- length(rows[[i]][[response.vars[1]]]$res)
            df[[i]] <- df[[i]][rep(1, codings),]

            # step 3: adding multiple choice responses:
            for (var in multiple.choice){
                responses <- rows[[i]][[var]]
                if ('res' %in% names(responses)){ responses <- responses$res}
                # if NULL, then add NA
                if (length(responses)==1 && is.null(responses[[1]])){
                    df[[i]][,var] <- NA
                }
                # if fewer responses than codings, then add NAs
                if (length(responses)<codings){
                    df[[i]][,var] <- c(sapply(responses, function(x) paste(unlist(x), collapse="\n")),
                        rep(NA, codings - length(responses)))
                }
                # if same number of responses as codings, all is well
               if (length(responses)==codings){
                    df[[i]][,var] <- sapply(responses, function(x) paste(unlist(x), collapse="\n"))
                }
            }

            # step 4: adding individual responses
            for (var in response.vars){
                 responses <- unlist(rows[[i]][[var]]$res)
                # if no responses, add missing values
                if (length(responses) == 1 && is.na(responses)){
                    df[[i]][,var] <- responses
                }
                # if single response for each unit, then we can just add
                if (length(responses)==codings){
                    df[[i]][,var] <- responses
                }
                # if fewer responses than coding, fill up with missing values
                if (length(responses)<codings && length(responses)>0){
                    df[[i]][,var] <- c(responses, rep(NA, codings-length(responses)))
                }
                # if multiple responses to each item (open-ended questions), we collapse them
                length.responses <- unlist(lapply(rows[[i]][[var]]$res, length))
                if (any(length.responses > 1)){
                    for (j in which(length.responses > 1)){
                        rows[[i]][[var]]$res[[j]] <- paste(rows[[i]][[var]]$res[[j]], collapse='\n')
                    }
                    responses <- unlist(rows[[i]][[var]]$res)
                    # if single response for each unit, then we can just add
                    if (length(responses)==codings){
                        df[[i]][,var] <- responses
                    }
                    # if fewer responses than coding, fill up with missing values
                    if (length(responses)<codings && length(responses)>0){
                        df[[i]][,var] <- c(responses, rep(NA, codings-length(responses)))
                    }
                }
                # for _ids, we truncate it and take only the first few that correspond to
                # the number of codings
                if (var=="_ids"){
                    df[[i]][,var] <- unlist(rows[[i]][[var]])[1:codings]
                }
            }
        }
    }

    df <- do.call(rbind, df)
    return(df)
}


changeNULLtoNA <- function(lst, response.vars=NULL){

    # clean 1: NULL to NA
    nulls <- which(unlist(lapply(lst, length)) == 0)
    for (n in names(nulls)) {
        lst[[n]] <- NA
    }
    # clean 2: NULL responses to NA
    resp <- which(unlist(lapply(lst, function(x) 'res' %in% names(x))))
    for (n in names(resp)) {
        if (length(lst[[n]]$res) == 0) {
            lst[[n]]$res <- NA
        }
    }
    # clean 3: NULL aggregate responses to NA
    agg <- which(unlist(lapply(lst, function(x) 'agg' %in% names(x))))
    for (n in names(agg)) {
        if (length(lst[[n]]$agg) == 0) {
            lst[[n]]$agg <- NA
        }
    }
    # clean 4: for variables with no response whatsoever, add NAs
    other.resp.vars <- response.vars[response.vars %in% 
        c(names(resp), names(agg), "_ids") == FALSE]
    multiple.choice <- which(unlist(lapply(other.resp.vars, function(x) length(lst[[x]])))>0)
    other.resp.vars <- other.resp.vars[other.resp.vars %in% multiple.choice == FALSE]
    for (var in other.resp.vars){
        lst[[var]] <- list()
        lst[[var]]$res <- NA
        lst[[var]]$agg <- NA
    }
    return(lst)
}
