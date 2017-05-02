### Tidy data problem examples

# We'll need a lot of packages for today's session, so run the code below (which will install only the ones
# you haven't already installed) then run all the code in lines 11-12 at once, which will activate the 
# packages.
packages <- c("stringr", "plyr", "dplyr", "reshape2", "tidyr", "ggplot2", "lattice", "lme4", 'lmerTest')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

require(stringr); require(plyr); require(dplyr); require(reshape2); require(tidyr); require(ggplot2) 
require(lattice); require(lme4); require(lmerTest)

### This file is designed for you to follow along with the tidy data talk, but feel free to go through it on
### your own, too. 

# The key guiding principle of tidy data is that each column is a single variable, each row contains all observations
# on a single observational unit, and each cell contains a value for that observational unit on relevant variable. 


# In this exercise, we'll quickly walk through some examples of the four most common violations of tidy data
# principles that make data untidy. These are slightly modified from the tidy data paper in this week's folder to be
# more relevant to us as psychologists. Each problem has a primary tool we can use to fix it. In order, we'll use
# melt(), separate() and unite(), dcast(), and join(). With these functions, alongside what you've already learned and
# a little ingenuity, you'll be able to tackle even the messiest data with ease.

# As always, you'll want to set your working directory to where you have downloaded Week 6, and as in Week 5,
# you'll want to set it to the Data folder within the Week 6 folder. Remember, you can change your working
# directory through the console with setwd(), or you can use the dropdown menus from Session -> Set Working
# Directory -> Choose Directory.

### 1. column headers contain values not (just) variable names.
preg <- read.csv('https://raw.githubusercontent.com/tidyverse/tidyr/master/vignettes/preg.csv', 
                 stringsAsFactors = FALSE)

# This toy dataset is from the tidyr examples set up by Hadley Wickham
preg

# You can see that we have a name column, and two other columns, treatment a and treatment b. But we really only
# have two variables in this dataset - name and treatment type. Just like in the sadness and colour perception
# example from the lecture, we need a variable to represent treatment type if we want to test an interaction.

# To do that we would use melt, which we'll go into in much more detail in the next exercise. You can see that the
# version of the data frame returned by melt fits our definition of tidy data.

preg
melt(preg, id.vars = 'name')

### 2. A single column contains multiple variables
participant <- read.csv('participants.csv', stringsAsFactors = FALSE)

participant

# This is a situation we can often find with demographic variables. We have two variables (participant ID and 
# day of testing) in a single column. 

# separate is our function to resolve this issue. Notice how the resulting dataset has a separate column for pid
# and day, replacing the 'part' column. 
participant <- separate(participant, part, into = c('pid', 'day'))
participant


# Sometimes we have the opposite problem - a single variable is spread across multiple columns. Perhaps we have the 
# Day, hour, and minutes of a daily diary observation, but we want to turn it into a single 'time' column. For this,
# we can use the unite function, which does the exact opposite of separate (taking multiple columns and combining
# them into a single column)

# Let's cook up some birth dates for our imaginary participants, but we'll
# recorded separately in century and year. We can use unite to bring them into a 
# simple birth year column. 

participant$century <- c('19', '20', '19', '19', '20', '19')
participant$year <- c('89', '02', '93', '96', '04', '91')

participant <- unite(participant, col = birthyear, century, year, sep = '')
participant


### 3. Variables are contained in rows

weather <- read.csv('weather data.csv', stringsAsFactors = FALSE)
head(weather)

# Here, we have an example of problem number 3 - variables are contained in rows. Specifically, the element variable
# contains TMAX and TMIN (the temperature max and temperature min). This can conceptually be thought of as the opposite
# problem to number 2, as we have variables in a row instead of a column header (where that problem was having values
# in column headers instead of in a row). Consequently, as we'll see, the functions to fix this problem do the opposite 
# thing to the functions to fix problem 1. 

# There is some subjectivity here, however. Whether this is a problem really depends on what we want to do with the data. 
# If we wanted to test whether the value of temperature is moderated by whether we're looking at the max or minimum, 
# this would be the correct format to do it. But we're more likely to want to use TMAX and TMIN as separate variables, 
# perhaps calculating a mid-point temperature between them. And for that, we need them in to be column headers for
# the data to count as tidy. 

dcast(weather, id + year + month ~ element)

# In my experience, it will probably be rare that you receive data that has problem 3 inherently. But very often in the
# process of resolving problems 1 and 2, we will end up with data that have this problem, and have to subsequently
# resolve it.


### 4. Observations about a single unit are kepts across multiple data frames.

# This problem often occurs when dealing with complicated studies - we might have codebooks that have participant
# demographics, then a separate data file for our actual measurements. Or we might have separate data files for 
# different parts of a study. To resolve this sort of problem, we need to make sure we have an identifier variable
# in each data set that can be used to join the data sets together.

demo <- read.csv('moral demographics.csv', stringsAsFactors = FALSE)
outcomes <- read.csv('moral outcomes.csv', stringsAsFactors = FALSE)

head(demo)
head(outcomes)

# As you can see, the demo data frame contains some basic demographic information on four named participants (don't
# worry, the names are made up, this isn't a terrifying breach of confidentiality). The outcomes data frame contains
# some scores on two of the five moral foundations (harm and fairness) for these same participants. To make the data
# tidy, we want all the information for one observational unit to be in one data frame. The join function does this
# (it works a bit like merge in SPSS). It will automatically find columns that both data frames have in common and 
# join them together using those to match rows.

join(demo, outcomes)

