### Basic subsetting on data frames

# Let's look at the iris dataset, which contains measurements of flowers. The iris dataset is built into R
# and so we don't need to read it in like we will in future weeks with other datasets. 

# For this problem set, you'll want to know the functions max() and min(), which find the largest and smallest
# values in a vector, respectively. You'll also want to know which.max and which.min, functions that
# find the location of the smallest or largest values, rather than the values themselves. 

a <- c(1, 4, 6, 10, 23, 100, 3, 4, 6, 1)

min(a)
max(a)

b <- c(1, 2, 3, 4, 0, 10)
which.min(b)
which.max(b)

# which.min and which.max are useful in subsetting to find, for example, the row that holds the value
# you are looking for.
b[which.min(b)]

# Take a look at the iris data. This data was used by Fisher in a seminal 1936 paper on using multiple 
# measurements to separate species (which you can see if you type help(iris))

iris
head(iris)

# A reminder - to get one column of the iris dataset, we can use its name, or a number
iris[, 'Sepal.Width']
iris[, 2]

# Now, for some of these problems, you'll need to combine logical subsetting with max and min to 
# get the answer. See if you can work it out.

# 1. What is the longest Petal Length in the dataset?
max(iris$Petal.Length)
max(iris[, 'Petal.Length'])

# 2. What is the longest Petal Length among flowers of the setosa species? 
max(iris$Petal.Length[iris$Species == 'setosa'])
max(iris[iris$Species == 'setosa', 'Petal.Length'])

# 3. Which row contains the flower with the longest Petal Length?
which.max(iris$Petal.Length)

which.max(iris[, 'Petal.Length'])

## Hint - use which.max here.

## You could also to combine regular max with logical subsetting to solve this one, e.g.:
iris[iris$Sepal.Length > 2, ]

# 4. What species is the flower with the smallest Sepal Length?
iris[, which.min(iris[, 'Sepal.Length']), 'Species']

iris$Species[which.min(iris$Sepal.Length)]

# 5. What is the Sepal Width of the flower with the greatest Petal Length?

iris[which.max(iris$Petal.Length), 'Sepal.Width']
iris$Sepal.Width[which.max(iris$Petal.Length)]

# The table() command is very useful. It takes a variable and gives frequencies of each response to that
# variable. For instance:
pets <- c('cat', 'cat', 'cat', 'dog', 'dog')
table(pets)

# The table command will also give frequencies of TRUE/FALSE values if used on a valid logical test, 
# see below:
numbers <- c(1, 2, 3, 4, 5)
table(numbers > 2)

# The table command will be useful for problems 6 and 7

# 6. How many flowers have a Sepal Length greater than 5?
table(iris$Sepal.Length > 5)
table(iris[, 'Sepal.Length'] > 5)

# 7. How many flowers of each species are there?
table(iris$Species)

# For problem six, if you're having trouble, try combining table with a logical test like: 
iris[, 'Sepal.Length'] > 5


# 8. Is the mean of the Petal Length of setosa flowers greater than the mean of the Petal Length of versicolor
#    flowers?

mean(iris$Petal.Length[iris$Species == 'setosa']) > mean(iris$Petal.Length[iris$Species == 'versicolor'])

mean(iris[iris$Species == 'setosa', 'Petal.Length']) > mean(iris[iris$Species == 'versicolor', 'Petal.Length'])

## Hint - You can subset both before and after the comma to specify both a specific set of rows and a 
## specific set of columns
iris[iris$Species == 'versicolor', 'Petal.Length']

# 9. Use the sd command to find the standard deviation of the Sepal Width for all flowers
sd(iris$Sepal.Width)

# 10. Find the sd of each species separately. It is higher or lower?
sd(iris$Sepal.Width[iris$Species == 'setosa']); sd(iris$Sepal.Width[iris$Species == 'versicolor'])
sd(iris$Sepal.Width[iris$Species == 'virginica'])

# Note, of course, that there are more efficient ways to solve problem 10 in R - I don't want you to think
# you'll always be writing out long strings of code like that. While we won't learn about tapply and functions
# like it until later in the course, here's an example of a more efficient way to answer the question. 
tapply(iris$Sepal.Width, iris$Species, sd)

# 11. Among flowers of the versicolor and virginica species only, what is the smallest petal length?

min(iris$Petal.Length[iris$Species == 'versicolor'|iris$Species == 'virginica'])
min(iris[iris$Species == 'versicolor'|iris$Species == 'virginica', 'Petal.Length'])

min(iris[iris$Species %in% c('versicolor', 'virginica'), 'Petal.Length'])

# For problem 11, to avoid errors, it's important to know that == doesn't work like you might think it does in
# this case. if you try to test whether the species == c('versicolor', 'virginica'), R will recycling that
# length 2 vector to test against the entire dataset. That means it will test whether the first row of the
# dataset is versicolor, and the second row is virginica, and so on.

# To properly perform a test like this, one option is to use the OR command that we learned. species ==
# 'versicolor' | species == 'virginica'. The other option, useful if we're testing many categories, is to use
# the %in% operator. This tests, for each element on the left, whether there is a match anywhere within the
# vector on the right. So iris[, 'species'] %in% c('versicolor', 'virginica') will correctly test, for each
# row, whether the species is any of versicolor or virginica.