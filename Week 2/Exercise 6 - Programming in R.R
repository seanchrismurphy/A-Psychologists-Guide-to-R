### Basic programming in R ###

# Now that we've learned a lot about the objects that R uses, and how functions work on those objects, we're
# going to start delving a little deeper into programming with R. The goal here is to get familiar with the
# basic concepts of programming so we have a good idea of what's possible and how things work.


## Loops ##

# One of the most basic principles in programming is a loop. This is basically a way to tell the computer to
# do something a certain number of times - perhaps with a different input each time. Loops are how we read
# in multiple files all at once, run simulations, or do something to every row in a dataset.

# Two basic loop types are the While loop and the For loop. A While loop continues running as long as a 
# specific condition is true. A For loop runs a set amount of times, once for every input. 

# Let's take a look at a basic While loop. This code tells R to keep running the contents of the loop ( 
# everything between the { and } curly braces) as long as i is less than 100. If you select and run the code
# above, you'll notice that i appears in your Environment window with the value 100. 

i <- 0
while (i < 100) {
  i <- i + 1
}

# Here's another simple loop. Here we print the values of j each time the loop runs, which will continue
# as long as j does not equal 11. 

j <- 1
while (j != 11) {
  print(j)
  j <- j + 2
}

# Notice that the condition always goes in normal brackets after the while command - e.g. (i < 100). The
# curly braces { and } define what is inside the loop - everything between them gets run with every loop. 

# This is why we have to create the starting value of j (j <- 1) before we start the loop. If we put it inside
# the loop, it would reset the value of j every time the loop ran, which would make it never-ending. That
# kind of never-ending loop will cause R to freeze up, since it will just run it forever. If you find you've
# made that kind of mistake, hit the red 'stop' sign that appears above the console window. 

# Of course, we can also use a while loop to make R print something generic a certain number of times:

i <- 0
while (i < 5) {
  print('hello')
  i <- i + 1
}

# Now let's take a look at a simple For loop. A For loop looks similar to a While loop, but here instead of
# a logical test, we have (i in 1:10) within the normal brackets. In human-speak, this is essentially saying
# "work through the vector 1:10, with i becoming each value in that vector in turn, and run the contents of
# the loop each time." So a For loop lets us run some code with a different input each time. 

for (i in 1:10) {
  print(i)
}

# Because i takes on the values of the object that comes after 'in', it doesn't have to be a number (though
# in most cases it will be). See the following:

alphabet <- c('a', 'b', 'c', 'd', 'e')

for (i in alphabet) {
  print(i)
}

# More commonly, if we wanted to do something like the above, we'd use numbers and subsetting, like below. 
# Because i takes on each number in turn, when we use it to subset something within a loop, we'll get a 
# different result each time the loop runs. 

for (i in 1:5) {
  print(alphabet[i])
}

# There are a few new functions that can be helpful when working with loops. One is the paste function, 
# which puts together different objects into a string. We can use this when we want to print something
# represented by a variable (like i) along with a set string, like below: 

for (i in 1:5) {
  message <- paste(i, 'is a number')
  print(message)
}

# Paste works with any number of variables and bits of strings, as long as they're each separated by a 
# comma. It's a lot like c() in that way. 


## Exercises
# 1. Write a while loop that prints the square root of the numbers 1:10. (Remember the sqrt() function)

# 2. Write a for loop that does the same thing.



## Conditionals ##

# Conditionals are like switches that change what a program does depending on whether a certain test comes
# out TRUE or FALSE. Statements of the form "If X then y" constitute conditional statements. We can use
# conditional statements to add complexity to the loops we write, having them do one thing in one case, and
# a different thing in another case. 

# For example, the following code tells R to print a statement if the test (a > 2) returns TRUE. 

a <- 4
if (a > 2) {
  print('a is bigger than 2')
}

# If we change the value of a and run it again, nothing happens, because the statement isn't TRUE. 

a <- 1
if (a > 2) {
  print('a is bigger than 2')
} 

# We can use the else keyword to make sure R says something appropriate if our first condition isn't met. 

if (a > 2) {
  print('a is bigger than 2')
} else {
  print('a is smaller than 2')
}

# Note that R is very finicky about the placement of curly braces in programming like this. The first curly
# brace needs to come immediately after the condition (a > 2). The else command needs to be written on the
# same line as the initial closing curly brace (see above) and the second curly brace needs to come 
# just after else. 


# We can combine conditionals with loops to make a loop that prints different statements depending on the 
# input:

for (i in 1:10) {
  
  if (i < 5) {
    print('warming up the printer')
  } else {
    print(paste(i, 'is a number'))
  }
  
}

# Note that we can often get the effect of an else statement by using two, mutually exclusive if statements, 
# like so: 

for (i in 1:10) {
  
  if (i < 5) {
    print('warming up the printer')
  } 
  
  if (i >= 5) {
    print(paste(i, 'is a number'))
  }
  
}

# R doesn't know that the two if statements are linked, so we have to make sure we write them correctly to
# be mutually exclusive, or else we might miss some cases. 


## Exercises

# 3. Write a for loop that runs through the numbers 1 to 10 and prints 'X is not my favourite number' for 
#    most numbers but 'X is my favorite number!' when it gets to your favorite (within this range). Replace
#    X with the actual numbers, of course.



## Functions ##

# The final element of R programming we'll look at is writing functions. I outlined the basic structure
# of functions in week 1, but now we'll learn more about them, and how to make our own. 

# At its core, each function is an object in R that takes a number of arguments, performs some operations
# based on those arguments, and then (usually) returns some output. The first argument to a function is
# usually the one we use to supply some input, with further arguments modifying function behavior, though
# this isn't always the case. 

# The basic form of a function looks similar to what we've seen so far. Let's define a new function called 
# add_5, which takes some input and adds 5 to it. Notice that we've used the assignment arrow here, and if we
# run the code below, you'll see an object called add_5 appear in the 'Functions' window of your global
# environment. This is our new function. Notice that we've defined one argument 'input', within the curly
# brackets, and then the body of the function (within the curly braces { and }) adds 5 to that input. The
# return command tells the function that we want it to give us the result of this calculation as output. This
# is neccesary because functions don't return the results of calculations as output by default, since we might
# in theory ask them to do a number of calculations before we get the final result we want.

add_5 <- function(input) {
  return(input + 5)
}


# Let's test-drive our new function:
add_5(4)

add_5(100)

a <- 20

a_plus_5 <- add_5(a)


# Let's say we wanted to be a bit more flexible. Maybe we don't always want to add 5, maybe we want to add
# a different number sometimes. This is where additional arguments come in. For instance: 

add_any <- function(input, addition) {
  return(input + addition)
}

# By adding a second argument (addition) and telling the function to add this to the input, we've created
# a function that will add the second number we input to the first number (we've basically made a very 
# clunky '+')

add_any(3, 5)

# We don't always need arguments to have a working function. For some functions, we want them to do the same
# thing every time we call them. For example, the function below works fine (it will print 'hello' whenever
# you use it), despite not being particularly useful. 

say_hello <- function() {
  print('hello')
}



# One final thing to learn is how to set default values for arguments. Remember that for many functions in 
# R, some arguments have a default value? We can set those when we define our function. 

add_any <- function(input, addition = 5) {
  return(input + addition)
}

# We've now redefined the add_any function so that by default, if we don't specify a second argument, it will
# add five to our input. Of course, we can override the default behavior if we want:

add_any(1)

add_any(1, 2)

## Exercises

# 4. Write a function that takes a number as its first input and raises it to the power of its second input

# 5. Set the default value for the second argument of your power function to be 1. 

# 6. Write a function that takes a vector of numbers and calculates the mean (without using the actual mean
#    function). Hint: You'll want to use the length() function - ?length. Test your function on the 
#    vector below - you should get 108.6.

test_me <- c(2, 657, 1, 3, 90, -12, 45, 2, 7, 291)


## Advanced exercises 

# 7. Write a function that runs through the numbers 1:100 and only prints them if they're divisible by 3 
# (google the modulo function for R)
# 
# 8. Change that function so you can set the number to something other than 3
# 
# 9. Write a function that takes a vector of numbers as an input and standardizes it. 

