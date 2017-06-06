### Understanding interactions in R ### 

# So far we've only looked at main effects in our analyses. But of course we'll often want to look at 
# interactions. In some fields there's a distinction made between interactions (where categorical variables
# interact) and moderation (between continuous variables). However, in either case, an interaction occurs when
# the effect of one variable changes depending on levels of another variable. 

# In R, because things are unified under the general linear model, we treat interactions involving continuous,
# categorical, or some combination of the two all with the same operator (though with continuous variables
# we'll need to center them, as we'll see later).

# To add an interaction term in R, one way to write things out is to put in your main effects and then add
# an interaction term, specified with a ':' between predictors, without a space. 

# The formula looks like this:
# DV ~ IV1 + IV2 + IV1:IV2

# Remember that you'll need to set your working directory to Week 4 to read this file in. For once, 
# we won't set stringsAsFactors to FALSE, since we want all the string variables to be factors here. 
manylabs <- read.csv('manylabs small.csv')

# Let's run this code, which reverses the levels of the anch1group factor to make them easier to interpret
# in the regression. 

manylabs$anch1group <- factor(manylabs$anch1group, levels = c('low', 'high'))

## Side-note:
# The method I've shown you above let's you specify the order of factor levels exactly. But there is a 
# slightly easier shortcut using the relevel function. This sets the specified factor level to be the 
# baseline, moving other factor levels up. When you just want to switch the reference level of a factor, 
# this may be a little easier. 
manylabs$anch1group <- relevel(manylabs$anch1group, 'low')


# Here we have a simple multiple regression. We're predicting the DV for our anchoring estimates based on 
# the anchoring condition and whether the study was in the lab or online (here, lab is 0 and online is 1).

# Note that I'm now using single-line commands to fit and run models all at once to be more concise. When we
# do it this way, the model isn't saved, and so it has to be re-fit every time we look at the summary. That 
# doesn't matter much for simple regression like this, but time will become a factor when we get to 
# multi-level models and SEM.

summary(lm(anchoring1 ~ anch1group + lab_or_online, data = manylabs))

# You can see that there is a main effect of the anchoring condition but not a main effect of being in the 
# lab. Now let's add the interaction term. This sort of set-up (an interaction between
# categorical variables) would usually be treated as a two-way anova in something like
# SPSS, but in R we don't really need to make those kind of distinctions unless we want
# to (more on that later). 

summary(lm(anchoring1 ~ anch1group + lab_or_online + anch1group:lab_or_online, data = manylabs))

# Here the output has changed a lot. You can see that the interaction term is significant, and the estimate
# is negative. But you'll also notice that the main effect estimates have each changed. This is because
# each of the main effects in regression mean something different once there is an interaction term in the model
# that involves them. 

# You may be used to using simple slopes to visualise simple effects and understand the direction and shape of
# an interaction. But since the linear model is just an equation that we can read and solve, understanding 
# what the regression coefficients in R do under the conditions of an interaction will allow you to mentally
# visualise what interactions are doing without needing to plot them out.

### Regression terms under an interaction
# With an interaction term present in a regression equation, the main effects in that equation represent
# simple effects when all other interaction terms are at 0 (or their baseline level, in the case of categorical
# variables). Remember that in regression, each term represents the effect of that variable holding all other
# variables constant. With an interaction in the model, that is expanded to mean 'holding all other terms at
# zero'. So each main effect estimate has to be interpreted within the context of other variables being at
# their baseline.

# In the case of our current regression output, the way to read the estimates is that the anch1group effect 
# now specifically represents the effect of the anchoring condition (i.e. being in the high anchoring 
# condition versus the low one) when participants are in the lab (remembering that the lab is 0 in the
# lab_or_online variable).

# The lab_or_online variable, in contrast, now represents the effect of being in the online condition when the
# anchoring condition is low (because that is the baseline).

# We can see that lab_or_online is significant and positive, where before it was not significant. This is
# because, in the low anchoring condition, online participants give higher estimates than do lab participants. 
# We'll come back to how to interpret that. 

### Reading the interaction term

# Now let's look at the interaction term itself. It is significant and negative. We can interpret the
# interaction term as the effect of being in both the high anchoring condition and in the online condition, 
# above and beyond either of their individual effects. 

# Looking to the simple effects of anchoring condition, we can see that they are positive - seeing a high
# anchor (in the lab) results in estimates that are, on average, 1299 points higher than seeing a low
# anchor (in the lab). If we want to know what the effects of being in the high anchoring condition are
# for online participants, we simply add the interaction term to the simple effect (1299 - 287 = 1012). This is 
# because the interaction term represents the effect of being in the high condition while also being alone, 
# above and beyond the simple effect of being in the high condition while in the lab. 

# So, for online participants, the high anchor only shifted estimates, on average, 1012 points up, instead of
# 1299 for the lab participants.

# Thus, we can interpret this interaction as the main effect of anchoring being weaker for online participants 
# than it is for lab participants. I.e. a high anchor, compared to a low anchor, increases estimates by a 
# smaller amount for online participants.

# Thus, the reason that lab_or_online becomes significant when the interaction term is added to the model 
# is that online participants give higher estimates than lab participants in the low anchor condition, 
# which is the baseline. And they give lower estimates that lab participants in the high anchor condition,
# which we can confirm by adding the interaction term to the estimate (107 - 287) to get -180. 

# In this case, it makes conceptual sense that lab_or_online wouldn't have a main effect - we wouldn't 
# really expect online participants to just give higher or lower estimates overall, across anchoring 
# conditions. But the interaction reveals that the anchoring effect is weaker online, which does make
# conceptual sense, and is hopefully now clear from reading the regression output. 

### Shortcuts to write interaction terms. 

# We don't have to write out the full model (with main effects and interactions). Because it's almost always
# a good idea to include the main effects in a model with an interaction term, R does this by default if
# we use the '*' operator to specify an interaction instead of the ':' operator. The formula:

# DV ~ IV1*IV2
# Is equivalent to
# DV ~ IV1 + IV2 + IV1*IV2

# You can check the output below and see that the two formulas give identical output. 
summary(lm(anchoring1 ~ anch1group + lab_or_online + anch1group:lab_or_online, data = manylabs))

summary(lm(anchoring1 ~ anch1group*lab_or_online, data = manylabs))

### Two-way anova output

# If you want to look at the traditional output you might be used to from a 
# two-way anova, you can, of course, use the anova command. The anova command
# will break the main effects and interaction down into the variance components. 
# You'll notice that the lab_or_online variable does not explain significant 
# variance here. That's because the anova looks at main effects and the 
# interaction, rather than simple effects, and the main effect of lab_or_online
# is not significant. Notice that from the anova output, we wouldn't be able
# to tell what our interaction looked like, which is why we usually would plot
# simple slopes, if we couldn't now use summary() to figure it out. 
anova(lm(anchoring1 ~ anch1group*lab_or_online, data = manylabs))

### Interactions between continuous and categorical variables

# We've looked at how to run and interpret interactions between categorical variables. When including
# continuous variables in an interaction in R, the syntax is identical, but the interpretation changes
# slightly. 

# Let's take a look at the DV from before (anchoring1) and the same condition code (anch1group). But this time
# we'll look at the interaction with age, a continuous variable.

# The most important thing to remember about continuous variables, as you will know, is that they need to be 
# centered before being input into a interaction if we want to be able to interpret the simple effects. This
# is because, as I mentioned earlier, the simple effects can be thought of as the effect of one variable when
# all the others (including the interaction) are set to zero. When we have centered our continuous variables,
# a 0 on the interaction term reflects continuous variables being set to their means, and so doesn't change
# the interpretation of our simple effects.

# If we haven't centered our continuous variables, a value of zero for the interaction term likely has no
# intelligible meaning, and so our simple effects become uninterpretable - just like the intercept in a 
# standard regression is often uninterpretable when we enter main effects for which zero is not a valid value.

# As we've previously seen, scale() centers variables and standardizes them to have an sd of 1, which is 
# very handy for interpreting interactions. 
manylabs$age.c <- scale(manylabs$age)

# Here we run the regression with the main effects alone first (always a good step before running an
# interaction). We can see that age doesn't have a significant main effect on the outcome. 
summary(lm(anchoring1 ~ anch1group + age.c, data = manylabs))

# Now we run the interaction by adding the '*' parameter, which includes the main effects by default. 
summary(lm(anchoring1 ~ anch1group * age.c, data = manylabs))


# We can see here that, as we did before, we have a significant interaction term, which is negative. We
# know from our previous interpretation that this indicates that the effect of the anchoring manipulation
# is weaker at higher levels of the age.c variable (i.e. older people don't show this effect as strongly). 

# Because we have centered the age variable, the anch1group estimate has not really changed with the 
# addition of the interaction term. This is because when age.c is set to 0, this represents the mean in 
# the dataset (because of our centering) and so the simple effect for anch1group when age.c is zero is
# essentially the same as the main effect of anch1group. 

# Because age.c is centered and has a standard deviation of one, increasing age.c by 1-unit means going up
# one standard deviation. Thus, by adding and subtracting the interaction term from the anch1group term, 
# we can construct 'simple slopes' for the effect of anchor manipulation when age is 1 SD above or below the 
# mean.  

# We do have a double negative here, so you'll need to be careful. Higher age leads to lower estimates, 
# so at +1 SD age we have 1148 - 157 = 991. And at -1 SD of age, we have 1148 + 157 = 1305. Thus, simple
# slopes for the interaction would show that the difference between low and high anchoring is 1305 at 
# low age and 991 at high age. 

# Note that there is one final component to the simple slopes. We've calculated the steepness of the slopes,
# but they also have an intercept. Because there is a positive main effect of age on our DV, the slope for
# the high age group will start off a little higher than the slope for the low age group. Specifically, 
# both lines share the overall model intercept of about 2848, but the high age group adds 56 (to start at
# 2904), and the low age group subtracts 56 (to start at 2794) from that number. 


# For the visual learners among us, the code below adds together the intercept and slope values that we've
# calculated to predict the value of the DV at each combination of age and anchoring group, and then plots
# it in the familiar simple slope form. You can see that the high age group starts out a little higher on
# the dv, but the slopes cross over because the low age group's steeper slope overcomes that initial 
# difference. 

slopes <- data.frame('age' = c('low', 'low', 'high', 'high'), 
                     'anch' = c('low', 'high', 'low', 'high'), 
                     DV = c(2794, 2794+1305, 2848, 2848+991))
slopes$anch <- factor(slopes$anch, levels = c('low', 'high'))

install.packages('ggplot2')
require(ggplot2)

ggplot(slopes, aes(x = anch, y = score, group = age, color = age)) + geom_line()

### Interactions between continuous variables. 

# Let's read in a new mini-dataset to illustrate continuous interactions
grades <- read.csv('Grades.csv')

# Take a look at the dataset
head(grades)

# Notice that all the variable names are capitalized. I prefer my variable names to be in lower-case. 
# This little trick uses the tolower function (that turns things into lower case) to make that change. 
colnames(grades) <- tolower(colnames(grades))

# Credit for the dataset goes to Jeremy Miles (http://www.jeremymiles.co.uk/regressionbook/data/index.html)

# So we have how many classes a student attended, how many books they read, and what their final grade was. 
# These are all continuous variables. Let's create centered versions of the variables and then take a look
# at the main effects. 

grades$attend.c <- scale(grades$attend); grades$books.c <- scale(grades$books)

# We can see that both of the predictors significantly predict grades on their own, as main effects. 
summary(lm(grade ~ attend.c + books.c, data = grades))

# Now we add the interaction term.

summary(lm(grade ~ attend.c * books.c, data = grades))

# Looking at the output, we can see that all three terms are significant. We have a positive interaction 
# term, and each of the main effects is positive. Remember that the simple effects of both attend and books
# are condition on other terms in the model being zero - but because we've centered everything and all 
# our predictors are continuous, that hasn't changed them much. 

# Here, we can interpret the interaction term here as indicating how one simple effect would change when the
# other variable in the interaction increases to 1 SD above its mean. So the simple affect of attendance is
# 5.7 (grades are expected to increase by 5.7 points with a 1SD increase in attendance). Add the interaction
# term (4.5) and we find out that, when the number of books read is 1 SD above the mean, the effect of a 1SD
# increase in attendance on graces goes up to 10.2 (5.7 + 4.5). Essentially, we have an intensifying
# interaction here, where each factor is stronger at higher levels of the other factor.

### The hazards of not centering continuous variables 

# Take a look at the output when we don't center the variables before testing their interaction. Notice
# that the p value for the interaction stays the same, but pretty much everything else changes. This is because
# now we have to interpret each simple effect as being the effect when the other variable in the interaction
# equals zero - actual zero, rather than its mean, because we haven't centered. So we're looking at the estimated
# effect of attendance when the number of books read is zero, and the estimates effects of books when the number
# of classes attended is zero. 
summary(lm(grade ~ attend * books, data = grades))

# If we use table to look at the distribution of attendance, there's no-one in the dataset who came close to 
# attending zero classes, so it's not even really meaningful to look at the simple effects at this level. 
table(grades$attend)

# Interpreting the size of the interaction term (though not its significance) also becomes near-impossible
# in this situation, because it's expressed on the scale of both of the component variables, and because
# the model intercept has shifted to where all variables equal zero. The lesson here is to always remember
# to standardize your continuous variables in an interaction. 

# You can do this with the scale() command within the regression itself, to save time. As you can see, the
# output here is the same as when we used our attend.c and books.c variables.
summary(lm(grade ~ scale(attend) * scale(books), data = grades))

### Extracting model information. 

# Just as most model objects in R will give their expected output when you use summary() on them, many
# model objects will also give you confidence intervals when used with the confint() function. Calling
# confint on a linear model object will give you 95% confidence intervals for all parameters.

model <- lm(grade ~ attend.c * books.c, data = grades)
confint(model)

# The coef command will also directly pull out the regression coefficients, which can be handy for generating
# automated reports:
coef(model)

# You can use the cbind() function (which binds together column variables into a single dataset) to get
# both pieces of output in a handy package. We'll learn more about cbind() and its relatives next week. 

cbind(coef(model), confint(model))

# You can also always use the str() function (structure) to look at all the information that is contained
# within a model object directly in its raw form. This can be useful when you want to pull out just the
# p value, for instance when running simulations. The output to this will generally be pretty ugly. The 
# thing to remember is that (almost) all model objects are really just fancy lists under the surface, often
# with several layers of lists within lists. So you can always pull out the specific information you need
# using the $ operator. 

str(model)


### Exercises

# In the manylabs dataset from Week 4, the iatexp.overall variable represents the extent to which implicit
# attitudes toward art are more positive than toward math. d_art represents the same thing, but measured
# explicitly, with various feeling thermometers. The Nosek et al (2005) paper they were replicating found
# that women had more negative implicit and explicit attitudes toward math than men, and that explicit
# and implicit attitudes were correlated. Let's start by replicating these effects. 

manylabs <- read.csv('Manylabs.csv', stringsAsFactors = FALSE)
colnames(manylabs) <- tolower(colnames(manylabs))

# To begin with, let's use the factor command to set the levels of sex (participant sex) and expgender 
# (experimenter gender). Not only does this let us set the order of levels, but it will also remove 
# any 'other' responses. Without doing that, we may end up with levels in our regression representing only
# a few observations, which will throw everything off. 

manylabs$sex <- factor(manylabs$sex, levels = c('m', 'f'))
manylabs$expgender <- factor(manylabs$expgender, levels = c('male', 'female'))

# 1. Run a simple regression predicting d_art from sex. Interpret the direction of the effect, remembering
#    that the DV represents higher preference for art over math. Does it replicate the Nosek paper? 

# 2. Add the effects of experimenter gender. Are they significant? If so, interpret the direction of the 
#    effect. 

# 3. Test for an interaction between expgender and sex (both factors, so no centering required).
#    Is it significant? 

# 4. Test whether the implicit attitudes variable (iatexp.overall) predicts explicit attitudes (d_art).

# 5. Test whether there is an interaction between iatexp.overall and lab_or_online. Remember that you will
#    need to center the continuous variable here (iatexp.overall). Interpret the direction and significance
#    of the interaction. 

# 6. Test whether age interacts with participant sex to predict d_art. Make sure you center age. Interpret
#    the results