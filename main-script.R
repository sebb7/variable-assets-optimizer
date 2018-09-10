# Install necessary packages
# install.packages()o
# install.packages(qrmdata)

# Load libraries
library(fPortfolio)
library(PerformanceAnalytics) #portfolio min
library(xts)
library(quantmod)

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
load(file = "./R_data/sample_wig_30_r_data/stock_index_rr.Rda")

# Chnage names of colums for returns xts
for(i in 1:length(colnames(all_returns))){
  colnames(all_returns) <- lapply(colnames(all_returns), substr, start = 1, stop = 3)
}

# Consider valid dates for calculations
all_returns <- all_returns[paste(start_date, "/", end_date, sep = "")]

# Get vector with tickers of all companies
all_companies_tickers <- colnames(all_returns)


  
  
################ Build xts with portfolio weights according to given strategy
################
# Portfolio weights for rebalancing are carried out at the and of trading day
# Each weights calculated based on data from previous peroid are set for new peroid
# E.g. on "2018-03-16" weights are calculated for "2018-03-17" plus next (recalc_freq - 1)
# Start calculations after set of first min-variance portfolio
# Calculate weights only evry `recalc_freq`
  
# Create new xts for Markowitz weights for each perioid of `calc_peroid` 
df <- data.frame(matrix(ncol = ncol(all_returns), nrow = 1))
colnames(df) <- colnames(all_returns)
min_portfolio_weights <- xts(df, order.by = index(all_returns)[1])
min_portfolio_weights <- min_portfolio_weights[-1]

# Set indicator of past iterrations
curr_i <- 0

for(day in calc_period:length(all_returns)){
  
  # Get current date and date for next day
  date <- index(all_returns[day])
  next_day_date <- index(all_returns[day + 1])
  
  if(day + recalc_freq > length(index(all_returns))){
    # Dont calculate if there is no enough days 
  
    break
    
  } else if(curr_i %% recalc_freq == 0 | date %in% special_rebalancing_dates){
    # Take action only every given number of days (`recalc_freq` from config file)

    calculation_chunk <- all_returns[(day-calc_period+1):day]

    # Get companies which are in index at the next day
    companies_in_index_for_the_next_day <- CompaniesInIndex(date, share_data)
    
    # Get comapnies with enough quotations (quantity valid with `calc_peroid`)
    companies_valid_number_of_quotations <-
      CompaniesWithRightQuotations(companies_in_index_for_the_next_day, calculation_chunk)
    
    # Get companies which are indicated by the portfolio strategy
    chosen_companies_for_the_next_day <-
      CompaniesStrategyChosen(companies_valid_number_of_quotations, calculation_chunk, strategy)

    # Calculate min risk portfolio for given tickers
    min_portfolio_chunk <- calculation_chunk[,chosen_companies_for_the_next_day]
    min_risk_weights <- ComputeMinPortfolio(min_portfolio_chunk, Spec, Constraints)
    min_risk_weights <- t(as.data.frame(min_risk_weights))
    
    # Add other companies with 0 weights
    lacking_companies <- setdiff(all_companies_tickers, chosen_companies_for_the_next_day)
    lacking_comapnies_matrix <- matrix(ncol = length(lacking_companies))
    lacking_comapnies_matrix[1,] <- numeric(length(lacking_companies))
    lacking_comapnies_df <- data.frame(lacking_comapnies_matrix)
    colnames(lacking_comapnies_df) <- lacking_companies
    min_risk_weights_with_lacking <- cbind(min_risk_weights, lacking_comapnies_df)

    # Sort new xts in order to add it into table with weights (Use existing ordered varibale)
    min_risk_weights_with_lacking_ordered <- min_risk_weights_with_lacking[,all_companies_tickers]

    # Change weights to xts and set their date to next day
    current_weights <- xts(min_risk_weights_with_lacking_ordered,order.by = as.Date(next_day_date))
    
    # Add calculated weights as weights for the next day 
    min_portfolio_weights <- rbind(min_portfolio_weights, current_weights)
    
  } else if(day > calc_period) {
    # Add weights from current day to the next day with the next day date
    current_weights <- xts(coredata(min_portfolio_weights[date]), order.by = as.Date(next_day_date))
    min_portfolio_weights <- rbind(min_portfolio_weights, current_weights)
    companies_in_index <- CompaniesInIndex(date, share_data)
  }
  curr_i = curr_i + 1
}

# `min_portfolio_weights` indeicates dates in which comapnies shares were owned
# Adjust dates of `all_returns` to `min_portfolio_weights`  dates

valid_period_all_returns <- all_returns[index(min_portfolio_weights)]

################
################

# source("description_and_efficiency.R")
############### STRATEGY PORTFOLIO
# Calculate weighted mean for each day
Mean_rr <- numeric(nrow(valid_period_all_returns))

for(i in 1:nrow(valid_period_all_returns)){
  Mean_rr[i] <- weighted.mean(as.vector(valid_period_all_returns[i]), 
                              as.vector(min_portfolio_weights[i]),
                              na.rm = TRUE)
}
valid_period_all_returns$Mean_rr <- Mean_rr
Return.cumulative(valid_period_all_returns$Mean_rr)
#####################







############## INDEX
# Adjust `stock_index_rr`
stock_index_rr <- stock_index_rr[index(all_returns)]
colnames(stock_index_rr) <- c("WIG30TR")
valid_period_stock_index_rr <- stock_index_rr[index(min_portfolio_weights)]
Return.cumulative(valid_period_stock_index_rr)
# Efficiency 
#####################





############## NAIVE PORTFOLIO
all_returns_only_when_in_index<- ReturnsWhenInIndex(all_returns, share_data)
Mean_rr <- numeric(nrow(all_returns_only_when_in_index))


all_returns_only_when_in_index$Mean_rr <- rowMeans(all_returns_only_when_in_index,
                                                   na.rm = TRUE) 

# Efficiency 
Return.cumulative(all_returns_only_when_in_index$Mean_rr)
#####################


  
