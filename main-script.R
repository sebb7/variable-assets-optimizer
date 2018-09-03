# Install necessary packages
# install.packages()o
# install.packages(qrmdata)

# Load libraries
library(fPortfolio)
library(PerformanceAnalytics)
library(xts)

# Add config
source("config.R")

# Add functions
source("script-funs.R")

# Load files for WIG30
load(file = "./R_data/sample_wig_30_r_data/share_data.Rda")
load(file = "./R_data/sample_wig_30_r_data/all_wig_30_companies_returns.Rda")

# Create new xts for Markowitz weights for each perioid of `calc_peroid` 
share_data[, NA]
initial_portfolio_companies <- ComputeMinPortfolio(study_data)

# Chnage names of colums for returns xts
for(i in 1:length(colnames(all_returns))){
  colnames(all_returns) <- lapply(colnames(all_returns), substr, start = 1, stop = 3)
}


# Start calculations after set of first min-variance portfolio
for(day in calc_period:length(all_returns)){
  
  # Dont calculate if there is no days enough   
  if(day + recalc_freq > length(index(all_returns))){
    print("aaa")
    break
  }
  
  # Take action only every given number of days (`recalc_freq` from config file)
  if(day %% recalc_freq == 0){
    date <- index(all_returns[day])
    
    # Get companies which are in index in given on portfolio recalculation
    companies_in_index <- CompaniesInIndex(date, share_data)
    
    # Get comapnies which enough quotations (quantity valid with `calc_peroid`)
    companies_valid_number_of_quotations <-
      CompaniesWithRightQuotations(companies_in_index, calc_period, date, all_returns)
 
    if(length(companies_in_index) != length(companies_valid_number_of_quotations)){
      print(date)
      print(companies_in_index )
      print(companies_valid_number_of_quotations)
    }
    # Get companies which are indicated by the portfolio strategy
    chosen_companies <-
      CompaniesStrategyChosen(comapnies_valid_number_of_quotations, all_returns)
    
    # Calculate #
  }
  
}








