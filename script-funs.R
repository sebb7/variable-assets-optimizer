CompaniesInIndex <- function(date, share_data){
  # Returns vector with companies which were present in given time period
  
  composition_date <- tail(index(share_data[paste("/", date, sep = "")]), n = 1)
  row_for_date <- share_data[composition_date]
  tickers <- colnames(row_for_date[, !is.na(row_for_date)])
  return(tickers)
}

CompaniesWithRightQuotations <- function(tickers, chunk){
  # Returns vector with comapnies whose quotations dont have NAs
  
  # Check which companeis in chunk lacks data
  tickers_with_boolean <- sapply(tickers, function(x) anyNA(chunk[, x]))
  updated_tickers <- names(tickers_with_boolean)[tickers_with_boolean == FALSE]
  return(updated_tickers)
}

CompaniesStrategyChosen <- function(tickers, chunk, strategy){
  # This function returns companies tickers choosen by user set strategy
  
  if(strategy == 1){
    # Return all given companies
    tickers
  } else if(strategy == 2){
    # Select compnies whose average price was > 0
    RisingCompanies(tickers, chunk)
  } else if(strategy == 3){
    # Select compnies whose average price was < 0
    FallingCompanies(tickers, chunk)
  } else if(strategy == 4){
    # Select random number of random companies
    # Number of selected companies has to be lower than number of comapnies passed in
    random_number <- sample(c(1:length(tickers)), 1)
    companies <- sample(tickers, random_number)
    return(companies)
  }
}

ComputeMinPortfolio <- function(data, Spec, Constraints){
  # Computes weigths for min risk portfolio for given data
  # Returns data frame with comapny names and weights
  results <- minvariancePortfolio(as.timeSeries(data), Spec, Constraints)
  results@portfolio@portfolio$weights
}
  
RisingCompanies <- function(tickers, chunk){
  
}

FallingCompanies <- function(tickers, chunk){
  
}

ReturnsWhenInIndex <- function(all_returns, share_data){
  
}