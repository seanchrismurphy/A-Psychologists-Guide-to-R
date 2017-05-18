### Reading in your data ###

# As with other things in R, there's no dropdown menu for reading in data. File > Open File is used to open 
# different R code files, rather than different data files. Instead, there are a number of functions to read 
# in data in different formats and turn it into dataframes in R. For this first example, we'll read in data in
# from a .csv, or 'comma separated values' file, using the `read.csv()` function. This file format is widely used
# across many disciplines because it is extremely simple and compact, and doesn't require any proprietary software 
# (unlike excel spreadsheets or spss files). It's also one of the most straightforward ways to get data 
# into R. 

# There are two main ways to tell R where to read data from. One is to specify the entire file path to the data.
# You can do this by copying and pasting the file path from your file explorer software, or by using the 
# file.choose() function. file.choose() opens a browser that lets you navigate to the data file you're looking
# for, and once you've selected it, it prints the full file path to that file. You can then use that as an input 
# to read.csv. 

# Try running file.choose() and navigate to wherever you've copied the Week 2 folder. Select the 'week
# 2 data.csv' file.
file_path <- file.choose()

# Now that you've saved the file path, you can use it to tell read.csv where to read the data from. We'll
# explain the stringsAsFactors argument later.
week2 <- read.csv(file_path, stringsAsFactors = FALSE)


# You can even combine these into a single command, that will read the chosen file (though this will break if
# you choose something that isn't a .csv file)
week2 <- read.csv(file.choose(), stringsAsFactors = FALSE)

# The second way to read in data is to set your working directory to where the data is. The working directory
# is what R uses as a reference when it searches the file system, which means that if your working directory
# is set to where your data are, you only need to input the name of the data file to read.csv() in order to
# load it, without specifying a file path. 

# Try setting the working directory below to wherever you copied the folder for this week.
# Remember that you can use file.choose() to get the path to a file in that folder, but here you'll need to 
# make sure you've specified the path to the folder, not any particular file. If you get an error, it 
# likely means you've specified the file path wrong. Remember that this is case sensitive, and that you'll
# need to use forward slashes (even on windows). 
setwd('/Dropbox/r course materials/Week 2') 

# If you struggle with getting the path to your working directory right, you can use the dropdown menu in 
# R studio - Session -> Set Working Directory -> Choose Directory
# Then select the directory you want. You'll see the correct command printed at the console. 

# Once you've successfully changed the working directory, you should be able to read in the data simply
# by specifying the file name
week2 <- read.csv('week 2 data.csv', stringsAsFactors = FALSE)

# Take a look at the data to make sure it has read in properly
head(week2)


# There are a few other functions that can make it easier to read in files. The list.files() function will
# return a list of all the files in your current working directory. This can help you check that you're in
# the right place, and can also be useful if you have a lot of files you want to read in (more on that
# later)

list.files()

# Note that, in a similar vein, the ls() function will list all the objects currently in your R workspace
# (the window at the top right). As you go through these examples, this might start to get cluttered. At
# any time, you can remove an object using the rm() function. 

a <- 'test'
rm(a)

# If you want to remove everything, you can type rm(ls()), which tells R to remove everything returned by
# ls() - and as we just found out, that's everything in the workspace! You can get the same effect by 
# clicking the broom button in the top right corner of RStudio. 

