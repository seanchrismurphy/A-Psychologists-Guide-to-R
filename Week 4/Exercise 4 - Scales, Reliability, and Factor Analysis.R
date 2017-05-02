### Calculating scales, scale reliabilities, and exploratory factor analysis

# Now we get to the reason we spent some time learning how to select specific scales in our data frames in R.
# It's a pretty common task in most branches of psychology that we'll want to calculate scales (or, alternatives, 
# the means of responses to a group of stimulus). It's also (at least in my experience) fairly common that we'll
# want to calculate scale reliabilities, and potentially run some factor analyses to see if some items we 
# came up with can be broken into smaller clusters. 

# All of these tasks in R work on the same general principle. The functions involved take, as their input, a
# data frame, and assume that the data frame contains the information we're interested in (i.e. the items we
# want to average, the scale we want to calculate alpha for). Because of this, we need to make sure, prior to
# using the functions, that we have selected a subset of our data that contains only what we're interested in.
# To do so, we extract only those columns from our dataset that contain those variables, usually using grep()
# and subsetting. Then we feed these subsets of data into one of the functions that handle scale calculation,
# reliabilities, and factor analysis, and R does the rest.

### Scale creation in R

# Let's start with scale creation. Before we begin, I'll get you to read the personality data set in
# fresh, in case your version has been changed at all in our previous exercises: 

personality <- read.csv('Personality data.csv', 
                        stringsAsFactors = FALSE)
colnames(personality) <- tolower(colnames(personality))


# Alright. Calculating scales in R is pretty simple, and relies on the rowMeans() function. rowMeans does
# pretty much what it says - it takes the mean of all the entries each row in a dataset. Since a row of data
# is usually from a single participant, that means rowMeans() usually takes the scores from each participant
# on all the variables in a dataset and gives us the mean. Now, when used on a complete dataset, this is
# pretty useless - the mean for each participant across all the different variables in a dataset is almost
# always meaningless. That's why we use subsetting to select only the relevant part of the dataset, so that
# rowMeans() is fed only the data that is of interest to us. 

# One final thing. You may have seen that when we looked at the mean() function, we set the na.rm argument
# to TRUE, telling it to ignore NA values and compute the mean anyway. We'll need to do the same thing with
# rowMeans, otherwise if a participant has a single missing value, their scale score will end up as NA. 

# Alright. Let's see how this looks in practice. 

extraversion <- personality[, grep('extravert', colnames(personality))]

extraversion$scale <- rowMeans(extraversion, na.rm = TRUE)

head(extraversion)

# You should see that the new extraversion data.frame we've created has a 'scale' variable representing the
# mean extraversion score. Of course, we can create that scale in our main data frame with a single line
# of code as below: 

personality$extraversion_scale <- rowMeans(personality[, grep('extravert', colnames(personality))], na.rm = TRUE)

head(personality)

# Something to be aware of (this has tripped me up before) is that you want to be careful when naming your 
# scale variables so that they wouldn't be retrieved by the same search you used to create them. For instance, 
# let's say I had named this new variable extravert_scale. Then my original grep search for 'extravert' would
# bring up the scale. That means if I run reliabilities after I calculate the scale, I might accidentally
# capture my scale variable, skewing my reliability higher. Or, if I accidentally ran the code to create
# the scale twice, the second time I would average in the first scale variable I calculated, messing things
# up. When we learn more about grep, there'll be more advanced ways to make sure your searches only select
# the individual items and not the scale variable. But for now, you can just make sure the names a slightly
# different. 

### Calculating scale reliabilities

# Alright, let's move on to calculate the reliabilities of scales (which we'd usually do before we create the
# scale means, of course). For this step, and the next, we'll need the psych package - it contains a number
# of functions that help us deal with scales - something that isn't of huge concern to everyone who uses
# R (so they're not built in to the basic functionality) but is, of course, something psychologists use a lot, 
# which is why someone built a package for it. 

# If you haven't already installed the psych package, you'll need to run the install.packages line below:
# install.packages('psych')

# Otherwise, just run require(psych)
require(psych)

# For this step, we'll use the alpha() function to calculate Cronbach's Alpha (a standard measure of scale
# reliability that ranges from 0 to 1). The alpha() function works similarly to the rowMeans() function, in that
# it also requires, as input, a dataset containing only the variables of interest. 

# alpha() comes with one special argument we'll make use of, which is check.keys. When set to TRUE, this
# automatically checks if each variable correlates negatively with the overall scale, and if it does, it
# reverses it (for the purpose of the alpha calculation only) and lets you know. Which can be very helpful for
# keeping track of which variables are reverse-coded. For this command, we don't need to set na.rm = TRUE, 
# since it's the case by default (this is due to the preference of the package writer and not any specific
# rule).


# Let's start simple, and make an openness dataset to work on: 

open <- personality[, grep('open', colnames(personality))]

# And now we can check the alpha level. 
alpha(open, check.keys = TRUE)

# The key output from alpha appears at the top, under 'Reliability analysis'. We see the raw_alpha is .77, 
# and the std.alpha is .76. These are slightly different measures, and usually you'll want the raw_alpha
# unless you plan to standardize your items before you average them. 

# Under this, we get 'Reliability if an item is dropped', which tells us, for each 
# item, what the reliability would be if we kept all other items, but removed that one. Generally speaking, 
# if the alpha would be higher after dropping an item, it's probably not a good item and might need to be 
# removed from the scale. After that we have various frequencies and descriptives for the items. 


# Now, just so you get to see what when you encounter reverse-scored variables, try calculating alpha
# on the agreeableness subscale. You'll see that it tells us several items are reverse-scored. 
agreeable <- personality[, grep('agree', colnames(personality))]

alpha(agreeable, check.keys = TRUE)

# You can see which ones as they have a '-' after the variable name in the item statistics. The alpha reported
# is after the variables have been properly reversed. If we leave out the check.keys argument, the alpha will
# be artificially deflated, and we'll get a warning telling us we probably have reverse-scored variables. 
# All in all, a very helpful little function. 

alpha(agreeable)


# The psych package also includes a helpful reverse coding function, reverse.code(). It takes a vector of 
# keys, where -1 indicates the item in that position should be reversed, and 1 indicates that it shouldn't. 
# It also takes mini and maxi arguments to specify the scale endpoints. Using this, it returns a data frame
# containing the reverse-coded scale. As with all the other functions we're looking at here, we want to feed
# in only the variables of interest - we could do this using subsetting, but since we already have the 
# agreeable data frame ready to go, we use that instead. 
agreeable_rev <- reverse.code(keys = c(-1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, 1), items = agreeable, mini = 1, maxi = 7)

# And voila - we check the reliability of the agreeable_rev data frame, and don't get any warnings. While functions
# from the psych package (like alpha, and fa(), which we'll use to do factor analysis) will reverse-code the
# scale items automatically as part of the analysis, rowMeans() doesn't do this. So you should always make sure
# that your items are coded in the right direction (possibly using alpha() to check this) before using rowMeans().
alpha(agreeable_rev)


### Exploratory factor analysis

# The final thing we'll look at in this section is exploratory factor analysis. While I won't go into the
# theory behind factor analysis too much here, the general idea is that we're looking for clusters of 
# variables that seem to relate to one another. The goal is to take, say, 30 variables and break them down
# into 3 scales of 10 items that each measure a single construct (since working with 30 variables is a lot
# more difficult than working with 3, and for reliability of measurement reasons, among other things). 

# There are actually several functions in R that will do factor analysis - in the basic package there's
# factanal(). However, in the psych package there's fa(), which offers more functionality and prints
# the factor loadings in a nicer way (in my opinion, at least). You can see a full discussion of the 
# options for fa() in the How-to PDF in the Week 4 folder. 

# Like alpha(), fa() automatically handles reverse coding and missing data. Also like alpha(), it takes
# as input a data frame, and will perform factor analysis using that entire data frame as input. So we'll 
# once again subset our data to make sure we're feeding it only what we want it to look at. 

# Let's pull out only the items of the neo inventory. 
neo <- personality[, grep('neo', colnames(personality))]

# Now, fa(), being a factor analysis function, has quite a few potential arguments. The first argument
# is where we input our data. The second argument tells the function how many factors to extract, which 
# we must decide ourselves (we'll often do something like a scree plot and potentially try several solutions
# to see what number of factors looks right). Then we have rotate, which specifies the rotation, and fm, 
# which specifies the factoring method that drives the math behind the factor analysis. You can type
# ?fa to see more arguments and read the options for the currently specified arguments. Let's run the 
# line below (we assume 5 factors as this is theoretically consistent with the NEO):

neo_fact <- fa(neo, 5, rotate = 'varimax', fm = 'minres')

# As you will no doubt be used to by now, running the factor analysis does not, itself, print any output, 
# at least not when we assign the results to a variable (since R assumes we'll want to look at the output
# later on our own terms). To look at the results of fa(), we can try using our familiar summary() function. 
# However, as you'll see, there's not a lot of output here. Essentially there are just a few fit statistics 
# that test the suitability of the model. 
summary(neo_fact)

# For fa(), we'll need to use print() to look at the full output. In R, print() behaves differently depending
# on what kind of object you use it on. When you print an object containing the results of a factor 
# analysis, you'll get familiar-looking, relatively nicely formatted factor analysis output. There are also
# special arguments in print when used with fa(). cut tells R how big loadings have to be before it shows
# them. digits specifies the number of digits after the decimal point that should be displayed. If sort
# is set to true, then the items are sorted according to their factor loadings. The command below is set
# to a good default (in my opinion). Try running it, and look at the output. 
print(neo_fact, cut = .3, digits = 2, sort = TRUE)

# You can compare this output to running the print command without any arguments, which in my opinion is 
# fairly hard to read. But the choice is yours, and obviously you can set the arguments up however you 
# like. 
print(neo_fact)

# Let's briefly interpret the output (re-run the print command with the extra arguments first). We have a
# matrix of standardized factor loadings, which shows us that, as expected, neo_neurotic and 
# neo_conscientiousness items all load together on a single factor. Though we do see that the extraversion
# factor seems to have pulled in a few agreeableness items and one openness item, and agreeableness and
# openness each have one or more items that load pretty weakly. Still, the canonical factor structure seems
# mostly supported. 

# Below that, we have some information on the factors themselves - the proportion of variance each factor
# explains and the cumulative variance explained being the most relevant. We can see that together, the 
# five factors explain about 36% of the variance in the neo scores. After that, we have the general
# fit statistics again - but these are probably best viewed by using summary(). 



### Exercises

# To start, read in the personality dataset fresh, just in case. 

personality <- read.csv('Personality data.csv', 
                        stringsAsFactors = FALSE)
colnames(personality) <- tolower(colnames(personality))


# 1. Check the scale alpha for the npi variables in the personality dataset (they start with npi_). These
#    variables are all coded in the same direction (higher = more narcissistic). 

# 2. Calculative the narcissistic personality inventory (npi) scale using rowMeans(). Make sure to set
#    na.rm = TRUE, and to name your scale differently to the items. 

# 3. Type require(ggplot2), assuming you already have it installed, and use qplot to view the histogram
#    of NPI scores. 

# 4. The NPI in this dataset has responses coded as 1 or 2. But convential says it should be coded as 
#    0 and 1. Using subsetting assignment with grep(), subtract 1 from all the NPI values in personality
#    (This can be done easily in a single line of code). 

# Hint: Remember how basic operations like +, -, * etc work on vectors and data frames in R, through 
# recycling a single number and applying it to all items in the larger object. E.g:
numbers <- c(2, 4, 5, 6, 7)
numbers + 1

# 5. The NPI is often scored as a sum of its items rather than a mean. This can be a bit easier to interpret,
#    since it will range from 0 to 20 instead of 0 to 2. rowSums() works exactly like rowMeans(), except
#    that it calculates a sum instead of a mean. Try using rowSums to calculate an NPI sum score, then 
#    plot it using qplot to see that you've done it right. 


# 6. Calculate the scale alpha of the scs items in personality. Some items of this scale are reverse-coded. 
#    use the output from alpha to figure out which ones. 

# 7. Using reverse.code() and subsetting assignment, replace the scs items in the personality data frame with
#    their correctly reverse-coded versions. 

#    Note: Some people prefer to create separate variables when doing this to make it easier to keep track of 
#    what's been reverse-coded, and you can do this instead if that's your preference. But because we usually
#    have all our code for each project, from data cleaning to analysis, in one or two .R, it's much easier to
#    track whether we have or have not correctly reverse-coded something. And of course you can always use
#    alpha() to check.

# 8. The interpersonal reactivity index (IRI) is theoretically composed of 4 subscales, indicated in the 
#    variable names. Use subsetting to select all the iri items from the personality data frame. Then use fa() 
#    on the iri items, with the arguments set to 4 factors and rotate = 'varimax'. Make sure to save the result
#    to a variable. 

# 9. Use print to examine the results of your factor analysis. Do the items load where they should, 
#    theoretically? How much variance do the 4 factors explain collectively? 