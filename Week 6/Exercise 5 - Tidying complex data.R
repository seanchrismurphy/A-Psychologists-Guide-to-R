# In this example I'll be demonstrating some of the principles of tidying data using a complicated, messy dataset
# collected via Qualtrics (courtesy of Dr Katie Greenaway)

# As always, you'll want to point this reference to wherever you have saved the data from dropbox. 

status <- read.csv('/Users/Sean/Dropbox/Data/status data messy.csv', 
                   stringsAsFactors = FALSE)

# This dataset is quite an untidy one (though I have cleaned it slightly from its original state). Take a look:

head(status)

# The dataset contains the results of a within-subjects experiment conducted over Qualtrics. In this experiment,
# participants watched videos of subjects either suppressing or expressing their emotions, and were told, 
# for each video, that the subject was being authentic or inauthentic in their expression. Then they rated the
# subject on a number of variables (charisma, competence, confidence, dominance, successfullness).

# However, looking through the dataset you might notice that we don't seem to have a variable to represent our
# key manipulation (suppression versus expression). Nor do we have a variable to represent authentic versus 
# inauthentic. In fact, pretty much all of our key variables are contained within the column names! E or S
# stands for a response to an expressive video, then there is a number for the Subject of the video, then an i or
# a for inauthentic or authentic, then the variable being rated.

# So E35a_Competence would be the rating of charisma given to (video) Subject 35, when expressing and authentic.

# Clearly, we have an extreme case of untidy data problem #1 here (values in variable names). This is probably
# the most common data problem I run into, mostly because datasets from repeated measures or longitudinal datasets are
# often collected in this 'wide' format because that is the easiest way to collect and store them, but this isn't 
# a tidy way to store them (and not conducive to multilevel modelling). 


# You can see from the size of this dataset that cleaning it would be a pretty daunting task by hand, or even using
# specific subsetting commands in R. Thankfully, with the suite of tools we've learned, this dataset can be cleaned
# in only a few short commands. 


# First, we'll want to melt() the data, putting all of the column headers containing data into a single column where
# we can work on them with separate(). To do this, we need to specify our id.vars in melt. These are the variables
# that, together, identify a single observational unit - in this case a participant. 

colnames(status)

# In this data frame, our id variables are PID (participant ID), age, gender, national, race, and relstat.

# Before we go any further, let's make all our column names lower case.
colnames(status) <- tolower(colnames(status))


colnames(status)

# Alright, now let's melt the data. Because we can easily make mistakes when using complicated functions like melt
# and cast, it's never a good idea to overwrite the original data frame. Instead, I usually add the word 'melt'
# and 'cast' to the end of the name (as you've already seen).

statusmelt <- melt(status, id.vars = c('pid', 'age', 'gender', 'national', 'race', 'relstat'))

# As you can see, the statusmelt data frame is considerably narrower than the status dataframe. But it's much longer
# (24000 rows instead of 200).
head(statusmelt)


# So now we have resolved tidy data problem #1 - there are no more values in our column headers. But we have now
# entered into tidy data problem #2. We have multiple variables stored in the single 'variable' column. This is, of
# course, a function of having column headers that each stored multiple variables, which we have now moved down. This
# will often by the case with repeated measures experiments that are recorded in wide format. 


# Now we need to break up the variable column, but we need to be clever about it Unfortunately, 
# our variable names are not nicely broken up into their various components using a single separator (like, say, 
# _ or .). The rating variable (e.g. charisma) is separated from the rest, but the other variables are all stuck
# together. We could use separate to split the variable based on character positions, but unfortunately some subject
# numbers are single digit numbers (e.g. 9), while some are double digits (e.g. 14). This means we can't pinpoint
# a specific split point that will work for all variables. 

# There are a number of ways to solve this problem. Some of them use less lines of code than others, but all will work. 
# We could use str_extract multiple times and, using simple regular expression, copy each variable out into its own
# column. This approach has the benefit of flexibility - we wouldn't need to modify the 'variable' column before 
# using it. 

# For example, this code would give us just the e/i information we need to know the express/suppress condition. The 
# [ ] indicators, in regex, mean (anything inside these square brackets goes), so they're kind of like a super 'OR'
str_extract(statusmelt$variable, '[ei]')


# Alternatively, we could change the variable column to make separate easier to use. We could insert separating 
# characters like underscores between our different components (though this would require some tricky regular
# expressions). Or, we could pad the Subject numbers so that they were all double digits, allowing separate to work
# on character positions. Let's try that approach. 

# Here we're using regular expressions with grouping. Essentially, for every curved bracket we use, we create a group in
# our match. The regular expression I've written essentially says 'find the cases where a single digit sits between two
# lowercase letters, and insert a zero before that digit'.
statusmelt$variable <- str_replace(statusmelt$variable, '([a-z])([0-9])([a-z])', '\\10\\2\\3')


# Having inserted a zero, the starting positions of the different variables in our row all line up. We can use 
# separate

statusmelt <- (separate(statusmelt, variable, into = c('exp_cond', 'subject', 'auth_cond', 'rating'), sep = c(1, 3, 4)))

head(statusmelt)

# You should see that we now have the appropriate columns for our expression, subject, and athenticity variables. Huzzah!
# However, we're not done yet. We now have tidy data problem number 3 - variables in rows. Specifically, we probably
# want to treat the different types of rating in the rating column (charisma, confidence, etc) as separate variables. 
# That means we need to use dcast to spread them out into the data. First, let's use string_replace to get rid of that
# pesky underscore.

statusmelt$rating <- str_replace(statusmelt$rating, '_', '')

# Now, we just have to use dcast. The '...' in a dcast formula stands for 'everything else'. So, since most of the 
# variables we've created are not where we want them (and so we want them on the left of the formula) we'll make use
# of that '...'. We tell dcast that the values we want to fill the cells of our new dataframe with are in the 
# 'value' column. 

statuscast <- dcast(statusmelt, ... ~ rating, value.var = 'value')

head(statuscast)

# You should see that our data is now in 'tidy' format. We had a row for each observation. In this case, that means
# a row for each time a participant viewed a video. Now that the data is tidy, it's also in the perfect format to 
# run lmer() to properly model the data.

# Notice that we have a lot of rows of missing data. This is because when we melt the data, by default missing
# values are kept. You can add the na.rm = TRUE argument to melt, and it won't transfer missing data when it melts
# the data frame. If you go back up to the melt command and add in na.rm = TRUE, then run everything after it, 
# you'll see that these missing values are removed. 


# We can confirm that the data is now in the correct format by performing some simple MLM to test the 
# experimental hypothesis that expression will only help participants if it seems authentic. 
summary(lmer(charisma ~ 1 + exp_cond*auth_cond + (1|pid) + (1|subject), data = statuscast))


# I haven't included any exercises for this final demonstration, but I do encourage you to try out the principles
# I've shown here on your own data. Best of luck!


