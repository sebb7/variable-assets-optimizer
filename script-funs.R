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
  # Function returns ticker of companies whose mean return was > 0 in given
  # chunk of data 
  companies <- c()
  for (ticker in tickers) {
    mean_rr <- mean(chunk[,ticker])
    if(mean_rr > 0){
      companies <- (c(companies, ticker))
    }
  }
  return(companies)
}

FallingCompanies <- function(tickers, chunk){
  # Function returns ticker of companies whose mean return was < 0 in given
  # chunk of data 
  companies <- c()
  for (ticker in tickers) {
    mean_rr <- mean(chunk[,ticker])
    if(mean_rr < 0){
      companies <- (c(companies, ticker))
    }
  }
  return(companies)
}

ReturnsWhenInIndex <- function(all_returns, share_data){
  # Adjust dates in share_data 
  # Add 3 days to fridays with newly calculated share data
  updated_all_returns <- all_returns
  updated_share_data <- share_data
  index(updated_share_data) <- index(share_data) + 3
  for(i in 1:length(index(all_returns))){
    for(j in 1:length(colnames(all_returns))){
      return_opts <- all_returns[i,j]
      ticker <- colnames(return_opts)
      date <- index(return_opts)
      return <- coredata(return_opts)[1]
      if(IsInIndex(ticker, date, updated_share_data)){
        updated_all_returns[i,j] <- return
      } else {
        updated_all_returns[i,j] <- 0
      }
    }
  } 
  return(updated_all_returns)
}

IsInIndex <- function(ticker, date, share_data){
  composition_date <- tail(index(share_data[paste("/", date, sep = "")]), n = 1)
  row_for_date <- share_data[composition_date]
  if(!is.na(row_for_date[,ticker])){
    return(TRUE)
  }
  return(FALSE)
}
