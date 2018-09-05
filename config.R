# Configuration file

# Set number of days for which mim portfolio should be calculated
calc_period <- 40

# Set weight recalculation frequency in days
recalc_freq <- 20

# Set dates of removal of some comapnies from the stock exchange
special_rebalancing_dates <- c("2015-09-24", "2018-04-19")
special_rebalancing_dates <- as.Date(special_rebalancing_dates)
