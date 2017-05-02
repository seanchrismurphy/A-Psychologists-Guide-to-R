### Running a repeated measures anova in R

# Repeated measures anova can be thought of as one of the simplest cases of multi-level models - simple 
# enough that it's been in widespread use for a lot longer. While there are specialised functions that
# only do repeated measures anova in packages like SPSS, there's not a lot of point to using them in 
# something like R, where the same thing can be done with multi-level models using only slightly different
# syntax. Let's take a look at sleepdata, which is a builtin dataset in R. Run the lines of code below to
# load it up and give it slightly more informative variable names. 

sleepdata <- sleep
colnames(sleepdata)[2] <- 'condition'

head(sleepdata)

# Sleepdata contains observations of 10 participants under two different drug conditions, and the DV (extra)
# codes additional hours of sleep compared to a control (the control data is not in the dataset). So we 
# essentially have a repeated measures design with two measures for each participant. It's simple enough
# to use repeated-measures anova, so I will show you the code to do that in R, though we won't use it after
# this.

# First, we can just check that if we ignore the repeated measures parameter and just run a linear model
# looking at the effects of condition, we don't have a significant effect. Here we're wasting the additional
# power that comes from repeated measures. 
summary(lm(extra ~ group, data = sleep))

# Now let's run a simple repeated measures anova in R. This uses the aov command, which is slightly different
# from anova(lm). Here we use the Error parameter to specify that errors are clustered within participants. 

summary(aov(extra ~ group + Error(ID/group), data = sleep))

# As you can see, now that we've identified our participants correctly, the model can account for the 
# between-individual differences and increase the power to detect within-individual effects. 

# Now let's run the equivalent command using multilevel, or mixed effects, models. For these we'll use
# lmer(), and the lmer() function will handle every mixed effect model we will be likely to ever fit 
# (repeated measures, longitudinal models, participants-within-groups, dyadic and round-robin )

# This is the command to fit the repeated measures model in lmer. As before, we have to tell the model that
# there is a grouping factor - we do this with (1|ID), which tells the model to fit a random intercept
# to each participant, essentially accounting for unexplained between-participant differences, or, in other
# terms, partitioning our error into between and within-subjects. 

model.1 <- (lmer(extra ~ group + (1|ID), data = sleep))

# If we then run an anova on our model.1, we get the same results we did with aov, because this is a very
# simple model. We can also run summary, though, to get regression-style output in the same format we're 
# used to from lm(). One of the benefits of lmer() is that we can quickly switch from running normal linear
# models with lm() to running multilevel models with lmer(), and the syntax is largely the same - we just
# have to add grouping factors to identify 'levels', or sources of clustering, that we want to model. 
anova(model.1)
summary(model.1)

# Let's read in some real priming data that also fits a repeated measures design. You'll want to set your
# working directory today to the data subfolder within week 5. Remember that you can use the drop-down menus
# to do this with Session -> Set Working Directory -> Choose Directory, or alternatively, use setwd(). 
# Once you've done that, you should be able to run list.files() below and see a list of .csv files, the
# data we'll be working with today. 

list.files()

# Assuming that you see the correct output, read in the data for our first exercise using the code below:
prime <- read.csv('simple repeated measures priming.csv')

# This is a simple dataset with the same repeated measures structure as sleep. The DV is RT, the average
# reaction time of each participant in each condition. The key IV if freq, the frequency of occurence of
# the primes participants were responding to (it has two levels, L and M, representing low and medium). 
# The P variable codes for participant identity. You can use the table command to see that each participant
# has two observations (one for low freq, one for high freq)
table(prime$P)

# The following code will fit a simple linear model to the data, ignoring the clustering inherent in having
# two observations from each participant. 

summary(lm(RT ~ freq, data = prime))

# Exercises

# 1. Interpret the direction of the effect in the linear model, remember that lower RT scores mean faster
#    reactions. Does this effect make sense? 

# 2. Fit the same model, but use lmer and specify clustering within participant. 

# 3. Run the summary command on the model. Has the coefficient for freq changed? What about the signficance?