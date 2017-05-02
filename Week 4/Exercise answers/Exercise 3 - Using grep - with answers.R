### Using grep() to select related variables 

# Here we're going to start using some basic pattern matching with the grep() function in order to 
# extract sets of variables with similar names, which we'll often want to do to test reliabilities, 
# form scales, run factor analyses, and more. 

# First, let's explore the basics of the grep function. grep() is a search function, and works a lot
# like google search or the 'Find' button in Word or Excel. It take a search pattern as its first
# argument, and a vector that needs searching as its second argument. It then returns a list of indices
# in the target vector that match the search pattern. For instance, let's return to a simple example
# we used in previous weeks. 

pets <- c('cat', 'dog', 'cat', 'dog', 'cat', 'cat', 'dog')

# If we wanted to search for all the 'cat' entries in the pets vector, the syntax would look like this
grep(pattern = 'cat', x = pets)

# Notice that we don't get the word 'cat' returned. Instead, we get the numbers 1, 3, 5, and 6. These are
# the locations of 'cat' entries in pets. If we want to return those entries, we can combine grep with 
# index subsetting, like so:

indices <- grep(pattern = 'cat', x = pets)

pets[indices]


# And obviously we can combine that into a single line, and drop the argument labels since we're using 
# them in the standard order:
pets[grep('cat', pets)]

# We've seen that grep() will return indices for matches by default. We can also have it directly return
# the results of those matches, by adding the argument - value = TRUE:

grep('cat', pets, value = TRUE)

# Now in that simple example, this wasn't of much use, because what we're retrieving is exactly the same
# thing that we searched for. But grep() is pretty flexible. Our search pattern will match any entries that
# contain it, even if the pattern is part of a longer string. For example:

vector <- c('The cat in the hat', 'the quick brown fox', 'jumped over the lazy dog', 'concatenation', 
            'Cats')

# Notice that we return the entirity of each element that contains a match. If we happen to have more 
# extensive text data, this can be useful to view, for example, specific participant responses that mention
# a topic of interest. Note also that 'Cats' is not matched, because, just like everything else in R, grep()
# is case sensitive. 
grep('cat', vector, value = TRUE)

# Now, grep() is much more powerful than this basic use we're making of it. While it can be used to only match
# exact phrases, as we've done here, it can also be used to do very advanced matching with wild characters, 
# repeated characters, and much more. We'll talk a bit more about that next week. For now, we'll just make
# use of the basic functionality. 


### Using grep() with colnames() to subset data frames

# Often when we receive our raw data, we will have variables that are grouped together in some way. These
# might be responses to individual items in a scale, or responses to individual stimulus in a task. Most of 
# the time, if we're lucky, these variables will share some kind of naming scheme. For instance, if we had
# data from participants responding to 60 items that all tap the NEO personality inventory, hopefully they
# would all have sensible variable names like NEO_1, NEO_2, etc. grep() allows us to select all the variables
# that share a specific part of their name. Combining this with column subsetting allows us to essentially
# select from our data frame only the data from specific scales or tasks. This is essential for calculating
# scale means and reliabilities, as well as performing factor analysis, all of which we'll be learning 
# how to do today. 


# Read in the data below, and we'll start to test out this funtionality. 
personality <- read.csv('Personality data.csv', 
         stringsAsFactors = FALSE)

# ncol(), similar to nrow(), tells us how many columns a dataset has (which can also be seen in the 
# environment window). We have 180 variables in this dataset - clearly it would be time consuming and 
# unwieldy to manually select all of the variables we're interested in, given that
# all of these variables are items that need to be turned into scales. This is where grep() comes in handy. 
ncol(personality)

# First, let's examine the column names to get a sense of what is in our data. 
colnames(personality)

# You should be able to see 60 NEO items, along with a number of other scales, identifiable by their 
# similar variable names. To keep things simple, we can turn all the column names into lowercase. Run
# both lines below, and you should see the column names now listed in al lowercase. 

colnames(personality) <- tolower(colnames(personality))

colnames(personality)

# If we want to select the variables that make up a scale, we can use grep() to identify specific column 
# indices that we need for subsetting, rather than identify them by hand. Let's try extracting the neo items:

grep('neo', colnames(personality))

# The result of the above command is a vector of numbers from 1 to 60. We know this is correct because the 
# first 60 items of the data frame are the NEO items. If we add the value = TRUE argument, we'll get the 
# names of all the neo scale items. 

grep('neo', colnames(personality), value = TRUE)

# We can see that each variable name also contains the name of the specific personality dimension being 
# measured (neurotic, extravert, agreeable, conscientious, or open). We can make our search more specific
# by extending the search pattern. Note that the way we're using grep(), we need things to match exactly. 
# so we'll need to add an underscore after neo and before the name of the personality dimension we want
# to match the way the variable names are set up. 

grep('neo_extravert', colnames(personality), value = TRUE)

# As you can see, we've extracted all of the extraversion items and nothing else. Often, it's useful to 
# add the value = TRUE argument while you're setting up your search, so you can see what you're actually 
# retrieving. Then, when you want to use the results of your search for subsetting, you may want to remove
# it so you get numbers instead (though sometimes both work, as we'll see). 


# Alright, so we've set up our search. Now we can use it with subsetting to select only the columns we 
# want. Remember that the result of this search is just a series of numbers representing specific columns. 
# so if we use it after the comma in a subset, we will retrieve only those columns of data. 

extraversion <- grep('neo_extravert', colnames(personality))

# For illustration purposes, we'll create a new data frame from the results of our subset. Using ncol
# shows that this data frame only has 12 variables (which sounds right). And we can use the head() command
# to check that, yes, we've extracted only data on extraversion. 
extraversion_scale <- personality[, extraversion]

ncol(extraversion_scale)
head(extraversion_scale)


# But of course, because R can handle nested functions, we don't really need to save the results of our
# search, or to create a new data.frame. Instead, we can do it all in one line, as you can see below:

head(personality[, grep('neo_extravert', colnames(personality))])


# Now, you might remember that when we subset data frames, we can use name indexing instead of number indexing. 
# That is, we can subset columns by either their names or their position numbers. Above, we used their position
# numbers, because grep() returns these by default. But since names work as well, we can perform the same subsetting
# with the value = TRUE argument, which returns the results of a search (the results in this case being
# column names). 

head(personality[, grep('neo_extravert', colnames(personality), value = TRUE)])

# While the two approaches are usually interchangable, sometimes one or the other will be preferable, because
# we can combine grep() with the c() function we learned on day 1 to select a mixture of variables. 

# For instance, let's say that we wanted to create a trimmed-down data frame for easy viewing. In the reduced 
# data frame, we want all the extraversion items, but we also want to keep the 'target.language.esl' variable.
# If we use grep() with value = TRUE, we will get a vector of column names. We can then use c() to add 
# 'target.language.esl' to that vector. Take a look:

c('target.language.esl', grep('neo_extravert', colnames(personality), value = TRUE))

# And now we can use that code to do subsetting:
head(personality[, c('target.language.esl', grep('neo_extravert', colnames(personality), value = TRUE))])


# One thing you'll need to be increasingly careful of when running these nested commands is to keep track of 
# where your ( ) brackets are. It can be easy to lose track when multiple
# functions are used together, especially when those functions are themselves nested within a subsetting
# command. In programming, there is often a trade-off between clarity and efficiency. The most efficient
# way to perform a certain task might be to write it in a single line, nesting all of the functions so that
# they each run in turn. But doing so makes it harder for you and others to read your code, and also makes
# it more likely that you'll make an error. Especially while you're learning, it's always an option to write
# things out over multiple lines so that you can be sure things are working properly. For instance, below
# is a different way to write out the single line above - it takes 4 lines, with each line implementing
# only one function or subset. But it's a lot easier to see what's happening. 

index <- grep('neo_extravert', colnames(personality), value = TRUE)
index <- c('target.language.esl', index)
sub <- personality[, index]
head(sub)

# Finally, note that it's possible to use c() to chain together several different search results. For instance, 
# imagine that you wanted to extract both the extraversion and openness data from personality. You could
# use the following code: 

c(grep('neo_extravert', colnames(personality)), grep('neo_open', colnames(personality)))

head(personality[, c(grep('neo_extravert', colnames(personality)), grep('neo_open', colnames(personality)))])

### Exercises: 

# 1. Create a data frame that contains only the items from the narcissistic personality inventory in 
#    the personality data frame (these items start with npi)
npi_dat <- personality[, grep('npi', colnames(personality), value = TRUE)]

# 2. Create a data frame that contains only the items from the perspective taking (pt) subscale of the 
#    interpersonality reactivity index (iri)
iri_pt <- personality[, grep('iri_pt', colnames(personality), value = TRUE)]

# 3. Create a data frame that contains both the neo_conscientious items, and the emexp_impulse items
personality[, c(grep('neo_con', colnames(personality), value = TRUE),
                grep('emexp_impulse', colnames(personality), value = TRUE))]

# 4. Fix the following (broken) code. Remember, when you encounter errors, break things down into their
#    component pieces and make sure that they still work. 

### Broken version
head(personality[, grep('neo_extravert', colnames(personality, value = TRUE))])

### Fixed version
head(personality[, grep('neo_extravert', colnames(personality), value = TRUE)])

# 5. Fix the following (broken) code. 

### Broken version
head(personality[, c(grep('neo_agreeable'), grep('genknow'), colnames(personality))])

### Fixed version
head(personality[, c(grep('neo_agreeable', colnames(personality)), grep('genknow', colnames(personality)))])

# 6. Fix the following (broken) code.

### Broken version
head(personality[, grep('neo_extravert', personality, value = TRUE)])

### Fixed version
head(personality[, grep('neo_extravert', colnames(personality), value = TRUE)])


