# Install necessary packages
# install.packages()o
# install.packages(qrmdata)

# Load libraries
library(fPortfolio)
library(PerformanceAnalytics) #portfolio min
library(xts)
library(quantmod)
library(plyr)

# Add config
source("config.R")

# Add spec for calculating portfolio
Constraints = "LongOnly"
Spec = portfolioSpec()

# Add functions
source("script-funs.R")

# Load files for WIG30
load(file = "./R_data/sample_wig_30_r_data/share_data.Rda")
load(file = "./R_data/sample_wig_30_r_data/all_wig_30_companies_returns.Rda")

# Chnage names of colums for returns xts
for(i in 1:length(colnames(all_returns))){
  colnames(all_returns) <- lapply(colnames(all_returns), substr, start = 1, stop = 3)
}

# Get vector with tickers of all companies
all_companies_tickers <- colnames(all_returns)


  
  
################ Build xts with portfolio weights
################
# Each weights calculated based on data from previous peroid are set for new peroid
# Start calculations after set of first min-variance portfolio
# Calculate weights only evry `recalc_freq`
  
# Create new xts for Markowitz weights for each perioid of `calc_peroid` 
df <- data.frame(matrix(ncol = ncol(all_returns), nrow = 1))
colnames(df) <- colnames(all_returns)
min_portfolio_weights <- xts(df, order.by = index(all_returns)[1])

for(day in calc_period:length(all_returns)){
  
  # Get current date and date for next day
  date <- index(all_returns[day])
  next_day_date <- index(all_returns[day + 1])
  
  if(day + recalc_freq > length(index(all_returns))){
    # Dont calculate if there is no days enough 
    
    break
  } else if(day %% recalc_freq == 0){
    # Take action only every given number of days (`recalc_freq` from config file)

    calculation_chunk <- all_returns[(day-calc_period+1):day]
    
    # Get companies which are in index in given on portfolio recalculation
    companies_in_index <- CompaniesInIndex(date, share_data)
    
    # Get comapnies which enough quotations (quantity valid with `calc_peroid`)
    companies_valid_number_of_quotations <-
      CompaniesWithRightQuotations(companies_in_index, calculation_chunk)
    
    # Get companies which are indicated by the portfolio strategy
    chosen_companies <-
      CompaniesStrategyChosen(companies_valid_number_of_quotations, calculation_chunk)

    # Calculate min risk portfolio for given tickers
    min_portfolio_chunk <- calculation_chunk[,chosen_companies]
    min_risk_weights <- ComputeMinPortfolio(min_portfolio_chunk, Spec, Constraints)
    
    # Change weights to xts with given next date day
    current_weights <- xts(t(as.data.frame(min_risk_weights)),order.by = as.Date(next_day_date))
    
    # Add other companies with no weights
    lacking_companies <- setdiff(all_companies_tickers, chosen_companies)
    lacking_comapnies_matrix <- matrix(0, ncol = length(lacking_companies), nrow = 1)
    lacking_comapnies_df <- data.frame(lacking_comapnies_matrix)
    colnames(lacking_comapnies_df) <- lacking_companies
    lacking_comapnies_xts <- xts(lacking_comapnies_df,order.by = as.Date(next_day_date))
    current_weights <- cbind(current_weights, lacking_comapnies_xts)
    
    # Add calculated weights as weights for the next day 
    min_portfolio_weights <- merge(min_portfolio_weights, current_weights, deparse.level = 1)
    
  } else{
    
  }
}
################
################

  
       
    if(length(companies_in_index) != length(companies_valid_number_of_quotations)){
      print(date)
      print(calculation_chunk)
      print(companies_in_index )
      print(companies_valid_number_of_quotations)
    }
    

    
      print(i)
      
      i = i+1
  
      if(length(companies_in_index) != 30){
    
    print(date)
    
    print("aaa")
    i = i+1
    }
     if(i <= 4){
      print(date)
      print(calculation_chunk)
      
      print("aaa")
      print("aaa")
      print("aaa")
     }




    



