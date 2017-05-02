### Understanding Lists ###

# I mentioned when I was describing them that lists are the final and most flexible data type within R. 
# So far, we've looked at vectors, matrices, and data frames. Each of these had some level of constraints
# - vectors are single columns and only store one type of data. Matrices are two-dimensional, but still
# only store one type of data. Data frames are two dimensional and can store any type of data, but they have 
# to be made up of columns of equal length. 

# Lists however, have no such constraints. Lists are a little bit like vectors, in that they're one
# dimensional. However, each element of a list can contain literally anything. It can be a single piece of 
# data of any type, or a vector of such data. But list elements can be matrices, data.frames, or even
# more lists! 

# The flexibility of lists means that we'll use them a lot when programming, because they can hold the results
# of all kinds of different operations, even when we don't know in advance what form they'll take!

# Let's take a look at how lists work in practice. The main way to create a list is using the list function.

ourlist <- list('alpha', 'beta', 2, TRUE)
class(ourlist)
ourlist

# Notice how ourlist prints differently to what we've seen before. Lists have their own form of indexing,
# which is a little complicated. We can subset a list like we would a vector, picking out only certain 
# elements. 

ourlist[1:3]

# However, if we want to drill down and examine one of the elements, we can use double brackets. This takes
# us a level deeper into the list. One way of thinking about it is that instead of looking at a bunch of
# containers, we're now looking at the contents of the third container.

ourlist[[3]]

# Notice that the class argument now tells us that what we're looking at is numeric, not a list. 
class(ourlist[[3]])

# When we use normal subsetting, even when we ask for just one item, we still get a list - it's just a
# list that only has one thing in it. When we use the double square brackets, we instead get the contents
# of that one element. 
ourlist[3]

# Now, if we try to use this double square bracket subsetting with a range of numbers, we get an error. We
# can't simultaneously look inside multiple containers at once.
ourlist[[1:3]]

# If we want to, we can give the elements of our list names to make it easier to call them:
names(ourlist) <- c('a', 'b', 'c', 'd')

ourlist

# We can then use the $ (just as with data frames) to retrieve specific elements of ourlist. Here, 
# ourlist$c is equivalent to ourlist[[3]]

ourlist$c

# The reason we can use the same symbols with lists and data frames is that, under the surface, data frames
# are just very specialized lists - each variable is a list element that is constrained to be the right
# length. It's not super important to remember, but it may help you make sense of how things work. 

# Another thing that lists and data frames have in common is that we can create a new element by assigning
# something to an index that doesn't exist yet. 

ourlist$e <- week2

ourlist

# Now the fifth list element contains a copy of our week2 data frame. If we drill down with the double square 
# brackets (or $e), we can see this data frame. And we can use functions on it just like a normal data frame.

ourlist[[5]]
ourlist$e

head(ourlist[[5]])

colnames(ourlist[[5]])

# We can even subset the data frame as normal, putting the data frame subsetting after the list subsetting.
# This can get a little brain burning, but just remember that for almost all intents and purposes, typing 
# ourlist[[5]] is the same thing as typing week2 at this point. 

ourlist[[5]][, 'gender']
ourlist[[5]]$gender

# Let's take a step back to something simpler. Let's replace the first element of ourlist with a vector.
ourlist[[1]] <- c(1, 2, 3)

# If we want to pull out specific elements of that vector, we first need to use subsetting to make sure 
# we're looking at the contents of the first list element
ourlist[[1]]

# And then we can use vector subsetting normally to pull out, say, the third element of the vector
ourlist[[1]][3]

# Alternatively
ourlist$a[3]

rm(ourlist)

### Exercises ###

# Run the following code first:
examplelist <- list(c(2, 1, -3, 4), c('alpha', 'gamma', 'beta'), 'Fred')

# 1. Give names to the three elements of examplelist (you can choose your own names)

# 2. Find the mean of the first element of examplelist
#    Tip: You'll need to make sure you're subsetting to get the contents of first element, not
#    a list that includes it (see lines 38-41)

# 3. Change the 'gamma' in the second list element to 'omega'

# 4. Replace 'Fred' with the vector (1, 2, 3, 1, 2, 3, 1, 2, 3)
