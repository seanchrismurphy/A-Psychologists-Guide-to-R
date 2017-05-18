### Week 2 revision exercises ###

## Installing packages ##

# 1. Install and load the 'lme4' package. Check that ?lmer takes you to a help page once you're done. 

## Reading in your data ##

# 2. Set you working directory to wherever you've copied the Week 3 folder. 

# Remember that you can run getwd() to find out where your current working directory is, and then modify that
# path and use setwd() to change your working directory.

# If you're on Mac that will look something like the following, noting that you need the '/' before Users.
setwd('/Users/Sean/Dropbox/Data')

# If you're on windows it will look something like the following, noting that you need to -not- have
# a '/' before C. 
setwd('C:/Users/Sean/Dropbox/Data')

# If you can't get setwd() to work, you can use the dropdown menu in RStudio (Session -> Set working directory
# -> choose directory).


# 3. Read in 'us crime data.csv' as a data.frame named 'crime'. Remember to set the 
#    stringsAsFactors argument to TRUE.


## Subsetting with replacement ## 

# 4. Replace all instances of 'New Jersey' in the 'state' variable with 'Jersey'

#    hint: you can use the table command - e.g. table(crime$state) to easily view categorical data like this, 
#    and check that you've done it right. 

# 5. Replace all values of total.population greater than a million (1000000) with NA. Remember not to use
#    quotation marks around NA, or it loses it's meaning as missing data. 

# 6. Create a new variable, total.crime, by adding violent.crime and burglary together (remember to use +, not
#    sum). 


## Factors ##

# 7. Create a new variable, state_fac, that is the result of converting crime$state to a factor

# 8. Use the levels() function to examine the levels of state_fac.

# 9. Use subsetting with levels() to check what the 35th level of state_fac is

# Run the code below to create the measurements factor
measurements <- factor(c(rep('low', 5), rep('medium', 5), rep('high', 5)))

# 10. Re-arrange the levels of measurements so that they go low -> medium -> high. Remember that you 
#     have to be careful how you do this - you may want to check the Factors exercise from last week to
#     make sure you're changing the order of levels and not the underlying data. Make sure the data still
#     looks the same once you're done. 

# 11. Collapse the 'medium' and 'low' levels together by changing both to 'subpar'.

## Lists ##

# Run this to create the 'mega' list: 
mega <- list('YU' = c(3, 2, 1), 'RA' = c('ami', 'tah', 'rho', 'zig'), 'EMU' = c(32.4, 12.0, .43))

# 12. Use 3 forms of subsetting to select the 2nd element of the mega list (hint: think names and indices)

# 13. Use sequential subsetting to select the second item in the 'EMU' list element. 

# 14. Change 'tah' to 'hat' in the mega list. Use subsetting with replacement, don't just re-create the list 
#      with slightly different code, that's cheating!

# 15. Create a new, fourth element to the mega list. Name it 'SOBA', and have it contain a vector with two
#     items - your first and last names.


## Programming in R ## 

# 16. Change the loop below so that it prints the numbers 5 through 20. 

for (i in 1:10) {
  print(paste('This number is:', i))
}

# 17. Add an 'if' statement to the loop below so that it only prints if the is number 7. 

for (i in 1:10) {
  print(paste('This number is:', i))
}

# 18. The following 'while' loop is broken - it will continue to print '1' forever if you run it (you'll
#     need to hit the stop sign symbol in the upper right of the console if you do). Add the correct
#     line of code to fix this problem (hint - i needs to change with each loop)

i <- 1
while (i < 8) {
  print(sqrt(i))
}

# Run the following code to create a vector of fruit and vegetables.
produce <- sample(c('Apple', 'Broccoli', 'Pear', 'Banana', 'Cabbage'), 20, replace = TRUE)

# 19. Write a loop that runs through the produce vector and prints 'This is a fruit' or 'This is a vegetable'
#     accordingly. Hint: You'll need to use i at some point to subset the produce vector, and you'll need
#     the paste() command. 


# Run the following code to create the 'miss' vector
miss <- c(2, 5, 1, NA, 0, NA, 1, NA, 3)

# 20. The code to subset a vector so that you remove the missing values looks like this:
miss[!is.na(miss)]

# Fill in the contents of the function remove.missing so that it takes a vector (like miss) as input and
# returns that same vector, but without any missing data. Once you're done, run remove.missing(miss) to 
# test that it works. 

remove.missing <- function(input) {
  # Your code here
  
  # Remember that you'll probably want to use the return() function to output something from your function.
}

# Now test that you've gotten it right.
remove.missing(miss)
