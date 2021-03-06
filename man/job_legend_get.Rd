% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/job_legend_get.R
\name{job_legend_get}
\alias{job_legend_get}
\title{Get Job Legend}
\usage{
job_legend_get(id, ...)
}
\arguments{
\item{id}{A character string containing an ID for job.}

\item{...}{Additional arguments passed to \code{\link{cf_query}}.}
}
\value{
A list
}
\description{
Get the \dQuote{legend} (description) for a job
}
\examples{
\dontrun{
# create new job
f1 <- system.file("templates/instructions1.html", package = "crowdflower")
f2 <- system.file("templates/cml1.xml", package = "crowdflower")
j <- job_create(title = "Job Title", 
                instructions = readChar(f1, nchars = 1e8L),
                cml = readChar(f2, nchars = 1e8L))

# add data
d <- data.frame(variable = 1:3)
job_add_data(id = j, data = d)

# get the legend
job_legend_get(id, title = "New Title")

# launch job
job_launch(id = j)

# get results
results_get(id = j)

# delete job
job_delete(j)
}
}
\seealso{
\code{\link{job_create}}
}
\keyword{jobs}
