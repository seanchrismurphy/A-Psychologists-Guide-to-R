### Learning new things

# 1. Take the example from the powerpoints. Read in the data file 'broken age data.csv'. 
#    Take a look at the data and see the problem with the age variable. Then go online
#    and figure out how to remove 'age' from the age variable. Convert age to numeric to 
#    numeric when you're done to make sure it worked.

# 2. 
# Let's suppose you want to make a scree plot in R to determine how many factors to extract from the NEO. Go
# to google, type in 'scree plots in R', and follow the Quick-R link. Go to the 'Determining the Number of
# Factors to Extract' section and follow the instructions there to make a screen plot from the 60 neo items
# we've been working with (in the Week 4 personality dataset). 

# Hint - you'll need to install the nFactors library first. Also, you'll need to remove missing data from
# the Neo to get this to work. Run the lines below before trying to use the code you find online:

personality <- read.csv('Personality data.csv', stringsAsFactors = TRUE)
colnames(personality) <- tolower(colnames(personality))
neo <- personality[, grep('neo', colnames(personality))]
neo <- na.omit(neo) 


# 3. Read in the 'us crime data.csv' data set from Week 3. Using a single grep() search,
#    find all instances of either Texas or Colorado. Then return all states that have an 'r', followed by any letter,
#    followed by a 'd'. Then return all states that end with a 'y'. How to do this? grep() actually has much more power
#    than we've used so far. It relies on regex, which stands for regular expressions - basically a little mini-language
#    designed just to search and deal with text. To learn regex, you can go complete the tutorial at the following site,
#    which should take about 30 minutes: https://regexone.com/
