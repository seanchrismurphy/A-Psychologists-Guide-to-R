### Understanding Factors ###

# So far we've looked at numerical, character, and logical vectors - three of the four key types of 
# data within R. The final type of data we need to learn about are factors, since they'll be pretty
# essential to data analysis. 

# Let's take a look at the condition variable in week2
week2$condition

class(week2$condition)

# We can see that it's an integer - a special type of numeric without decimals. But let's imagine that this
# variable codes for four experimental conditions. Clearly we don't want any analyses we do to treat it in a
# linear fashion (assuming that each condition is 1 step greater than the previous condition). This is what
# would happen if we left the data as numerical. Rather, we want to treat it as categorical data. That's where
# factors come in.

condition_fac <- as.factor(week2$condition)

# Notice the change when we run condition_fac. It now prints levels for our condition variable. 
condition_fac
levels(condition_fac)

str(condition_fac)

# The results of str(condition_fac) deserve some unpacking. You see that it is a factor with 4 levels, ('0',
# '1', '2', '3'), and then you get a series of numbers (1's and 2's, and we'd see 3's and 4's if we looked
# further). Why two sets of numbers? Well, what's actually happening here is that the contents of the original
# vectors (the numbers 0 to 3) have been used as character labels, or levels. Under the surface, factors
# represent each level with a number (separate to the labels). These numbers always start at 1, and represent
# the factor levels in order.

# To make it a bit easier to see what we're talking about, let's change the levels to be more informative.
levels(condition_fac) <- c('low', 'medium', 'high', 'extreme')

condition_fac
str(condition_fac)

# As you can see, when we change the levels, the contents of the vector change to match. Why does that happen?
# Well, as I said before, under the surface of a factor, the contents are represented as numbers starting from
# 1 and increasing. Each number of tied to a level, in the order they appear in str(condition_fac). So 'low' is
# matched with 1, and 'medium' is matched with 2, etc. If we change the levels, the underlying data (1s and
# 2s etc) doesn't change, but R learns to display a different label in place of them. 

# Why is it useful to have labels matched to numbers? We've already looked at character variables, which can 
# hold the kind of strings that we use to code categorical information about participants. But if you think 
# about it, we can't use strings in things like regression or anova - they don't have any meaning on their
# own. Rather, we need our analysis to know what each string represents (i.e. a certain condition). R needs to
# know that all the participants with a similar label are in the same group. Using factors does this.

# R is pretty smart about factors. In almost any case, if you try to use a character variable in a
# statistical analysis, R will convert it to a factor for you and then run the analysis, assuming
# that every different string in that variable represents a different group or condition code. Each
# will be assigned its own level, and these levels will be used in analysis. R automatically dummy-codes
# factor variables in its analyses, which we'll make good use of later.

# There are a few other things to remember when working with factors. One is that factors have built-in
# protection, in that they will only accept values that match one of their levels. This can be helpful if we
# have specific categories and don't want to let any different data in. Check out the error message we get
# if we try to run the following code, noting that 'moderate' is not one of our levels. 
condition_fac[6] <- 'moderate'

condition_fac 

# We can add a level to a factor, even if no data at that level appears in the factor. The code below sets
# the levels to include the current levels, but also the new level, 'moderate'. 
levels(condition_fac) <- c(levels(condition_fac), 'moderate')

condition_fac
# And notice that the code below now runs appropriately
condition_fac[6] <- 'moderate'

# One case where factors are very useful is when we want to collapse conditions. If we set two different
# levels to have the same label, R will collapse them.
levels(condition_fac)

levels(condition_fac) <- c('lower', 'lower', 'higher', 'higher', 'higher')
condition_fac

# This can be useful if we want to reduce the number of demographic categories in our data, for instance. 
# You just have to make sure that you input the levels you want to use in the right order (i.e. they will
# replace the corresponding level in the data). 


### Exercises
# Run this first
example <- as.factor(rep(c('freezing', 'tepid', 'moderate', 'hot'), each = 10))

# 1. Use the levels function to check the levels in example
# 2. Add a new level, 'burning', to example
# 3. Run levels again to check that your new level has been added
# 4. Collapse the levels 'freezing' and 'tepid' into 'cold'. Make sure you're replacing the right levels!



# One thing to be aware of is converting factors to numeric data. R will use the hidden underlying numbers
# in the factor to do this, rather than converting the visible labels to numbers. Sometimes this will
# give us the results we want, but often it can change the data unpredictably. 

# Let's re-make the condition_fac vector from the source condition column. 
condition_fac <- as.factor(week2$condition)

condition_fac

# Now we can convert this vector to a numeric vector using the as.numeric function.
as.numeric(condition_fac)

# Notice that where we originally had 0, 1, 2, 3 we now have 1, 2, 3, 4? 

# Here's a more blatant example. Look what happens when we convert the age vector in week2 to numeric after
# first converting it to a factor:

week2$age
as.numeric(as.factor(week2$age))

# Not only do we not have the ages we'd be expecting, but the full stops have been converted to 1s! (unless 
# you already replaced the full stops with NA in the earlier exercise). This is because the factor treated
# these as the 'first' level (factors assign levels alphabetically). Things like this are why we usually set R
# to not turn string vectors into factors by default when reading in data.

# To get around this problem, we need to convert factors using as.character, which retrieves the factor
# labels, before we do anything else. 
as.character(condition_fac)

# The final thing to learn about factors, and probably one of the things you'll use most often, is how to 
# rearrange factor levels. As I mentioned before, when we run statistical analyses with factors, R 
# automatically uses them to do dummy-coding, using what is called contrast coding. This is equivalent to
# having e.g. three conditions represented by two variables, with one condition represented by all zeroes and
# the others represented by a 1 in the relevant column. Run the code below for an illustration:

dummy <- data.frame('condition' = c('A', 'A', 'A', 'B', 'B', 'B', 'C', 'C', 'C'),
'code1' = c(0, 0, 0, 1, 1, 1, 0, 0, 0), 'code2' = c(0, 0, 0, 0, 0, 0, 1, 1, 1))

dummy

# The important thing about this dummy-coding is that the first level of the factor forms the 'baseline' of
# our statistical model. If we're fitting a regression, for example with a two-level categorical predictor,
# then the results we get for the intercept will be the predicted value when the categorical predictor is at
# the first level. Then we'll get beta weights representing predicted differences from that condition for the
# other levels. To understand the simple effects of each level (if we have more than two) we'll need to
# rearrange the order of levels to change which variable is the baseline.

# I'll explain more about dummy-coding and factors when we deal with statistics, but it's important to know
# the difference between changing the order of factor levels, and changing their labels.

# Let's create a new example vector, this time of relationship statuses:
relationship <- c("Married", "Committed relationship", "Single", "Married", "Single", 
                  "Committed relationship", "Single", "Committed relationship", 
                  "Divorced", "Single", "Committed relationship", "Single", "Single", 
                  "Divorced", "Single", "Divorced", "Single", "Single", "Single", 
                  "Married")

# Check that levels doesn't work on a character vector
relationship_fac <- as.factor(relationship)

# Let's take a look at the levels. Notice that they've been chosen by alphabetical order
levels(relationship_fac)

# Imagine we want to change the order of factor levels to that it goes Single -> Divorced -> Committed
# relationship -> Married

# Intuitively, you might try the following code: 
levels(relationship_fac) <- c('Single', 'Committed relationship', 'Divorced', 'Married')

relationship_fac
relationship

# Look carefully at the relationship_fac variable. The levels are in the order we want, but doesn't the data 
# look different compared to relationship? Changing the levels in this manner swaps the labels around, which
# changes the meaning of the underlying values. That isn't something we want to do with real data (we don't
# want to just recode all of our Married participants as Divorced). Instead, we need a slightly different
# command. First, let's re-make the relationship_fac variable:
relationship_fac <- as.factor(relationship)

# And this is the command to change the order of factor levels without changing the data itself. 
relationship_fac <- factor(relationship_fac, levels = c('Single', 'Committed relationship', 'Divorced', 'Married'))

# Notice that the levels are now nicely ordered, but the data hasn't changed. This is because we've constructed
# the factor and told R the order we want the levels to be in. In contrast, when we use assignment like we did
# before, we're just overwriting the existing levels with new ones. 
relationship_fac


# So when we want to change -the data- (like collapsing conditions) we use code like this:
levels(relationship_fac) <- c('newlevel1', 'newlevel1', 'newlevel2', 'newlevel2')

# And when we want to change the -order of the levels- we use code like this:
relationship_fac <- factor(relationship_fac, levels = c('Single', 'Committed relationship', 'Divorced', 'Married'))


## Exercises 

# Run this code first 

conditions <- sample(c('In-Group', 'Control', 'Out-Group'), 30, replace = TRUE)
conditions <- as.factor(conditions)

# 1. Try using mean() or sum() on conditions. Does it make sense that it doesn't work? 

# 2. When you run logical tests with "==" on conditions, it it comparing to the factor levels or the numbers they
#    represent?

# 3. Use the factor command to reorder conditions variable so that the levels are ordered 'Out-Group', 'Control', 
#    'In-Group'. Make sure that you're not changing the underlying data!


