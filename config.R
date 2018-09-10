# Configuration file

start_date <- as.Date("2013-09-23")
end_date <- as.Date("2018-06-15")

# Set number of days for which mim portfolio should be calculated
calc_period <- 60

# Set weight recalculation frequency in days
recalc_freq <- 20

# Set strategy
strategy <- 1

# Set dates of removal of some comapnies from the stock exchange
special_rebalancing_dates <- c("2015-09-24", "2018-01-16")
special_rebalancing_dates <- as.Date(special_rebalancing_dates)

# Set strategy