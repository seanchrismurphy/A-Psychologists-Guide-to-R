# You probably have haven installed, but if this doesn't work, you'll need
# to run install.packages('haven')
require(haven)

# You don't need the stringsAsFactors argument for read_sav, it's set by default
yourdata <- read_sav('your spss file here.sav')
yourdata <- as.data.frame(yourdata)


# The Smisc package includes a function to retrieve the SPPS labels for each variable in the dataset (these are
# printed by default when you looked at a specific variable)
getdesc(test)