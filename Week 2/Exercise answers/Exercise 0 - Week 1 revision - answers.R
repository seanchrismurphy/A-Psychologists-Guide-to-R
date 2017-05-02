### Week 1 revision questions ### 

# 1. Create a variable a, containing the number 2
a <- 2

# 2. Take the square root of 164
sqrt(164) 

# 3. Create a vector, b, containing the numbers from 1 to 10
b <- 1:10

# 4. Find the mean of vector b
mean(b)

# 5. What function tells you the type of data in b?
class(b) 

# 6. Test whether 5 * 5 is equal to 25
5 * 5 == 25

# 7. Create a vector that contains ten repeats of the word 'apple' 
rep('apple', 10)

test <- c('orange', 'pear', 'apple', 'banana', 'apple')

# 8. Use subsetting to get the 5th element of test
test[5]

# 9. Find all the places in test that contain 'apple'
test == 'apple'
which(test == 'apple')


pets <- data.frame("animals" = c('cat', 'cat', 'dog'), 'owners' = c('Pete', 'Steve', 'Alice'))

# 10. Use a function to display the first 6 rows of pets (though note there are only 3 rows to display)
head(pets) 

# 11. Use subsetting to get the 2nd row of pets
pets[2, ]

# 12. Select only the 'owners' column of pets - try to do it as many different ways as you can

pets[, 'owners']
pets$owners
pets[, 2]