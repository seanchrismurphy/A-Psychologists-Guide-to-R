### Tidying Data - basic melting and casting

# Let's start by reading the copewide dataset. As always, you'll want to set your working directory to where
# you have downloaded Week 6, and as in Week 5, you'll want to set it to the Data folder within the Week 6
# folder. Remember, you can change your working directory through the console with setwd(), or you can use the
# dropdown menus from Session -> Set Working Directory -> Choose Directory.

copewide <- read.csv('Intervention over time data wide.csv',
                     stringsAsFactors = FALSE)
head(copewide)

# So our task is to change this data structure such that we have a variable that represents time, and that
# time is removed from the column headers. By neccesity, this will mean that we will end up with a single
# variable holding all the values for 'ps.total', our outcome measure, since it will no longer be separatedd
# by time. Instead, time will be represented as its own variable, and the combination of the time variable
# and the ps.total variable will tell us all we need to know. Each variable will be in its own column, 
# fulfilling the principles of tidy data and allowing us to perform modelling and graphing easily with the
# dataset. 

# Now, we could accomplish this task almost exclusively using what I've already taught you - subsetting with a bit of 
# ingenuity. Let's break down the problem into steps. We need to create a time variable, containing
# the information currently in the column names. And we need to bring the ps.total variable into a 
# single column, where each value matches the time it's associated with. What we could do is create
# three separate datasets, and then stitch them together.

# Here, we've used subsetting to pull out the variables that stay the same across timepoints (pid and condition)
# and then pull only one timepoint on the outcome variable. We've created a 'time' variable in each dataset, 
# and then set it to the appropriate time. At this stage, each dataset it almost tidy. We still have time
# contained within the column names for ps.total though, which is now redundant. So let's remove that. 

copewide.T1 <- copewide[, c('pid', 'condition', 'ps.total_T1')]
copewide.T1$time <- 1

copewide.T2 <- copewide[, c('pid', 'condition', 'ps.total_T2')]
copewide.T2$time <- 2

copewide.T3 <- copewide[, c('pid', 'condition', 'ps.total_T3')]
copewide.T3$time <- 3

colnames(copewide.T1)[3] <- 'ps.total'
colnames(copewide.T2)[3] <- 'ps.total'
colnames(copewide.T3)[3] <- 'ps.total'

head(copewide.T1)

# Now we have three dataframes, each of which is tidy in itself. But now we've run into tidy data problem
# number 5 - we have information on the same unit (people) spread across multiple data.frames. We can use
# rbind() to resolve that. rbind() stitches together data frames by rows, essentially 'stacking' them 
# on top of one another. One limit of rbind() is that each data.frame needs to have the same number of 
# columns and the same column names - but in our case, we've met that requirement. So let's make our clean
# dataset!

# Another limit of rbind is that you can only stitch two dataframes together at once (at least doing it
# this way). So first we join our T1 and T2 datasets into copeclean. Then we have to join our T3 dataset
# into that joined dataset to get all three together. 
copeclean <- rbind(copewide.T1, copewide.T2)
copeclean <- rbind(copeclean, copewide.T3)

# Voila! We have a tidy dataset, in a suitable format for MLM. Each row tells us all the information for
# one observation (a timepoint within a person). We know the pid, condition, time, and value for
# the outcome variable. And each column contains only a single variable, with values only in the cells, not
# the variable names. This dataset is now correctly set up for multi-level modelling. 
head(copeclean)

### Drawbacks to this approach - bugs caused by replication

# However, while functional, this is not really a satisfactory way to do things. For one, it's easy to make
# mistakes. By writing the same code out three times but changing some of the variable names, we risk scrambling
# the data with a small mistake that we wouldn't notice. For instance, take a look at the code below:

copewide.T1 <- copewide[, c('pid', 'condition', 'ps.total_T1')]
copewide.T1$time <- 1

copewide.T2 <- copewide[, c('pid', 'condition', 'ps.total_T2')]
copewide.T2$time <- 2

copewide.T3 <- copewide[, c('pid', 'condition', 'ps.total_T2')]
copewide.T3$time <- 3

# I've made a fairly easy to miss error here (copewide.T3 contains ps.total_T2) but it has pretty serious
# ramifications - our outcome variables at time 2 have been copied to time 3. Worse, it might be completely
# unnoticed - this won't cause any errors in R, and might not be obvious in data analysis. 

### Drawbacks to this approach - time consuming

# Another drawback is, of course, the time consuming nature of this approach. In this case, it wasn't 
# too bad - we had to write out code out three times and it took two commands to merge it together. But
# imagine if we had 5, 10, or 30 timepoints? Or what if we had additional variables that also needed
# splitting alongside time? You'd quickly get exhausted writing the code, and errors might multiply. 
# In some, more complicated cases, it might be hard to figure out how to get where you want with subsetting
# alone. 

### Melting and casting - a better way

# This is where the reshape2 and tidyr packages come in to save the day. In principle, you can think of 
# what these packages do as pretty similar to what we did manually with subsetting - I wanted you to see 
# the principles in action step-by-step. But these packages contain powerful functions that allow you to
# tell R how you want the data to look, and have it take all those steps for you - saving much time and
# potential errors. 

# The reshape2 package works on the principles of 'melting' and 'casting' your data. Melting is the process
# of breaking your data down into its simplest (longest) form, where each observation (which may be defined
# differently based on your research question) has its own row. This is essentially what we just did to our
# coping data.

# Casting is the opposite of melting - it takes data that is very 'long', and makes it wider by grouping
# together observations and 'spreading' values on the same observations into a wider data.frame. In our 
# case, casting our newly melted data frame would just get us back to what we started with. The real power
# of melting and casting, as we will soon see, is when you have multiple sources of 'untidyness' in your
# data - you can melt the dataframe into the easiest form to fix once source of untidyness, cast it into
# the easiest form to fix another, and so on. Especially when dealing with very complicated datasets, this
# can speed things up to the point where it becomes feasible to examine hypotheses that you would have ignored
# before, simply because the time to structure the data appropriately would have been prohibitive. 


### Simple melting

# Before we go any further, if you haven't already, you'll need to enable the reshape2 and tidyr packages

require(reshape2); require(tidyr)

# Also, make sure you still have the untouched version of copewide we read it. It should have 107 rows
# and 5 columns
print(paste('number of rows:', nrow(copewide))); print(paste('number of columns:', ncol(copewide)))

# Now let's do exactly what we did before - we'll melt our input data, but using the melt command. 

# The first argument to this command is the dataset we want to melt (copewide). Next is id.vars - these are 
# the variables that we want to remain constant constant across all our lowest level observations. In our case, 
# our id.vars are pid and condition - because participant id and condition don't change across time, which is 
# our level 1 unit. To melt the dataset then, we'd use this command:

copemelt <- melt(copewide, id.vars = c('pid', 'condition'))

# When we look at copemelt, we can see that it's appropriately structured - it has the right information
# in each row. But the default variable names ('variable' and 'value') are not super informative in this 
# case. The variable column contains what used to be our variable names. In this case, that means it has
# the information we need on time. The value column contains the values that were in each cell before. Since
# we only have value on one variable (ps.total) we can just rename this column to ps.total now. 
head(copemelt)

colnames(copemelt)[3:4] <- c('time', 'ps.total')
head(copemelt)

# Now our data is looking better. Technically, the time variable contains all the information we need (it has
# a different value at each timepoint, and no other meaningful information is in that column, since ps.total 
# is just a constant string added to each time value). However, if we want to look at linear effects of time, 
# we need to be able to model it as a number, and just for readability's sake, we'd like to get rid of the
# extra information. We can do this using str_replace to scrub the extra information from the time
# variable. In this case, we're replacing the string 'ps.total_T' with nothing, effectively cutting it out. 
# this leaves us with just a number for time. I'll explain str_replace a bit more in the next exercise.

copemelt$time <- str_replace(copemelt$time, 'ps.total_T', '')

head(copemelt)

# Now we have a clean dataset for the coping data, set up perfectly for longitudinal MLM. Let's review the
# entirety of the commands it took to get us here: 

copemelt <- melt(copewide, id.vars = c('pid', 'condition'))
colnames(copemelt)[3:4] <- c('time', 'ps.total')
copemelt$time <- str_replace(copemelt$time, 'ps.total_T', '')

# It only took us 3 lines of code, instead of the 11 it took before. But the real kicker is that it would 
# still have only taken us 3 lines of code if there were 30 timepoints in the dataset.

# The melt approach scales up so it can handle bigger data just as easily as smaller data like this. In
# contrast, using subsetting and rbind would take us 89 lines of code with 30 timepoints.


### Simple casting

# In this example, we wouldn't usually change our data any further, since we've got it just how we want it. But with
# more complex data, we'll often want to melt our data frame into a form that is a bit too long for analysis, then make
# it a bit wider with dcast(), our casting function. We'll see this in action in the integrative data cleaning exercise
# for the dat. 

# For now, we could imagine this as a version of problem #3 (variables are in rows) if we really wanted a separate
# variable for each timepoint, for whatever reason. Thus, we'll use this time data as a simple example of how dcast 
# works to solve problem #3 of tidy data.

# Using dcast can be a little complicated, because we need to specify how we want to treat our variables using a
# formula. I'll explain the logic, but to be honest, for a long time I had to use trial and error a few times before I
# found the right formula, and that's not usually a huge problem.

# The formula for casting is basically as follows: 
# xvariable1 + xvariable2 ~ yvariable1 + yvariable2, value.var = 'value'

# The way this works is that dcast interprets the x variables as your 'identifying variables'. You're 
# basically saying 'in my new, casted dataset, I would like a row for each combination of these xvariables'. 
# The yvariables are going to become columns in your new dataset - essentially, they will be a variable
# that contains a value for each of your new rows. The value.var is the data that will be used to fill in 
# the cells in this new dataframe.

# In our case, we are trying to get back to the dataset we started with - copewide. Take a look at that 
# dataset
head(copewide)

# Our xvariables are pid and condition - for each combination of these, we want a row in our new dataframe.

# Now let's take a look at our melted dataframe to figure out the rest. 
head(copemelt)
# Our yvariable is going to be time - because we want three columns (apart from the xvariables) in our new
# dataframe, one for each timepoint. And our value.var is going to be ps.total, because that's the value we
# want to fill in all of the cells in this new combination. So essentially, for each participant (pid +
# condition, since they're only in one condition each) we want three columns, one for each timepoint, and we
# want those columns filled with the appropriate ps.total values. That pretty much describes the dataset we
# started with. The formula that matches this is specified below:

copecast <- dcast(copemelt, pid + condition ~ time, value.var = 'ps.total')

# You can see the copecast has the same number of rows and columns as the copewide data we started with - 
# always a good sign:
print(paste('number of rows:', nrow(copewide))); print(paste('number of columns:', ncol(copewide)))
print(paste('number of rows:', nrow(copecast))); print(paste('number of columns:', ncol(copecast)))


# Now let's take a look at our casted data alongside the original data:
head(copecast)
head(copewide)

# You should be able to see that we have recreated the data exactly as it was in the original dataset. We
# have 'melted' the data into long format and then 'casted' it back into wide format, and nothing has been
# changed. The only difference is in the column names. Because dcast takes the value of 'time' and turns that
# into column names, they've been simplified to 1, 2, and 3. This is because we used str_replace to simplify
# those column names when they were variables in the melted dataset. But it's easy enough for us to change
# them back: 

# paste() is always handy in these cases. First, let's make sure we have a paste command
# that will create the column names we want. Paste appends each of its first arguments to each of its second arguments,
# separating the results with the value in 'sep'. It will replicate the shorter vector to match the longer one, so
# the code below gives us three values:

paste('ps.total_T', c(1, 2, 3), sep = '')

# Then we overwrite the column names
colnames(copecast)[3:5] <- paste('ps.total_T', c(1, 2, 3), sep = '')

# And voila! We have exactly what we started with. 
head(copecast)

# We can use the identical function in R to check whether two objects are exactly the same. This can be handy
# when checking for bugs. Since the output here is TRUE, we know these two dataframes are identical - we have
# lost nothing in translation. 
identical(copewide, copecast)


### Now let's take a look at the entire process, start to finish. This is (hopefully) what your data cleaning
### code will start to look like when you get the hang of things:

### Read in the data and examine it. 
copewide <- read.csv('Intervention over time data wide.csv',
                     stringsAsFactors = FALSE)
head(copewide)

### Melt the data
copemelt <- melt(copewide, id.vars = c('pid', 'condition'))
colnames(copemelt)[3:4] <- c('time', 'ps.total')
copemelt$time <- str_replace(copemelt$time, 'ps.total_T', '')

### Cast the data
copecast <- dcast(copemelt, pid + condition ~ time, value.var = 'ps.total')
colnames(copecast)[3:5] <- paste0('ps.total_T', c(1, 2, 3))

# It's as easy as that!

# While you don't need to learn these for this course, there are also some extra arguments and tricks 
# to melt and cast to save even more time once you get the hang of them. Here I go from 5 lines of code
# to 3 using optional arguments to set up the names of my melted and casted datasets automatically. 

copemelt <- melt(copewide, id.vars = c('pid', 'condition'), variable.name = 'time', value.name = 'ps.total')
copemelt$time <- str_replace(copemelt$time, 'ps.total_T', '')

copecast <- dcast(copemelt, pid + condition ~ paste0('ps.total_T', time), value.var = 'ps.total')


### Exercises 

# Read in the 'height over time wide' data from this week's data folder and take a look at it.

height <- read.csv('height over time wide.csv', stringsAsFactors = FALSE)

head(height)

### This data represents the height measurements from 26 boys over 9 timepoints. As you can see, the data
### is currently in wide format - we couldn't run a longitudinal mlm with the data as it is. 

# 1. Using the melt() and str_replace() commands, melt the height data into heightmelt, a data frame suitable
#    for multilevel modelling. You should end up with 234 rows and 3 columns. 

# 2. Using the dcast() and colnames() commands, cast your melted dataframe into heightcast, a dataframe that 
#    should be identical to the original height data.frame. Use the identical() command to check. 
