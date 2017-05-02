### Subsetting with replacement ###

# Last week, we learned a lot about subsetting, using it to retrieve specific portions of objects, mostly
# so we could check certain values. But one of the main uses of subsetting is to change specific values, 
# by combining subsetting with assignment. 

example <- c(2, 6, 2, 6, 29, 6, 11, 1, 4, 6)

# As before, we can use logical subsetting to return only the elements of example that exceed 10.
example[example > 10]

# But we can also combine assignment with subsetting to replace these values

example[example > 10] <- 100

example

# One thing that is important to notice is that even though we assigned only one value (100) to a subset
# that contained two items, this still worked. That's because of a concept called vector recycling, which
# means that when we try to match up two vectors in R, it will repeat the shorter one until it matches
# the length of the longer one. That's why we can assign a single value and it will fill in all the values
# we want to replace. This also works with vectors longer than one, so long as they can be multiplied to 
# fill in the space we want to assign them to. 

example[example < 10]

example[example < 10] <- c(1, 2)

example

# Notice that when we had eight items that needed replacing and tried to replace them with a vector of 
# length 2, it still worked. The shorter vector was replicated until it could fill in the gaps. In most 
# cases, we will want to use either a single value or a vector of equal length when we are assigning
# to a subset, but it's good to be aware of this behavior. 


# Note that we can also use subsetting assignment to create new variables in a data frame, using
# essentially the same rules. 

# Let's use the data frame we read in in exercise 1. Notice that there is no variable named newvar - when
# we try to call it, we get NULL. 
colnames(week2)

week2$newvar

# However, we can create that variable with assignment.
week2$newvar <- TRUE
head(week2)
colnames(week2)

# Creating new variables follows essentially the same rules as assigning over subsets - in both cases, we're
# replacing a subset of an object with something new (in this case, the subset just happens to be empty to
# start with). 

### Exercises ### 

# Run this line first
example <- c(2, 3, -1, 5, 2, 2, -9, 8, 3, 4)

# 1. Change all the 2's in example to 3's. sum(example) should give 22 if you got it right. 

# Answer: (remember that inside the subset needs to be a complete logical test - so we have to 
# test whether example == 2)
example[example == 2] <- 3

# 2. Change the fourth element of example to zero. sum(example) should give 17 if you got it right. 

# Answer:
example[4] <- 0

# Note that we don't do this:
example[example[4]] <- 0
# Because that would be subsetting example by the result of example[4], which is 5. 

# 3. Replace all the negative elements of example with NA. 
#    sum(example, na.rm = TRUE) should give 27 if you got it right. 

# Answer:
example[example < 0] <- NA

# 4. Take a look at the age variable in week2 (week2$age). Some of the entries are clearly missing data, 
#    represented by "." - use logical subsetting to replace these values with NA 

# Answer:
week2$age[week2$age == '.'] <- NA
# Or
week2[week2$age == '.', 'age'] <- NA

# Notice that we can't use 'NA' - that gives us a character string. NA itself has a special meaning.

# 5. Create a new variable, warmav, which is the result of adding together the three warmth variables and
#    dividing by three (remember, you can add vectors together with +, just like single numbers)

# Answer:
week2$warmav <- (week2$warmth_1 + week2$warmth_2 + week2$warmth_3)/3

# Note that we can't use sum or mean in this answer, because they return only a single value that 
# summarizes their input. 

# 6. Create a new variable, is_alone, that is TRUE if pet is equal to None. 

week2$is_alone <- week2$pet == 'None'


# Final Note

# There is one special case when it comes to subsetting with replacement, and that's when we're 
# trying to replace NA values (perhaps filling them in with something). This is because we can't test NA
# using normal logical operations. For instance:

3 == 3
NA == NA

# If we wanted to replace all the 3s in a dataset, we could subset it with a logical test. But R can't tell 
# us whether something equals NA, because NA is an unknown value. When we try to test it, we are told that
# the answer is also NA (unknown). Instead, when we want to look for missing values, we use is.na(), a 
# function that tests whether a value is NA. 

is.na(NA)

missing_example <- c(10, 3, 5, NA, 1, 5, NA, 2)

missing_example[is.na(missing_example)]

# If we want to look for only the non-missing values, which is more common, then we use the "!" operator. 
# remember that this reverses the meaning of a logical test. So the following searches for non-missing 
# data. 

missing_example[!is.na(missing_example)]

# Exercise 7.
# Replace the missing data in missing_example with zeros.


# Answer:
missing_example[!is.na(missing_example)] <- 0