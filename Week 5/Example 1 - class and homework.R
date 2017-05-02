# We're going to read in some data that fits the example we've been working through in the slides. As always,
# you'll want to set your working directory first. This week, you'll want to set your working directory 
# specifically to the data subfolder in Week 5. 

example <- read.csv('class homework example.csv')


# This data is of the disaggregated format that we talked about in the example. Take a look with head(), 
# and you'll see that teach_experience, the level 2 variable, does not vary within each class, since it has
# been carried down. 

head(example)

# First, we can fit a simple linear regression model, ignoring the clustering in the data. This is a 
# disaggregation analysis. Obviously, it's problematic since it ignores the clustering of errors in the 
# data. You'll see that there are positive effects of homework and teacher experience on performance. 

summary(lm(performance ~ homework + teach_experience, data = example))

# If we test the interaction, we see that our model suggests that homework has more of an
# impact on performance when teachers are more experienced.
summary(lm(performance ~ scale(homework) * scale(teach_experience), data = example))

# However, we want to run a proper multilevel model. To do so, require lme4 if you haven't already (or install
# it first, if you haven't done that either)
require(lme4)

# Let's start by fitting the most basic multilevel model - the empty model. In this case, we simple fit a 
# random intercept term, and examine where our variance is. The syntax to fit a random effect in lme4 is 
# fairly simple. Within the regression equation, we add a term of the form (1|group), where group is our
# level two grouping variable. Since 1 is the syntax for 'intercept' in R regression code, this tells the
# model to fit an intercept that varies by group. Ignore the error in lmerTest for now.

summary(lmer(performance ~ 1 + (1 |class), data = example))

# Looking at the output, you'll see it appears different to a standard linear regression. We have a section
# called Random effects, which only have variances and standard deviations. Remember that with random 
# effects, we're not interested in modelling specific coefficients - rather, we're just estimating the
# distribution of variance. In this case, we can see that there is substantial variance in the class
# intercept parameter, more-so than the residual (which represents leftover level 1 error). This indicates
# that our classes vary substantially in their average performance. We can get an easier-to-read estimate
# by scaling our DV. By setting the variance in the DV to 1, the variance of the random effects can be
# read as close to the percentage of variance explained at each level. 

example$performance <- scale(example$performance)
summary(lmer(performance ~ 1 + (1 |class), data = example))

# So about 70% of the variance in performance can be explained at the class level. This means that our lm
# estimates are likely to be very overconfident, since there is a lot of clustering going on. 

# Let's try fitting the multilevel version of our original model, with predictors at both levels. In R, we
# don't need to explicitly specify which level the predictor is at. We can simply write out the syntax as
# we normally would for a linear model. The model is smart enough to figure out that teach_experience does
# not vary within class, and so uses it as a class level predictor. 

summary(lmer(performance ~ homework + teach_experience + (1 | class), data = example))

# We can see from the output that this model is much more conservative in its estimations than the simple
# linear model (below). While the main effects are both still significant, the t values have dropped from 
# 16 and 14 to 9 and 3, respectively. 
summary(lm(performance ~ homework + teach_experience, data = example))


# We also can see, if we model the interaction, that it's no longer significant now that
# we've correctly modelled the data. This is good, since I simulated the data without an interaction, so if we 
# had found one, it would have been spurious. 
summary(lmer(performance ~ scale(homework) * scale(teach_experience) + (1 |class), data = example))


# So far we've fitted random intercepts only. How do we model random slopes in R? Again, it's pretty
# straightforward. If you think of the (1|class) parameter as fitting a little regression within each
# class, then we just have to add an effect within that regression, and it will be fit within each class
# too - i.e., as a random slope. That is (1 + homework|class) tells the model to fit a random intercept
# and a random slope for homework, or alternatively, to fit a separate regression with its own intercept
# and slope for homework within each class.

summary(lmer(performance ~ homework +  teach_experience + (1 + homework|class), data = example))

# We can see in the random effects section of the model that we now have a parameter for homework, representing
# the amount of variance, across groups, in the slopes of homework on performance. There's an additional 
# parameter as well, Corr. This is the estimated correlation between the random intercepts and random slopes,
# and is estimated by default when we add a random slope. I'll explain this parameter in more detail, but for
# now, we can tell R not to estimate it (essentially, we set the correlation to zero) by using a double, 
# instead of a single, | in the grouping code - (1 + homework||class)

summary(lmer(performance ~ homework +  teach_experience + (1 + homework||class), data = example))

# Notice that the t value for homework dropped further when we added the random slope parameter. This is 
# because we are modelling uncertainty in the effects of homework. Without a random slope, we are assuming
# that there is one, universal effect of homework, and that each student is contributing independently to
# our estimate of that slope (once we correct for the random intercepts of class). With a random slope in 
# the model, we are instead assuming that the effects of homework can vary, and we're essentially saying
# that we have 30 estimates of what the effect of homework is (one for each class). The more those estimates
# vary, the less certain we are that our mean effect of homework is representative of the true mean. 
