### Installing and loading packages ###

# Let's quickly go through how to install and load a package. Packages are the things
# written by users to extend the functionality of R. They usually contain a number of extra functions
# that don't exist in the basic version of R. Often they also come with new example datasets to demonstrate
# those functions as well. 

# The first package we'll look at is tha haven package, which primarily includes functions to read SPSS files
# into R. 

# There are two steps that are required before you can use a package in R. The first step is that they must be
# installed. (i.e. downloaded from the internet and added to your installation of R). This only needs to
# happen once. The second step is that they must be loaded. This needs to happen every time you restart R.
# Until a package is installed and loaded, R effectively doesn't know that any functions it provides exist,
# and will give errors if you try to use them.

# Try running the following command, remembering that ? tells R to pull up the help documentation for a 
# function. You should see that no documentation is available, because we don't have haven loaded. 
?read_sav

# To install the haven package, we use the install.packages function. We have to use quotation marks around
# haven because it doesn't exist in R until we install it, so we'll giving R its name, rather than calling it
# as an object.
install.packages('haven')

# Note that if you're working on the lab machines here you might get an error telling you that you can't 
# write to the library, and asking if you'd like to start your own. Click yes, and continue. 

# Once a package is installed, we're still not ready to use it, because it hasn't been loaded. Notice that the
# following message doesn't change:
?read_sav

# Packages need to be loaded into R each time you restart Rstudio. This is so the environment doesn't get
# overloaded with extra functions. To 'activate' the package, we use require() to let R know that we require
# it.

require(haven)

# Now that we've got haven loaded, we can use the read_sav function, which will allow us to read SPPS files
# directly into R. Notice that the code below finally takes us to a help page:
?read_sav


# Exercise 1. Install and load the 'psych' package

