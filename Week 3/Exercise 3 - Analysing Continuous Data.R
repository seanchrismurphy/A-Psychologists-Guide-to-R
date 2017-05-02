### Analysing Continuous Data in R ###

# For this exercise, we'll read in some more real data. If you haven't already, set you working directory
# to wherever you've copied the Week 3 dropbox folder. Remember that if you can't get setwd() to work, 
# you can use the dropdown menu in RStudio (Session -> Set working directory -> choose directory). 

# Once you've done that, run the following:

charis <- read.csv('charisma data.csv', stringsAsFactors = FALSE)

# Take a quick look at the data:
head(charis)

# This is data from Study 2 of von Hippel et al (2015). The key hypothesis of that paper was that 
# people with greater mental speed (as indexed by faster reaction times to a variety of tasks)
# would be rated as more Charismatic and Socially Skilled by their friends. Below is a list of the
# variables in this dataset and what they mean (it's often a good idea to put something like this
# at the top of your analysis code, so that you (or anyone you send your code to) will remember
# what everything means)

# You can also find the paper here if you want more information:
# https://www.researchgate.net/profile/Sean_Murphy34/publication/285385794_Quick_Thinkers_Are_Smooth_Talkers_Mental_Speed_Facilitates_Charisma/links/56c2760808ae44da37ff7bde.pdf

### Variable list ###

# group.number: The code for which friendship group a participant was in
# target.language: A code for ESL status of the participant, where 1 indicates English as a Second Language
# avg.speed: The key IV - the average standardized reaction time across three tasks
# charisma and social_skill: The two key DVs - the average rating of charisma and social skills
# received by the participant from their friends (group-mean centered). 
# neo_neurotic, neo_extravert etc: Big 5 personality factor scores from NEO-PI 60
# npi: The narcissistic personality inventory score
# emexp: emotional expressivity score


# OK. Now that we've read in the data, let's get started. Having looked at some basic analyses with 
# categorical predictors, we're now going to do basic analyses with continuous predictors. As we 
# started off simple before with a t-test, let's start off simple again, with a correlation. 
# To run a correlation in R, you can use cor.test. Since correlations don't neccesarily have an IV
# and DV, we'll abandon the formula syntax we've been using so far for a moment. With cor.test, we
# just input the two variables we want to test, separated by a comma, like so:

cor.test(charis$neo_open, charis$emexp)

# We can also use the with() command, as demonstrated in the previous exercise:
with(charis, cor.test(neo_open, emexp))

# So, let's break down the output again. We have a t value, a df, and a p value - these give us the 
# basic vital statistics on our correlation and tell us whether it's significant or not. We have a 
# 95% confidence interval around the correlation estimate, then we have the estimate itself (.17). 
# In formal reporting, this correlation is significant, r(215) = .17, t = 2.53, p = .012.

# It's always a good idea to plot your continuous relationships to make sure nothing fishy is going on. 
# We'll spend a lot more time on plotting later, but let's take a quick look at this relationship. To
# do that, we'll first want to install the ggplot package, which does most of the fancy graphics we'll
# be using:

install.packages('ggplot2')

# Remember that you'll need to require the ggplot2 package before you can use it. 
require(ggplot2)

# To plot variables, we'll use the qplot() function, which stands for quick-plot. This function is clever:
# If we give it a single variable, it will give us a histogram of that variable. If we give it two variables, 
# it will give us a scatterplot. 

qplot(charis$neo_open, charis$emexp)

# You can see that it's not exactly the strongest relationship in the world - correlations below .3 tend to 
# look pretty indistinguishable from noise. But nothing looks dramatically wrong with the data.


# There's not a built in R function to generate a pretty correlation matrix with significance stars like 
# we're used to from SPSS. But people have written code to do this, and I have put this code into a small
# package that I maintain. To load that package, we're going to run the following line of code.

install.packages('devtools'); require(devtools); install_github('seanchrismurphy/Smisc', require(Smisc))

# Once that's done, you should have access to the corstars function, which you can run on a dataset
# (or part of a dataset) to get a correlation matrix:

corstars(charis)

### Continuous variables in regression

# Let's move on to running regressions with continuous variables. These should be pretty familiar - they'll
# look much the same in R as they do in SPSS. The following commands run the regression equivalent of the
# correlation we just ran before: 

model <- lm(emexp ~ neo_open, data = charis)
summary(model)

# In the output now, since there are no categorical variables in the model, the intercept represents the 
# grand mean of the DV (emexp). The estimate for neo_open reflects the expected change in emexp with a
# 1-unit increase in neo_open. Notice that the Estimate (.27) is different to the correlation we got 
# before (.17). This is because R reports unstandardized betas. The p value, however, is identical. 

# How do we get standardized betas in R? The most straightforward way is to standardize your continuous
# IVs and DV. When both IVs and DV are standardized, the coefficients you'll get are equivalent to 
# standardized betas. 

# I mentioned in week one that one of the handy features of R is that when a function is nested within another
# function, R will run the inner function and then use the results of that to feed in to the outer function. 
# A simple example of this can be seen below. The first sqrt command takes the square root of 16 (4). The
# second one takes that 4 as input, and gives the square root of that (2). 

sqrt(sqrt(16))


# In the case of fitting models, this means we can use functions to modify the variables within our model
# syntax, and R will fit the model to the modified variables. This saves us from having to create new
# variables every time we want to standardize a variable or perform a square root transform, for instance.

# Let's take a look at how it works in practice. The scale() function standardizes variables (subtracts the
# mean and divides by the standard deviation, resulting in a variable with a mean of zero and an SD of 1). 

# You can take a look at this behavior using qplot(). As I mentioned above, qplot can be used to plot a 
# histogram of a single variable. 
qplot(charis$neo_open)

# Now we can plot the openness variable after using scale(). Notice that the mean has shifted to 0, and
# the values are pretty much all between -3 and +3 (because they now represent standard deviations). 
qplot(scale(charis$neo_open))


# Now, let's fit a linear model using scaled variables. You can see that in the output to summary(model_std), 
# the Estimate for scale(neo_open) is the same as the correlation coefficient we found before (.17). 
model_std <- lm(scale(emexp) ~ scale(neo_open), data = charis)

summary(model_std)
summary(model)



### Regression with multiple predictors

# So far we've only looked at regressions with a single IV, which is a little bit of overkill. Now though, 
# we can start adding multiple predictors to the model. To do this, we simply use the '+' sign. The
# general formula for the linear model in R with multiple predictors looks something like this:

# DV ~ 1 + IV1 + IV2 + IV3 etc...


# So if we want to run a model with multiple predictors on our current dataset, it looks like this:

multimod <- lm(social_skill ~ npi + neo_agreeable, data = charis)
summary(multimod)

# The model output should look pretty familiar by now. We have unstandardized estimates for the effects
# of npi and neo_agreeable on social_skill - both of which are significant, as seen by the p values
# (which are helpfully accompanied by significance stars). 

# Note that the Intercept term for social_skill is 1.58 in this model, substantially lower than the actual 
# mean (3.24). That's because it represents the expected social skill when each of the predictors is zero.
# Since zero isn't a valid value for either the NPI or the agreeableness scales, the intercept isn't
# particularly meaningful in this model. 

# Tip: You can use the range command to check the range of possible values for a variable:
range(charis$npi)

range(charis$neo_agreeable)

### Regression using subsets as a filter

# When using SPSS, it's common to run the filter command to exclude certain participants from a specific
# set of analyses. When we want to do this in R, we make use of subsetting. Remember that each of the 
# models we've looked at so far has had a data argument, specifying which dataset to fit our model to. 
# By using subsetting within this data argument, we can selectively filter the dataset that our analyses 
# are run on. 

# Let's take another look at the model we just ran. The data = charis section of the command below is
# fitting the model to the charis dataset. 
multimod <- lm(social_skill ~ npi + neo_agreeable, data = charis)

# Suppose we wanted to run our model on only the subset of participants for whom english is a first 
# language (recall that the target.language variable codes this, with 1 = ESL and 0 = native speaker). 
# We can use logical subsetting like this to reduce the charis dataset:

charis[charis$target.language == 0, ]

# Since this is a real-life dataset, it's a bit too large to manually check that our command worked. But
# we can use nrow to check that we've successfully reduced the number of rows in the dataset. The 
# following commands show that our original 218 row dataset is reduced to 184 rows when using our subset
# command. 

nrow(charis)
nrow(charis[charis$target.language == 0, ])

# That matches up to the output we get if we use the table() command to look at the frequencies in the 
# target.language variable (we'll go into the uses of table() more next week):
table(charis$target.language)

# So, we've got our subsetting code set up right. Now, we could use assignment to create a new dataset, 
# say, charis_eng, containing only english speakers, and fit our model to that new dataset. Sometimes that
# can be best, for example, when we want to run a lot of analyses on a specific subset of data. But we don't
# have to do that. We can just use the subsetting code within our model fitting syntax, as you can see below:

multimod.red <- lm(social_skill ~ npi + neo_agreeable, data = charis[charis$target.language == 0, ])

summary(multimod.red)

# Obviously if we wanted to do a number of exploratory analyses using different filters, this approach
# will be faster than creating new datasets for each filter. 


### Exercises 

# 1. Fit a model testing the key hypothesis that avg.speed will predict charisma.

# 2. Run summary on your model and examine the output. What is the direction of the effect?

# 3. Was the hypothesis supported? Remember that with reaction time data, smaller numbers mean faster
#    responses. 

# 4. Use scale() to get a standardized estimate of the effect

# 5. Add extraversion and agreeableness to the model as controls (remember you can check the precise variable
#    names using colnames(charis)). Is the main effect of speed still significant?

# 6. Try looking at social_skill as a DV. Does speed significantly effect social_skill? 

# 7. Go back to running a simple model predicting charisma from avg.speed, but this time fit your model
#    to a subset of the data where neo_neurotic is greater than 3. Is the effect still significant? 
#    Look at the degrees of freedom in the summary() for this model, compared to the model without 
#    subsetting. Does the difference between them make sense? 




## A final note. It's helpful for illustrative purposes to first fit your model, then examine it with
## summmarize. But since R evaluates functions in a nested fashion, you can speed things up by doing
## it all in one line of code, like so:

summary(lm(emexp ~ neo_open, data = charis))

## Note that because we haven't saved a model here, nothing will appear in your environment. What's happening
## here is that R is fitting the model object, printing you the summary, and then 'forgetting' the model, 
## since you didn't save it. 