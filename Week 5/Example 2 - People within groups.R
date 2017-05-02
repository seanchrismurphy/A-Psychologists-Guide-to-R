### People within groups ###

# Having walked through a practice example with the simulated class homework data, let's walk through a 
# similar example, but using real data. 

# In this case, we'll use some data on exam performance from the centre for
# multilevel modelling at the University of Bristol. This data was made available for teaching purposes
# (http://www.bristol.ac.uk/cmm/learning/support/datasets/)

london <- read.csv('london exam records.csv', stringsAsFactors = FALSE)

# This dataset consists of exam records from a number of london schools, between the years 1985 and 1987.
# There is a school variable, which codes for school identity. There are a number of individual-level 
# variables, including Exam score (the DV), female (a gender code where 1 = female), VR band (1-3 categorical,
# where 1 is the best), ethnic (a categorical code for ethnic group). There are also several school-level
# variables - perc.free.meals, the percentage of students qualifying for free meals, perc.vr.band, the 
# percentage of students in the 1st (best) vr band, school.gender (mixed, female or male) and school.denom
# (a categorical coding for religion)

head(london)

### Exercises

# 1. Fit a normal lm model looking at the effect of VR.band.student on exam, the DV. Interpret the direction
#    and significance of the effect, remembering that VR band is coded such that lower scores are better.
summary(lm(exam ~ VR.band.student, data = london))

# 2. Now add a random intercept term for school to the model. Does the significance of the VR band effect 
#    change? Is the change different to what it was in our example? Not all multilevel models change the
#    precision of our estimates in the same way, as we'll see when we come to repeated measures. 

summary(lmer(exam ~ 1 + VR.band.student + (1 |school), data = london))

# 3. Fit an empty multilevel model with a random intercept for school, predicting the exam scores. How much
#    variance is at the school level? 

# 4. Standardize the exam variable, then fit the model again to get a better idea. 

# 5. Fit a model with the level 1 predictor (VR.band.student) and the level 2 predictor (perc.vr.band). 
#    Are they both significant? Remember that the school level predictor is coded such that higher scores 
#    mean more students in the lowest (best) band. Interpret the coefficients.

# 6. Can you think of a reason why the t value for perc.vr.band is so much smaller than the t value for 
#    vr.band.student?

# 7. Remembering to scale your predictors, fit a cross-level interaction of the student and school level
#    VR band variables, while modelling a random intercept for school. Interpret the interaction (this
#    may take some mental gymnastics to reverse the coefficients properly)

# 8. Remove the interaction from the model for a moment, and return to just using VR.band.student as a 
#    predictor. Add a random slope of VR.band.student to the model, using the || syntax we looked at 
#    in example 1. How does the significant of the VR.band.student parameter change? Why is this? 

###  If you save your model from Example 8 as model.8, then run confint on it, it will show that the random slope of
###  VR.band.student was significant (the confidence interval for the variance does not include zero). Confint output
###  for lmer can be a bit confusing - The first parameters will be the variance estimates for random effects - in this
###  case, sig01 and sig02 are the estimated standard devation for the random intercept and random slope. If these don't
###  include zero, the model is estimating that there is significant variance in these parameters. Sigma is the residual
###  variance (which we almost never care about), then we have the fixed effects, starting with our estimated overall
###  intercept, and the estimated slope of VR.band.student.
confint(exercise.8.model)

# 9. So this means that there is significant variation in the effect of student VR.band on exam performance across
#    schools. Why might that be? Does the result of example 7 give you any ideas?

# 10. Fit a random intercept model predicting exam with the categorical predictor school.gender. Look at 
#     levels(london$school.gender) to figure out what the baseline level is, and interpret what this 
#     coefficient means. 

# 11. Add female (the student level gender predictor) to the model. How have the coefficients of school.gender
#     changed? What does this mean? 

# 12. Add a random slope for female to the model and examine the output.

# 13. Would it make sense to add a random slope for school.gender within the school grouping factor? If not, 
#     why not? 