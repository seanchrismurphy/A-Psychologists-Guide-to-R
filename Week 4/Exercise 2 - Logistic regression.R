### Binomial regression in R

# Running binomial regressions in R is pretty straightforward. The syntax is identical to running normal
# regression, but instead of lm (linear model) we run glm (general linear model), since we've moved to the 
# more general case of using models for non-continuous outcomes. 

# We also need to add an extra argument - the family argument. This tells R which kind of general linear model
# it's fitting.

# Finally, we need our outcome variable to be made up of either 0s and 1s, or TRUE and FALSE values, 
# so that we can successfully fit a binomial regression. If our outcome data is coded as 1s and 2s, we'll
# need to subtract 1 so that it becomes 0s and 1s. 

# Make sure that your working directory is set to wherever you've copied Week 4. 
dating <- read.csv('dating_profiles.csv', stringsAsFactors = FALSE)

# The binomial outcome of interest here is called Decision. It represents whether or not a rater, who was
# reading a dating profile, said they would go on a date with the author if asked. There are also several
# other judgments from the rater (confidence, arrogance, desirability, humour, etc) and some demographics. 

# First we subtract 1 from the binomial variable, since it's coded as 1 or 2. R will give an error if we 
# try to run a binomial regression with anything other than TRUE/FALSE or 1 and 0. 
dating$Decision <- dating$Decision - 1

# Then we can fit a model. Here we specify that the family of our model is binomial, and that the link
# function is 'logit'. You don't need to know much about those parameters except that the combination tells
# the glm function we want a logistic regression.

# If we wanted to know how the Binomial outcome varies as a function of confidence ratings, we could 
# fit the model below, remembering that we're using glm instead of lm. 
model <- glm(Decision ~ Confident, data = dating, family = binomial(link = 'logit'))

# And then we can use summary just like normal. 
summary(model)

# We can see that the more confident someone finds a dating profile, the more likely they are to agree
# to go on a date with the writer. But we can't interpret the regression estimates in a logistic regression
# as easily as normal. They represent the change in the log-odds of the outcome (1 versus 0) associated with
# a 1-unit increase in the IV. To turn log-odds into something we can understand, we need to exponentiate
# them. We can do this using the following commands - coef extracts the regression coefficients from the 
# model, and exp exponentiates them (the reverse of log). 

exp(coef(model))

# You should see that the estimate for Confident is 1.38. That's an odds-ratio. It means that every 1-unit 
# increase in rated confidence increases the likelihood that someone will say yes to a date by about 38%.
# Generally with logistic regression it makes more sense (i.e. is more interpretable to readers) to report
# odds ratios.


# You can find more information and worked examples of logistic regression here:
# http://www.ats.ucla.edu/stat/r/dae/logit.htm