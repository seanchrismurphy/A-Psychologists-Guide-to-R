### Solving problem 2

require(tidyr); require(stringr); require(plyr); require(dplyr)

# Now there are four functions to solve problem two, realistically. Separate, unite, str_replace, str_extract
# (though paste might go in there as well). Let's walk through them. 

# We'll start with the string functions - str_replace and str_extract. 

messy <- read.csv('problem 2.csv', stringsAsFactors = FALSE)

head(messy)

# So in this small example dataset, we have a condition column. But really, it contains two variables. One 
# condition is high or low, the other is fast or slow. We want to separate them out into their components, giving
# them their own columns. 

messy$condition

# While this dataset is small enough to eyeball, it always helps to use table in this kind of data, as it can reveal
# cases where a condition value was entered wrong (since there will usually be only a handful of such cases, compared
# to the total number of conditions)
table(messy$condition)

# Table reveals an error that might not have been apparent to the naked eye - one of our conditions is coded wrong - 
# it has a lo instead of low. For this kind of problem, we have str_replace.

# str_replace is basically a 'find and replace' function with a lot of power. Remember that it takes arguments
# of the form str_replace(string, pattern, replacement). It searches string, finds pattern, and substitutes it 
# with replacement.

# For instance, take a look at the result of this command. We're not using the power of regular expressions here, 
# just searching for the exact phrase lo_. 
str_replace(messy$condition, 'lo_', 'low_')

# We need the _, otherwise we'd match every lo in the model, of which there
# are many! Try it:
str_replace(messy$condition, 'lo', 'low')

# We can be more complex, specifying that we want lo to be at the start of the string (to exclude potential other
# matches). Though we don't really need that kind of power here.
str_replace(messy$condition, '^lo_', 'low_')


# So let's fix our condition variable for good. 
messy$condition <- str_replace(messy$condition, '^lo_', 'low_')

table(messy$condition)


# Now, what if we want to separate out the condition variable into its components? We could use str_extract. Remember,
# it takes arguments of the form str_extract(string, pattern), and pulls the first match to the pattern out.

# Here we can use the | (OR) operator, which works in regex. We tell str_extract to pull any instances of either 
# high or low our of the condition string. Using that, we could create a 'high_low" variable, and similarly, we
# could create a 'fast_slow'
str_extract(messy$condition, 'high|low')

# We can also be fancy and use the ^ (start of string) and $ (end of string) to do the same thing. 
str_extract(messy$condition, '^[a-z]*')
str_extract(messy$condition, '[a-z]*$')


# But in this case, our easiest method would be to use separate. separate takes a column (like condition) and splits
# it on a character or position of our choice, into new columns that we specify with the 'into' command. 

# separate takes as its first argument the entire dataframe, and returns a new data.frame. It's second argument
# specifies which column, within that data frame, to separate.

separate(messy, condition, into = c('high_low', 'fast_slow'), sep = '_')

# So the separate command is taking the condition variable, and breaking it into new columns - high_low and fast_slow,
# breaking up condition at '_'. If there was more than one '_', it would break it into three columns (although we
# would need to specify three column names). 

# separate can also split a column up at certain positions, if we know exactly where we want to split. In this case,
# it won't work, because high is longer than low, so different values will have different split points. But we can
# try it for illustrative purposes:

# Here we specify that we want to split on the fourth character - which means the first four characters will go into
# the first column, and the rest will go into the second model. So we'll need one less 'separator' than we want 
# columns.
separate(messy, condition, into = c('high_low', 'fast_slow'), sep = 4)


# Let's create the separated data frame.
messy_sep <- separate(messy, condition, into = c('high_low', 'fast_slow'), sep = '_')


# The final tidy data function we'll look at here is unite, the opposite of separate. We use this if we want to put
# variables from multiple columns back into a single column. 

# With unite, our first argument is again, a data frame. The second argument is the column we want to create. The
# third argument is the columns we want to unite. By default, this will use a '_' to separate the values from each
# column - take a look
messy_union <- unite(messy_sep, condition, c(high_low, fast_slow))

head(messy_union)

# We can alter this behavior with the 'sep' argument. If we set it to an empty string, there will be no space between
# variables when we put them back together.

messy_union <- unite(messy_sep, condition, c(high_low, fast_slow), sep = '')

head(messy_union)
