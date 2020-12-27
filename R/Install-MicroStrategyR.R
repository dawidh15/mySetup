# Run in RGUI not in RStudio

# MicroStrategyR is a package to customize Business Analytics
# inside MicroStrategy. At 2020-10-29, MicroStrategy is not available in CRAN
# To use it, install the Microsoft Open R Distribution
# This comes packaged with 'checkpoint', which is a package to
# choose specific dates for the CRAN repo. So old or removed packages can 
# still be found there.


library("checkpoint")
checkpoint("2018-10-01")
install.packages(pkgs="MicroStrategyR", dependencies=TRUE)
library(MicroStrategyR)# Prompt to install gtk+

# Run deployR() to check any custom R Script that should run on MicroStrategy
#
