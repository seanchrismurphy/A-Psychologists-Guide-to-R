### Subsetting clarification and final refresher ###

# Subsetting is a complex issue and can be hard to get a firm grasp on. This exercise attempts to clarify
# what's happening when we use different types of subsetting, and hopefully make it clearer why some things
# work and others don't. Ultimately it's fine if you still end up using trial and error for a while to get
# your subsetting right - that's just part of the learning process. But this should help speed things up.

# There are three methods to subset a vector, though we usually focus on only two of them. 

alpha <- c(1, 2, 3, 4, 5)


# The first, simplest method is index subsetting. We can get the second element of alpha by using a 2 in 
# the subset index. 

alpha[2]

# The second method is logical subsetting. Using a logical vector of TRUE and FALSE values with the same length
# as alpha, we will select the values that correspond to locations that are TRUE.

alpha[c(FALSE, TRUE, FALSE, FALSE, FALSE)]


# The third method, which we haven't used with vectors, is to use names in subsetting. By default, 
# vectors don't have names (that is, a name for each element). But we can assign them. 
names(alpha) <- c('a', 'b', 'c', 'd', 'e')

alpha

# Now each element of alpha has a name, and we can use these names to subset the vector. This is the 
# third type of subsetting - we use it much more often when subsetting data frames. 

alpha['b']

# So, just to review, the three types of subsetting:

# Using indices
alpha[2]
# Using logical vectors
alpha[c(FALSE, TRUE, FALSE, FALSE, FALSE)]
# Using the names of the indices instead of the numbers. 
alpha['b']

## Now, a few extensions. We don't usually write out our logical vectors. Instead, we usually use a logical
## test that generates a vector of TRUE and FALSE values. For instance

logic_test <- (alpha == 2)
logic_test

# Notice that we now have a logic_test vector that is TRUE only when the vector alpha is equal to 2 (which happens
# to be at the second location). Now we can use the logic vector to subset alpha. 

alpha[logic_test]

# We can also write the logical test within the subsetting to save time. But remember that R will evaluate
# our logical test and turn it into a vector of TRUE and FALSE values. These are the only things that the
# vector "sees" when it decides what to subset, so the logical test has to be complete within itself. The following will work:

alpha[alpha == 2]

# But remember, R doesn't "know" that the logical test is being conducted as part of a subset, and so the following
# won't work - because it doesn't know that you're trying to subset the vector alpha where its values equal 2. 
alpha[ == 2]

# And of course, while the following code will work, it will be selecting the second element of alpha using
# index subsetting - not selecting alpha where it is equal to 2
alpha[2]

## The key principal to remember, whenever you're trying to do logical subsetting, is that you should be able to 
## take your logical test outside of the subsetting bars [ and ] and it should still return a valid series of
## TRUE and FALSE values. 

## Another way of thinking about this is that your subsetting code needs to be written so it would also work 
## as a two-step process where you save the results of your test in a variable and then use that variable to 
## do the actual subsetting (as I did with logic_test above). It can often be a good idea to write your code
## this way anyway, at first, since it will help you detect where your mistakes are.

### Recycling
## One thing you also need to remember with logical subsetting is the principle of recycling. That is, if
## you subset a target vector with a logical vector that is shorter than your target, the logical vector
## will be repeated until it matches the length of the target. So the following code gives us every
## element of alpha, because the TRUE value is recycled

alpha[TRUE]


### Data frames. 

# Data frames are more complex because they have two dimensions, but largely the three methods of subsetting
# still apply here. 

## Note - you'll need to select both lines of the following command before running it. 
example <- data.frame('zeta' = c(2, 3, 1, 4, 5), 'omega' = c('apple', 'orange', 'apple', 'orange', 'apple'),
                   'theta' = c(100, 200, 500, 122, 344),
                   stringsAsFactors = FALSE)


# Remember, we use commas when subsetting data.frames to separate row indices from column indices. Using
# the first form of subsetting (numeric index subsetting), we can get row 1, column 2 like this:

example[1, 2]

# And if we leave one index blank, that's code for 'select all of this'. So the following gives us row 1, 
# every column. 

example[1, ]

# The second type of subsetting we can look at with data frames is name subsetting. Data frames have 
# names for both their rows and columns. The column names are more familiar to us - they're variable names
# that have specific meanings. But the rows also have names - though the names are usually just the same
# as the row number. Still, we can use names to subset both the rows and the columns. The following 
# selects the row named '1' and the column named 'omega'.

example['1', 'omega']

# A useful shortcut to named subsetting with data.frames that we've explored before is the $ operator. The
# $ is just a fast way to select a single column using name subsetting, but it follows exactly the same
# general principles. The two lines of code below are exactly equivalent, the second is just faster to 
# write (but it can only select one column at a time). This can cause a lot of confusion because there 
# isn't an equivalent for rows and it seems to break the rules we've established. But just remember, the
# $ indicator is a simple shortcut for named column subsetting. 

example[, 'omega']
example$omega


## Now, we can also use logic to subset data frames. Let's start with explicit logical vectors like before,
## to make things clear. The following code selects the first and second rows of the data frame, and the
## first and third columns - essentially, it selects everywhere there is a TRUE value. 

example[c(TRUE, TRUE, FALSE, FALSE, FALSE), c(TRUE, FALSE, TRUE)]


# Now, again, we usually use logical subsetting with logical tests, rather than explicit vectors. This can 
# be confusing because there are a few concepts to juggle, so let's break it down. 

# Let's say we want to select only the rows of example where omega is equal to apple. Rather than try to do
# the subsetting all in one go, we can break it down one step at a time. First, let's just write out
# the logical test. We can use the $ operator as a shortcut. 

example$omega == 'apple'

# We can see that we now have a logical vector that is TRUE for each row in example where omega is equal to 
# 'apple'. Now we can put it into subsetting language. Remember, we're selecting rows here (rows where
# the participant responded 'apple' to whatever we asked in variable 'omega'). So the logical test goes
# before the comma. And voila, we have subset our data.frame. 

example[example$omega == 'apple', ]

# Remember, as before, when we're doing logical subsetting, R doesn't know that the logical tests we're 
# constructing are related to the object we're trying to subset. This is on purpose, since sometimes they're
# not related at all, and we wouldn't want it to make assumptions. But that means our logical tests have
# to be valid in isolation. Any logical test that wouldn't make sense on its own will either not work
# or give you nonsense output. For instance, the following code doesn't give anything meaningful, because
# 'apple' == TRUE is not meaningful on its own, and so it isn't meaningful within the subset. 

example['apple' == TRUE, ]


# Some of this confusion seems to stem from the fact that sometimes when we subset we need to tell R
# we're looking within example, and sometimes we don't. For instance, if we just want column omega:
example[, 'omega']

# But when we want to use omega as a test, we need to specify that it is part of example:
example[example$omega == 'apple', ]

## The key here is to recognize that we're using two different types of subsetting here. The first example
## uses name subsetting. When we use name subsetting, we're telling R to go to the index in a vector or 
## data.frame that has that name. Both of the following use name subsetting - column names in the first
## case and row names in the second case - and so R knows that it should be looking within the data frame, 
## we don't need to tell it explicitly. 
example[, 'omega']
example['1', ]

## But when we run a logical test to do logical subsetting, remember that the data frame or vector only 
## 'sees' the result of the logical test (a series of TRUE or FALSE values) and not what went into the test. 
## So in this case, we do need to tell R where to look for the vector we're testing. 

example[example$theta > 100, ]

# Note that the following code runs, but it doesn't work as intended. Here R simply tests whether the word 'theta'
# is greater than 100, and by R convention, words are bigger than numbers, so it returns a single TRUE value, 
# which is recycled and so returns the entire data.frame. Be careful of mistakes like this - make sure your
# logical tests make sense in their own right. 
example['theta' > 100, ]



### Sequential subsetting.

# Because R evaluates code step-by-step, we can subset multiple times in a row (or subset the result of a 
# subset, basically). 

# For instance, the following code gives us the 4th and 5th elements of alpha. 
alpha[alpha > 3]

# If we add another subset command, [2], we don't get the second element of alpha. We get the second 
# element of the already-reduced vector, alpha[alpha > 3].
alpha[alpha > 3][2]

# An easy way to think about this is that sequential subsetting is equivalent to saving the result of the 
# first subset, then applying the second subset to it (and so on). So:

alpha[alpha > 3][2]

# Is basically equivalent to the two lines:
alpha_sub <- alpha[alpha > 3]
alpha_sub[2]

# We can apply the same sequential subsetting to data frames, like so: 
example[, 'omega'][3]

# Notice that the first subsetting has the usual comma we use in data.frame subsetting, but the second
# subset [3], doesn't. This is because when we select a single row or column with subsetting, R simplifies
# it into a vector, by default. Having done that, any further subsetting only needs to work in a single
# dimension. Remember, the code above is equivalent to:

example_sub <- example[, 'omega']
example_sub[3]


# Sequential subsetting is something we'll often use in combination with the $ operator. For instance,
# the following code first selects only the column 'zeta', then selects only elements of that column
# that are greater than 2. 

example$zeta[example$zeta > 2]

# We could do that all within the course of a single normal subset command, of course, like below, 
# but the command above can feel simpler to write.
example[example$zeta > 2, 'zeta']


## What we'll much more commonly use this kind of sequential subsetting for is to select one column based
## on values in another column. For instance, select values in our DV, but only for participants who have 
## 'female' in the gender column. That kind of code looks like this:

example$zeta[example$theta > 150]

## And, of course, it could also be written like this:
example[example$theta > 150, 'zeta']


### Exercises

# Type cars into the console and you'll see the cars dataset. This is another inbuilt dataset in R
# with variales representing their speed and distance taken for those cars to stop.
head(cars)

# 1. Write out three different ways of subsetting that would select the 'speed' variable. Bonus points
#    if you can write four or more. 

# 2. Use both index and name subsetting to select the second row of the cars dataset

# 3. Use logical subsetting to select only those rows of cars where the speed is greater than 10. 
#    remember that you can build this command up in stages if you have trouble with it. 

# 4. Use whichever subsetting techniques you like to select values of the 'dist' variable only where the speed 
#    is greater than 15. 

# 5. Use subsetting to find the mean speed where dist is equal to 10. 