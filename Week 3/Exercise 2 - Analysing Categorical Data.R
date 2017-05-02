### Analysing Categorical Data in R ###

# First, we'll generate some simple example data (the same displayed in today's powerpoint).

# First, run the code on line 6. The set.seed command tells the random number generator in R where to start
# from when it's next called. That means we can generate random data (using rnorm, below), but we'll all
# be looking at the same data and results. 
set.seed(1)

height <- c(rnorm(20, mean = 177, sd = 20),
            rnorm(20, mean = 150, sd = 20))
sex = c(rep("male",20), rep("female",20))

heightdata <- data.frame(height, sex)

# To make sure you're looking at the same data, check that your overall mean is 165.3405. If it isn't, 
# select all the lines of code from set.seed() to here and run them all again, and you should get it. 
mean(heightdata$height)


# Ok, let's start doing some statistics! Remember, the general formula that runs through most statistics
# in R follows the form "DV ~ IV" where you can read the '~' symbol as 'is predicted by'. This is then
# usually followed by an argument that tells R which dataset you want to fit the model to. 


### T-tests

# Let's get started with the simplest of statistical tests, the T-test. Using the t.test() function, we
# can test whether height differs as a function of sex. The way to read the command below is
# "fit a model where height is predicted by sex, using heightdata". Ignore the var.equal = TRUE part of 
# the command for now. 
t.test(height ~ sex, data = heightdata, var.equal = TRUE)

# Let's deconstruct the output of that command. First R tells us that we've run a two-sample t-test, 
# also known as an independent samples t-test. Next we have our t value, -5.48. The negative sign indicates that
# our first group (females) are lower than the second group (males) - group order is set alphabetically. 
# We have our degrees of freedom (38, which is 40 minus 1 for each of our 2 groups). Then we have the p.value. 
# That deserves a little unpacking. 

# 2.932e-06 basically means 2.932 times ten to the power of negative 6. If you were to expand that out, 
# it would say p = .000002932. R just prints it this way to save space. Basically, if you ever have a p
# value that looks like this, it means p < .001. 

# After that, we get the 95% confidence interval for the difference between the two groups. Then we
# have the actual means of each group, which always helps to sanity check the direction of the differences. 

# You can check those means are correct by looking at them yourself, of course:
mean(heightdata$height[heightdata$sex == 'male'])

mean(heightdata$height[heightdata$sex == 'female'])

# At the risk of going off on a tangent, you can see that these commands are starting to get a little 
# unwieldy. R has a useful command called with(), which you can basically use to tell it that the 
# command you're writing should be interpreted within the context of a certain data frame. This allows you
# to leave out the repeated referencing of the data frame when calling different variables in it. This is
# useful, for example, if you want to run a bunch of correlations within a certain dataset quickly without
# fiddling too much with the variable names. 

# As an example, instead of the above command, you can write:

with(heightdata, mean(height[sex == 'female']))

# Now to explain the var.equal = TRUE parameter. By default, R runs Welch's t-test, which does not assume
# that the variances of each group are equal to one another. This is essentially just a better version of
# the regular T-test (which is the default in SPSS) since it will give the same answer if the variances
# between groups are equal, but won't suffer from inflated type I error if they're not. You'll notice that
# the two give extremely similar output, except that the second command tells us we're running the Welch
# Two Sample t-test, and our df is 37.917 instead of 38 (this is the result of correcting for unequal
# variances). 

t.test(height ~ sex, data = heightdata, var.equal = TRUE)
t.test(height ~ sex, data = heightdata)

# In future, we'll just run the t.test command without the var.equal parameter, using Welch's t-test. But
# it's worth remembering that if for some reason you need to get the same output in both R and SPSS, you'll
# need to set var.equal to TRUE. 

### Regression and Anova with a 2-level categorical predictor

# Alright, let's move on to using regression and anova. We'll use the same example data for now - even though
# it's simple enough that we only really need a t-test, that doesn't stop us from running the same model
# with regression and anova, since they're all just different wrappers on the general linear model. 

# First, let's use the lm() command to fit a model where we only have the intercept (specified with 1). This
# is also known as the 'null model'. 

nullmodel <- lm(height ~ 1, data = heightdata)

# Notice that you don't get any output by default when you fit a model - you'll simply see a model object appear
# in your environment. This is the same as when we create a data.frame or assign something to a variable. If
# we want R to tell us something about the model, we'll use functions to do so. The primary function we'll
# use for most statistical analyses in R is summary(). Summary takes as its first (and often only) argument
# a model object, like the one we just fitted. Run it and take a look at the output. 

summary(nullmodel)

# It's pretty simple and not very interesting (which makes sense, given that we fitted a pretty simple model).
# Under Call, we can see the model that we fit (not super helpful now, but useful when juggling a lot of model
# objects). Under Coefficients, we see only (Intercept). In this case, the Intercept is simply the mean of the
# dataset, since we haven't added any explanatory variables. The significant p value next to intercept is
# meaningless here (and usually will be, for us). It just means that the mean is significantly different from
# zero.

# As an aside, you should see that the standard error on the intercept term is 3.728. We can verify this
# against the formula for standard errors (which is the standard deviation divided by the square root of N)
# using the command below. Remember that nrow gives us the number of rows in a dataset, which can be a useful
# shortcut to getting our sample size (assuming no missing data). 
sd(heightdata$height)/sqrt(nrow(heightdata))

# Alright, let's fit a more meaningful model. Here we're telling the lm() function to fit a model predicting 
# height from an intercept plus sex, using heightdata. Remember, once we have at least one predictor in the
# model, adding 1 to represent the intercept is just a formality - R will add it by default. If you wanted to
# fit a model without an intercept (though this is almost never a good idea) you'd have to replace the 1 with a
# 0.
model <- lm(height ~ 1 + sex, data = heightdata)

# And now run summary again to see what our model is saying:
summary(model)

# Here the output requires a little more deconstruction. Notice that the intercept has changed from 165 to
# 149, and we now have the term 'sexmale', with an estimate of 30.9. You might be wondering where the term
# for 'sexfemale' is. Remember that under the surface, R has dummy-coded the sex factor, such that
# female is 0, and male is 1. The Intercept in a linear model corresponds to the predicted value of the DV
# when all of the predictor variables are set to zero. When sex is set to zero, that indicates 'female', and
# so the Intercept in our model is essentially the predicted value of Height for female participants. The
# coefficient for 'sexmale' corresponds to the difference between males and females, or the additional 
# height that we would predict when sex is set to 1 instead of 0. 

# Another way of thinking about this is that we often say that beta coefficients (which the sexmale Estimate
# is) reflect the expected change in Y given a 1-unit change in X. Since a 1-unit change in X (sex) reflects a
# change from female to male, the Estimate reflects the difference between males and females.

# If you've been paying attention, you'll notice that the p.value associated with the sexmale term in the 
# model is identical to the p value that we got from our t.test earlier (when var.equal was set to TRUE).
# That shouldn't be surprising, given that we've run the same statistical test in a slightly different form.

# Let's move on to some output that might look more familiar when dealing with categorical variables. If we
# run the anova command on model instead of the summary command, we get standard-looking anova output. 
# We can see the degrees of freedom associated with sex and the Residuals (error) term, along with the
# sums of squares, mean square error, F value, and a p value for sex. In this case, where we only have
# two levels on our categorical predictor, the p value given by the anova command is the same as by regression. 
# But when we have more than two levels, it will be different, as we'll soon see. 
anova(model)

### Regression and Anova with a three-level categorical predictor. 

# Let's return briefly to the now-familiar iris dataset. Remember that there were three species of flowers
# in that dataset - versicolor, virginica, and setosa. Let's fit a model where we predict Sepal Width
# with Species.

flower.mod <- lm(Sepal.Width ~ Species, data = iris)

# This time, let's run the anova command first. The anova command here gives us output from the model, testing
# whether significant variance in Sepal Width is explained by Species. We can see that we have 2 degrees of
# freedom for Species (N - 1). We can also see, from the significant F value, that Species explains
# significant variance in Sepal Width.
anova(flower.mod)

# Now if we run the summary() command, we're still looking at the same fitted mode, but we're asking a different
# question. Instead of asking whether Species explains significiant variance in Sepal Width, we're trying to 
# predict the value of Sepal Width using the different levels of species. Again, the linear model we're 
# fitting is still the same, we're just asking slightly different questions. 

summary(flower.mod)

# We now have three Coefficient terms - the Intercept, Speciesversicolor, and Speciesvirginica. 
# Remember from before that the Intercept represents the mean Sepal Length for the setosa group, 
# because that's first in alphabetical order. But the other two terms take a little unpacking. 

# Essentially, each of these represents the expected difference in Sepal Length when a flower
# is of the Species referenced in the coefficient, compared to the 'setosa' Species. 

# So the model is telling us that versicolor flowers have a mean Sepal Length .65 (cm) smaller
# then setosa flowers, and that virginica flowers have a mean Sepal Length .45 smaller than
# setosa flowers. Because of the way dummy-coding works, each level of the categorical data
# is compared to the baseline, not to the previous level. 

# Thinking in the regression language of prediction, if we were trying to predict the Sepal Length of 
# a flower in the virginica species, we would start with the Intercept (3.43). We would apply a weight
# of 0 to the Speciesversicolor term, because our flower is not versicolor - so we'd add 0*(-.66), or 0
# to our estimate. Then we'd multiply the Speciesvirginica term by 1, because our flower is virginica. 
# 1*(-.45) gives us -.45. So our estimate for the virginica flower would be 3.43 + 0 - .45 = 2.98. 

# Not coincidentally, this matches up to the mean Sepal Width of virginica flowers, which is 2.974.

# Another way to think about these coefficients is that they are essentially pairwise comparisons between each
# of the other two species and the setosa Species. You can see that each of these comparisons has their own p
# value, which is not the same as the p value we got with the anova command before (well, for versicolor you 
# can't tell because they're both incredibly small, but take my word for it). These are the p values for the
# specific pairwise comparisons - if you want to check whether the overall variance explained by species is
# significant, you'll need to use the anova command.

### Exercises using the manylabs dataset:

# For these exercises we'll be using a subset of the data from the Manylabs 1 project (which replicated 
# 13 high-profile psychology experiments across a number of labs). Specifically, we'll look at some data
# from a classic anchoring experiment, as well as an experiment on the gambler's fallacy.

manylabs <- read.csv('manylabs small.csv', stringsAsFactors = FALSE)

#    The gambler's fallacy is a classic experiment in which participants are told that a man has just
#    rolled either three sixes in a row, or two sixes and a three. They are then asked to predict his
#    next dice role. In this data, gambfalgroup represents the manipulation group that the participants
#    were in. gambfalDV represents the DV. Remember that variables are case sensitive!

# 1. Use t.test() to test whether there is a significant difference in the gambler's fallacy DV between
#    groups.

# 2. Use lm() to fit a model where you predict the gambler's fallacy DV from the group variable

# 3. Run the anova() command on your fitted model. Does the IV explain significant variance? 

# 4. Run the summary() command on your fitted model. What does the Intercept represent in this model? 
#    Is the coefficient for the two_sixes condition significant? 

# 5. Look at the regression coefficient for two_sixes. What is the direction of the difference between 
#    condition? In which condition did participants make higher estimates? Does this make sense? 


#    Anchoring is a classic effect where showing participants a particularly high or low number before
#    asking them to estimate an unknown quantity will shift their estimate up or down, respectively. 
#    The manylabs dataset contains estimates from 4 separate anchoring experiments. Each one has a 
#    variable representing the anchoring condition (low or high) of the form anch1group, anch2group, etc. 
#    There is also a corresponding DV - anchoring1, anchoring2, etc. 

# 6. Fit a linear model predicting the result of the first anchoring experiment using the anchoring condition
#    for that experiment. 

# 7. Run summary() on your model and interpret the significance and direction of difference. Did the 
#    manipulation work? Did it shift estimates in the expected direction? 

# 8. Does it make sense to you why the Estimate for the condition variable is negative? 

# 9. Create a new data frame, manylabs_lab, which only includes the manylabs data where lab_or_online == 0 (here 0 
# indicates that the experiment was in the lab, and 1 indicates that it was online).

# 10. Fit the same model as before, but now using manylabs_lab.

# 11. Run summary on your new model. Has your estimate changed at all? Why might this be? 

# 12. Returning to the full manylabs dataset, test out the effects of the other 3 anchoring manipulations
# using lm() and summary().

# 13. Convert the anch1group variable to a factor, and recode the levels such that they go from 
#    low -> high. 

# 14. Fit your model with lm() again, and run summary() on it. Look at how the Estimate has changed. Does
#    that make sense? 
