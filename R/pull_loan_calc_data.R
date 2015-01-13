#' Pull Data for use with the Loan Calculator
#' 
#' Uses list of loans and simulated payoff dates to output data used for weekly Loan Calc runs
#' 
#' @param loan_ids integer.  Vector of loan id's to run payoff calculator.
#' @param sim_payoff_date character.  The date used for payoff calculation of in flight loans.  Defaults to today.  Input as "YYYY-MM-DD"
#' @param output_directory character.  The filepath of the folder to output to.  Defaults to home folder.
#' @param file_identifier character.  Optional character tag to append to filename.
# do I use return????
#' @return Outputs 3 csv files for loan calculator
#' @author Mike Bruno
#' @examples
#' pull_loan_calc_data(1, "2015-01-10", output_directory = "~/query/output")
#' @export

pull_loan_calc_data <- function(loan_ids, 
                                sim_payoff_date = paste0("'", as.character(Sys.Date()),"'"), 
                                output_directory = "~/", 
                                file_identifier = "") {
  # Prep Loan IDs
  loan_ids <- paste(loan_ids,collapse = ",")
  loan_ids <- gsub("\n","",loan_ids)
    #TODO  Format the payoff date - Add '
    #TODO  Format output directory - add "/" if not already there
  # Query  
    #TODO, include these in the package and use from there
  payoff_inflight <- run_query(pp(prep_sql_file("~/projects/queries/Loan Calc/R - Loan Calculator - DevOps Request - In Flight Lo.sql")))
  calc_loader <- run_query(pp(prep_sql_file("~/projects/queries/Loan Calc/R - Loan Calc - Loader Query.sql")))
  calc_pop <- run_query(pp(prep_sql_file("~/projects/queries/Loan Calc/R - Loan Calc - Loan Population Query V3.sql")))
  # Write to CSV  
  write.csv(payoff_inflight, file = paste0(output_directory, "/Loan Calc - Need Payoff Amounts ", sim_payoff_date, file_identifier,".csv"), row.names=FALSE, na="")
  write.csv(calc_loader, file = paste0(output_directory, "/Loan Calc - Loader ", sim_payoff_date, file_identifier,".csv"), row.names=FALSE, na="")  
  write.csv(calc_pop, file = paste0(output_directory, "/Loan Calc - Input ", sim_payoff_date, file_identifier,".csv"), row.names=FALSE, na="")  
}