# crowdflower 0.2.0

* Revised the package function names to use consistent `camel_case`
* Implemented an R6 interface to manage Crowdflower jobs using reference semantics.

# crowdflower 0.1.1

Initial release

* getAccount() and getJobs() retrieve information about authenticated user and currents jobs.
* createJob() creates a new task with a given title, set of instructions, and CML layout.
* updateJob() updates title, instructions or layout for an existing job.
* addData() uploads data from a data frame to a job.
* getStatus() checks status of a running job.
* getRows() downloads coded units from a running job.
