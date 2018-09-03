CompaniesInIndex <- function(date, share_data){
  # Returns vector with companies which were present in given time period
  
  composition_date <- tail(index(share_data[paste("/", date, sep = "")]), n = 1)
  row_for_date <- share_data[composition_date]
  tickers <- colnames(row_for_date[, !is.na(row_for_date)])
  return(tickers)
}

CompaniesWithRightQuotations <- function(tickers, number, date, all_returns){
  # Returns vector with comapnies which have enough number of quotations
  # given by `number` argument
  
  number_of_date <- which(date == index(all_returns), index(all_returns))
  chunk <- all_returns[(number_of_date-number+1):number_of_date]
  
  # Check which companeis in chunk lacks data
  tickers_with_boolean <- sapply(tickers, function(x) anyNA(chunk[, x]))
  updated_tickers <- names(tickers_with_boolean)[tickers_with_boolean == FALSE]
  return(updated_tickers)
}

ComputeMinPortfolio <- function(data){
  # Computes weigths for min risk portfolio for given data
  # Returns data frame with comapny names and weights
  
  # Compute initial weigths
  min_portfolio_result <- minriskPortfolio(as.timeSeries(data), na.rm = TRUE)
  initial_weights <- min_portfolio_result@spec@portfolio$weights
  
  # Create weigths with comapnies names
  m <- matrix(0, ncol = length(initial_weights), nrow = 0)
  portfolio_comapnies <- data.frame(m)
  portfolio_comapnies[1,] <- initial_weights
  names(portfolio_comapnies) <- names(data)
  return(portfolio_comapnies)
}


ComputeVariableMinPortfolio <- function(data){
  # Computes weigths for min risk portfolio for given data
  # Considers lack of some stock quotes
  # Returns data frame with comapny names and weights
  
}