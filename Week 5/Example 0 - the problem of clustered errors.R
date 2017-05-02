# Here we will use R to simulate some data, to show the pitfalls of ignoring clustered errors. 

# First we create a list called outcome, which will hold the result of each simulation. 
outcome <- list()

# We run a for loop, simulating the data 1000 times. 
for (i in 1:1000) {
  
  # We create a data frame where each individual is a member of a group of 30. Each group has some clustering
  # on the IV and the DV, represented by group_IV_error and group_DV_error. This represents participants within
  # the groups being more similar on these traits than they would be otherwise. 
  individual <- data.frame(groupcode = rep(1:30, each = 30), group_IV_error = rep(rnorm(30), each = 30),
                           group_DV_error = rep(rnorm(30), each = 30))
  
  # Now each individual is given their own score on the IV and the DV - this consists of their person-level
  # error, and the group-level error.
  individual$IV <- rnorm(900) + individual$group_IV_error
  individual$DV <- rnorm(900) + individual$group_DV_error 
  
  # Notice that we haven't simulated any link between the IV and the DV. The true value of the relationship
  # is zero. This is a good way to test whether a statistical model is giving the correct error rate. In theory,
  # only 5% of our p values should be below .05. 
  summary(lm(DV ~ IV, data = individual))
  
  # At the end of each loop, we fit a model and save the p value for IV.
  outcome[[i]] <- (summary(lm(DV ~ IV, data = individual))$coefficients["IV", 4])
}

# Now we take out p values out of list format and into a single vector using the unlist command
outcome <- unlist(outcome)

# We can use table to check the percentage of our p values that are less than .05. You should see that
# around 50% of the p values are less than .05, despite our null true effect. This corresponds to a 50%
# false positive rate.
table(outcome < .05)


require(ggplot2)

# We can also plot the p values to get a visual feel for this effect. 
qplot(outcome)


# Why does this happen? Well, because participants are clustered into groups, and share group-level errors.
# since there are only 30 group level errors for IV and DV in each simulation, it's easy for there to be
# a small spurious trend at the group level. Of course, since the N in that group-level regression would be
# 30, a regression that could see this would discount it. However, when we do a standard regression at level
# 1 and ignore the clustering, the model can't see those 30 shared errors, and instead sees 900 independent
# errors. If they mostly trend in the same direction (because of the shared group errors) the model will see it
# as unlikely and incorrectly reject Ho. 


# To address this problem, we can fit a multilevel model using lme4. Install the lme4 package if you haven't
# already, and load it with require. 
require(lme4)

# We'll also want to install and load lmerTest, which adds p values to lmer output (they're not printed 
# by default for fairly high-level reasons, which I'll discuss in class). 
install.packages('lmerTest')
require(lmerTest)

outcome2 <- list()

# We run a for loop, simulating the data 100 times - it takes longer to run multilevel models, since they're more
# complicated.
for (i in 1:100) {
  
  # We create a data frame where each individual is a member of a group of 30. Each group has some clustering
  # on the IV and the DV, represented by group_IV_error and group_DV_error. This represents participants within
  # the groups being more similar on these traits than they would be otherwise. 
  individual <- data.frame(groupcode = rep(1:30, each = 30), group_IV_error = rep(rnorm(30), each = 30),
                           group_DV_error = rep(rnorm(30), each = 30))
  
  # Now each individual is given their own score on the IV and the DV - this consists of their person-level
  # error, and the group-level error.
  individual$IV <- rnorm(900) + individual$group_IV_error
  individual$DV <- rnorm(900) + individual$group_DV_error 
  
  # Notice that we haven't simulated any link between the IV and the DV. The true value of the relationship
  # is zero. This is a good way to test whether a statistical model is giving the correct error rate. In theory,
  # only 5% of our p values should be below .05. 
  summary(lm(DV ~ IV, data = individual))
  
  # At the end of each loop, we fit a model and save the p value for IV. Here, instead of a linear model, 
  # we're properly fitting a multilevel model. 
  outcome2[[i]] <- coef(summary(lmer(DV ~ IV + (1|groupcode), data = individual)))['IV', 5]
}

# Now we take out p values out of list format and into a single vector using the unlist command
outcome2 <- unlist(outcome2)

# You should see that only 5% of the p values are now below .05, as it should be. 
table(outcome2 < .05)

# We can also plot the p values to get a visual feel for this effect. 
qplot(outcome2)