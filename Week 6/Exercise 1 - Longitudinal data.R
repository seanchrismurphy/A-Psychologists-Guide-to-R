### Longitudinal data analysis


# Simple growth models

# A simple, or unconditional, growth model, is simply a model of overall change over time. In these models,
# time is our only IV, and we're simply interested in how the DV changes over time, on average. For instance,
# let's say we wanted to examine the change in height over time for adolescent boys (in this case we have
# a model of literal growth, though of course that's not necessary to be running a growth model).

height <- read.csv('boys height data over time.csv', stringsAsFactors = FALSE)

# Examining the data, we can see that we have multiple observations for each student, on nine time points. 
# We can also see that the first time point is coded as negative 1 (-1). As mentioned in the talk on 
# centering, we want to have our first timepoint set to zero (0) so that it becomes out intercept, making
# for easier interpretation. We can easily fix this. 
head(height)
table(height$time)

height$time <- height$time + 1

# Now running an unconditional growth model is rather simple. We simply need to require lme4, then fit
# essentially the same model we did for Repeated Measures Anova last week, except instead of an experimental
# manipulation, our predictor is time. Note that both a within-subjects experiment and a growth model like
# this have their IV (manipulation or time) varying completely within-subjects, and so multilevel modeling
# will boost our power to detect a real effect by removing participant-level variance from the model. Also,
# because we have a within-subjects IV here, we don't need to worry about group-mean centering.

require(lme4)

model.1 <- lmer(height ~ time + (1|student), data = height)
summary(model.1)

# As a reminder from last week, this model predicts height from the time variable, while fitting a random
# intercept for each student (essentially, accounting for their mean differences on height, or the clustering
# of height observations within an individual). The intercept will be the mean value of height for all students
# when time = 0, i.e. our first timepoint. We can see that mean height at the first timepoint was 142.98 cm. 

# The time coefficient is the expected increase in the DV for each 1-unit increase in time. In our case, 
# each 1-unit increase in time is expected to increase height by 1.63 cm. If our timepoints were a year 
# apart, this would be a growth rate of 1.63 per year (and similarly, if they were taken three months 
# apart, it would be 1.63 cm per three months). 

# With 9 timepoints, and so N-1 = 8 opportunities to grow, this means that from the first observation to the
# last, the average boy grew 8*1.63 = ~13cm.

# Remember from last week that apart from random intercepts, we can also fit random slopes to our data. Where
# random intercepts allow for differences in the mean height between students, random slopes allow for differences
# in the slope of time affecting height. Thus, adding a random slope would allow the rate of growth to vary 
# across boys, with some growing faster than others. 

# We fit a random intercept model to time like this:
model.2 <- lmer(height ~ time + (1 + time|student), data = height)

summary(model.2)
summary(model.1)

# You should notice a few differences between model 1 and model 2. The T value for height has dropped from 49
# to 19. Remember that when we estimate an effect without random slopes, we are assuming that there is one
# true value for our effect - in this case the effect of time on height - and that that effect is the same for
# each group (boy). Or, in other words, without random slopes, we assume that all boys grow at the same rate,
# and thus we can simply examine the growth rate of the entire sample without assuming there is any clustering
# in the slopes. We are treating each observation as an independent estimate of the true rate of growth.

# When we model random slopes, we allow for the idea that while there will be a mean rate of growth (1.63), 
# each boy might grow at a rate varying from this mean, and observations within each boy are estimating that 
# particular growth rate (and are thus clustered, introducing dependencies). Thus, with random slopes, the 
# growth rates of each boy are calculated and then used to infer the mean growth rate. The t value is lower 
# because we are now telling the model that we have 26 observations of the rate of growth of boys (that's the 
# number of boys in the sample) with which it can infer the mean growth rate. Without random slopes, it 
# assumes it has 234 independent observations of the growth rate of boys - it's similar to telling the model 
# that for the purposes of growth rate, it should act as if we'd sampled 234 different boys once each at 
# various time-points. Obviously this isn't something we should assume. 

# The only time when random slopes can be ignored is if there truly was no variation in our effect - if all
# boys really did grow at exactly the same rate, then 234 observations from 26 boys would be just as informative
# as 234 observations from 234 boys. We can test this empirically by using the anova command on our models.
# When applied to nested models (i.e., models where one is just like the other but with extra terms), the 
# anova command computes the chi square difference test, telling us if our added parameters improve our model
# fit enough to justify the complexity they add to the model. The command to test our models with and without
# random slopes is quite simple:

anova(model.1, model.2)

# The anova is highly significant, indicating that random slopes definitely improved the fit of the model. It
# would be incorrect to ignore them and assume equivalent growth rates. 


# With the lattice package, we can directly take a look at the random effects estimated by our models. 
require(lattice)

# The ranef function extracts the random effects from a lmer model in R, and dotplot plots them nicely
# for us. 
dotplot(ranef(model.2))

# Running the command below, you should see two plots appear under the heading 'student'. These show the
# random intercepts (under (Intercept)) and the random slope for time (under time) for each student. 
# Notice that the random slopes seem to vary a lot less than the random intercepts. This is usually the case,
# in it makes sense if you think about it. The random intercepts tell us that the tallest students at
# time 0 were about 10cm taller than the mean, and the shortest student about 15 cm shorter than the mean. 
# If the slopes of time varied nearly that much, it would mean that some boys were growing 10cm per time unit faster
# or slower than others, which seems obviously unlikely. 

# In fact, the random slopes vary by, at most, about .7cm, as you can see if you examine ranef directly. 

ranef(model.2)

# Since we have 9 timepoints, that means that the cumulative effect of those deviations in the effect of time
# would be (9-1)*.7, or 5.6 cm. So the fastest growing boy grew about 18.6 cm instead of 13, and the slowest
# growing boy grew about 7.4 cm. 



### Conditional growth models

# While unconditional growth models can be interesting in some cases, usually when psychologists are interested
# in longitudinal data they want to examine conditional growth models. Conditional growth models are when we 
# ask whether the rate of change over time depends on some other variable - technically, we're looking at interactions
# of variables with time. 

# This might mean that we have participants in either a control group or an experimental group, and we want to 
# know if the experimental group changes more or less over time. This makes sense if our DV is some kind of 
# adjustment measure. 

# Alternatively, we might have an observational dataset measuring people's attitudes toward some group over
# time, and want to see if the change in attitudes depends on some other individual difference measure. 

# In the first case, group-centering won't be a problem, because our IV (experimental manipulation) is at level
# 2 (the person level). We can just leave it coded as a categorical variable (factor) and be done with it. Let's
# start with that case, then.

### Condition growth models - intervention style data

coping <- read.csv('Coping intervention over time.csv', 
                   stringsAsFactors = FALSE)

head(coping)

# Here we have a simple dataset (courtesy of Amy Mitchell at UQ). It measures the effect of a care as usual
# (0) versus parenting intervention (1) on the parenting style scores (higher = better) of parents of children with medical
# problems. There are three timepoints (0, 1, 2) which represent baseline, immediately post-intervention, 
# and then a six-month followup. 

# The key questions in this data would be - is adjustment (pstotal) getting better over time? And further,
# is it getting better faster in the intervention condition rather than the control condition?

# First, since our DV doesn't really have meaningful units (as we did in the height data), we
# probably want to scale() it so we know the effects of time in standard deviations.
coping$pstotal <- scale(coping$pstotal)

model.1 <- (lmer(pstotal ~ time + (1|participantid), data = coping))

summary(model.1)

# Here we can see that the answer to the first question is, yes - the average participant is getting
# better over time. Specifically, across each timepoint, participants are, on average, improving by 
# a quarter of a standard deviation. 


# Now, before we test for an effect of our intervention, we could model random slopes for time, to see
# how much variability there is in the improvement rates of participants. If participants don't vary at 
# all in their rates of improvement, it probably means our intervention hasn't had an effect, since if it had,
# you'd expect intervention participants to be different from control participants. 

model.2 <- (lmer(pstotal ~ time + (1 + time||participantid), data = coping))

anova(model.1, model.2)

# The anova indicates that this model represents only a marginally significant improvement in fit, indicating
# that there's probably not too much variance in the slopes of time. But a null result isn't proof of no
# variance (just like a high p value doesn't prove a lack of effect). It may just mean the model doesn't 
# have enough data to exclude zero as a possible value for the slope variability. Because a fixed effect
# like intervention condition gives the model more information, it's still possible that our intervention has had an 
# effect, which we can now test directly. 

model.3 <- (lmer(pstotal ~ time*condition + (1 + time||participantid), data = coping))

summary(model.3)

# You should be able to see that the interaction term in model.3 is highly significant. Note that what we
# have done here is technically a cross-level interaction between time (level 1) and condition (level 2). 
# Remember that the regression estimates for time and condition are now simple effects. This means time
# is the average improvement over time when condition = 0, so it's the growth rate for the control condition.
# This slope is still significant - the control group -is- improving. The time:condition interaction 
# simply indicates that the intervention group is improving more rapidly. The control group improves at about
# .15 SD per time point, while the intervention group improves as .15+.23 = .38 SD per time point. The simple
# effect of condition, because we have centered time at 0, represents the difference between the two conditions
# at the baseline measure. As we would hope if random assignment had worked, the effect here is zero. The
# simple effects are why centering time is so important - if we had mean-centered time, so that instead of
# 0, 1, 2, it was -1, 0, 1, then the simple effect of condition would be for the second timepoint, which 
# would be misleading, since the intervention would have already taken place. 

### Condition growth models - individual differences data

# Now we'll read in a dataset that we can use to test several longitudinal models

support <- read.csv('social support intervention.csv', stringsAsFactors = FALSE)

# This dataset contains observations on 112 individuals with an eating disorder, across 5 timepoints each. 
# All individuals were taking part in a support group interventions, and the support variable indicates
# how 'close' they felt to the other members of their support group (who also had eating disordered problems).

# With datasets like this, using the table command can help get a grasp on our number of individual and
# timepoints. The length command will tell us how long the table is, telling us, for instance, how many 
# individuals are in the dataset. 

table(support$pid)
length(table(support$pid))

table(support$time)

table(support$pid, support$time)

# We can see that the time variable is already appropriately centered so that the first timepoint is zero.
# Remember that this is important when testing cross level interactions. 

# Now, in this dataset our key IV (support) varies both within individuals (across time) and between individuals
# (mean levels differ). That means we can't just grand mean center our IV, we need to group-mean center it. 
# To do this, we can use the aggregate() function, which we've seen before. We give aggregate a formula
# telling it that we want the mean of a certain variable (connection) by a grouping variable (pid). This 
# creates a new data frame with the participant IDs and the means on connection. 

support.mean <- aggregate(connection ~ pid, data = support, FUN = mean, na.rm = TRUE)
head(support.mean)

# However, we've run into tidy data problem #4 - we now have our data split across two datasets. We'll want
# to use join to bring them back together. However, join will match data frames on all the variable names
# they have in common, and right now both the support and support.mean data frames have a 'connection'
# variable. We'll want to give a new name to the support.mean version before we can join them. 

colnames(support.mean)[2] <- 'mean_connection'
support <- join(support, support.mean)

# We now have a column in support that gives us the mean value on connection for each person, an essential
# step in group-mean centering. 
head(support)

# The ave() function does a similar thing without needing to join datasets together, but it's a little more
# complicated to set up, so I will leave it for you to explore at a later date.
support$mean_connection <- ave(support$connection, support$pid, FUN = function(x) mean(x, na.rm = TRUE))

# Now let's center our connection variable within group. This is quite easy now - we just subtract the 
# mean_connection variable
support$connection.c <- support$connection - support$mean_connection


### Conditional growth model with individual differences

# Now we've set our data up enough to test a conditional growth model. This is conceptually the same as 
# what we did with the Asthma data. There, our level 2 IV was an experimental condition, here it is an
# individual difference measure. We'll use the mean_connection variable we calculated to test whether
# individuals with a high level of connection to their group across the study improve more in adjustment.

# We'll want to grand mean center group_connection, since it's a level 2 predictor
support$mean_connection <- scale(support$mean_connection)


# First, let's fit the unconditional growth model. This shows us that, on average, everyone in the study
# is improving over time. This is encouraging, since everyone is in the intervention in this case. 
model.1 <- lmer(adjustment ~ time + (1|pid), data = support)
summary(model.1)

# Now we add the main effect of mean connection. It's not doing much so far, meaning that overall (across
# the five timepoints, taking them equally) people with higher connection weren't better off. 
model.2 <- lmer(adjustment ~ time + mean_connection + (1|pid), data = support)
summary(model.2)

# Now we fit the key interaction, making sure to grand mean center mean_connection (since it's a level 2
# predictor)
model.3 <- lmer(adjustment ~ time * mean_connection + (1|pid), data = support)
summary(model.3)

# This is an interesting interaction! We can see, from the simple effects, that people high in mean_connection
# were actually worse off (-.35) at time 1 - remember that we have centered time so that the intercept (0)
# represents the first timepoint. This is precisely why - we want to interpret pre-study differences. 

# The interaction term, though, indicates that these people high in mean connection improved more rapidly
# over the course of the study. We can add the coefficients (-.35 * (T-1)*.13) to intuit that by the fourth
# timepoint, these high connection individuals had caught up with the others, and by the fifth timepoint
# had likely exceeded them (though we'd need to check simple effects to know for sure). 

# How can we interpret this? Well, it's difficult to know for sure, but it's possible that people who were
# suffering more at time 1 felt the need for the intervention more, and thus identified more with their
# support group. They then proceeded to improve at a faster rate.

### Within-person effects
# One way we can investigate whether connection plays a key role here is to look at the within-person effects
# of connection. This will tell us whether, when people were feeling higher in connection, they were also
# feeling higher in adjustment. 

# This model is really very simple. We've already calculated connection, centered within person. We can use
# it to predict adjustment. We can see from the model summary that connection.c is strongly associated with
# adjustment - when people are higher in connection, they tend to be higher in adjustment. Remember, this
# within-person trend is, theoretically, completely separable from the between person trend we saw previously.
# There, -people- higher in connection tended to be -less- adjusted, at least at time 1. 
model.4 <- lmer(adjustment ~ connection.c + (1|pid), data = support)
summary(model.4)


# Before we over-interpret this, however, we should control for the effects of time. Since everyone is improving
# through the study, it's possible that both connection and adjustment are going up over time, explained by
# some third variable (such as a placebo effect). Let's take a look at that possibility:

model.5 <- lmer(adjustment ~ connection.c + time + (1|pid), data = support)
summary(model.5)

# From this model, we can see that once we control for the effects of time (that is, everyone is getting
# better over time) there is no longer an effect of connection within-person. This suggests that both 
# connection and adjustment are increasing over the course of the study, but perhaps because of a third
# variable, or for completely different reasons. 

# So by looking at the data at two levels (with a condition growth model of between-person differences, 
# and a within-person model), we've uncovered more of the story than we could have gotten looking at either
# level alone, highlighting the value of MLM. 


### Exercises

abort <- read.csv('abortion attitudes data over time.csv', stringsAsFactors = FALSE)

# This dataset (from the Center for Multilevel Modelling at the University of Bristol) tracks attitudes
# toward abortion across time. The abortion_support variable (from 1 to 7) is coded positively for support
# to abortion. the time variable is year (0-3) and we also have gender and athiest codes. The respondent
# column is our person ID variable (the variable we'll want to group on with lmer)

# 1. Fit an unconditional growth model to the data, examining the overall change in abortion support over time

# 2. Fit a conditional growth model to the data, examining whether abortion support rises differently over
#    time for females

# 3. Fit a conditional growth model to the data, examining whether abortion support rises differently over
#    time for athiests

# 4. Fit a your unconditional growth model as model.1, then add a random slope for year and fit that as model.2
#    use anova to compare them. Does the model indicate that there is significant variation in the change in 
#    abortion support over time? 

# 5. Can you think of how this gels with your results for exercise 3? Hint: try table(abortion$athiest)