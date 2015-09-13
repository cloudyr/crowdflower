# environment where API key will be stored
cf_key_cache <- new.env()


unlistWithNA <- function(lst, field){

	# takes elements of list with names 'field' and returns a vector
	# where NULL elements are converted to NAs

	if (length(field)==1){
		notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field]])))
		vect <- rep(NA, length(lst))
		vect[notnulls] <- unlist(lapply(lst, function(x) x[[field]]))
	}
	if (length(field)==2){
		notnulls <- unlist(lapply(lst, function(x) !is.null(x[[field[1]]][[field[2]]])))
		vect <- rep(NA, length(lst))
		vect[notnulls] <- unlist(lapply(lst, function(x) x[[field[1]]][[field[2]]]))
	}
	return(vect)
}

jobDataToDF <- function(jobs){

	# converts list with jobs data in list format to a data frame
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

	# find response- and unit-level variables
	vars <- names(rows[[1]])
	lengths <- unlist(lapply(rows[[1]], length))
	response.vars <- vars[lengths==2]
	unit.vars <- vars[lengths==1]
	df <- list()
	
	for (i in 1:length(rows)){

		# first, replace NULLs with NAs
		rows[[i]] <- changeNULLtoNA(rows[[i]])

		if (type=="aggregated"){

			df[[i]] <- data.frame()

			# step 0: de-duplicating IDs
			if (length(rows[[i]][['_ids']])>1){
				suppressWarnings(rows[[i]][['_ids']] <- rows[[i]][['_ids']][[1]])
			}

			# step 1: DF w/unit-level variables
			for (var in unit.vars){
				df[[i]][1,var] <- paste0(rows[[i]][[var]][[1]], collapse='\n')
			}
			# step 2: find aggregated responses
			for (var in response.vars){
				df[[i]][,paste0(var, '.agg')] <- rows[[i]][[var]]$agg
			}
		}
	
		if (type=="full"){
			# step 0: _ids is NOT a unit-level variable
			if ('_ids' %in% unit.vars) unit.vars <- unit.vars[-which(unit.vars=="_ids")]
			if ('_ids' %in% response.vars == FALSE) response.vars <- c(response.vars, '_ids')
			# step 1: DF w/unit-level variables
			df[[i]] <- data.frame()
			for (var in unit.vars){
				df[[i]][1,var] <- paste0(rows[[i]][[var]][[1]], collapse='\n')
			}
			# step 2: find number of codings and expand DF
			codings <- length(rows[[i]][[response.vars[1]]]$res)
			df[[i]] <- df[[i]][rep(1, codings),]

			# step 3: adding individual responses
			for (var in response.vars){
				# for open-ended questions, combine into a single response
				mult.resp <- which(unlist(lapply(rows[[i]][[var]]$res, length))>1)
				for (r in mult.resp){
					suppressWarnings(rows[[i]][[var]]$res[[r]] <- 
							paste(rows[[i]][[var]]$res[[r]], collapse='\n'))
				}
				df[[i]][,var] <- unlist(rows[[i]][var])[-(codings+1)]
			}
		}
	}

	df <- do.call(rbind, df)
	return(df)
}


changeNULLtoNA <- function(lst){

	# clean 1: NULL to NA
	nulls <- which(unlist(lapply(lst, length))==0)
	for (n in names(nulls)){
		lst[[n]] <- NA

	}
	# clean 2: NULL responses to NA
	resp <- which(unlist(lapply(lst, function(x) 'res' %in% names(x))))
	for (n in names(resp)){
		if (length(lst[[n]]$res)==0){
			lst[[n]]$res <- NA
		}
	}
	# clean 3: NULL aggregate responses to NA
	agg <- which(unlist(lapply(lst, function(x) 'agg' %in% names(x))))
	for (n in names(agg)){
		if (length(lst[[n]]$agg)==0){
			lst[[n]]$agg <- NA
		}
	}
	return(lst)
}



