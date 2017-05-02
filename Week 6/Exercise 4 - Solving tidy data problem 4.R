### Solving tidy data problem number 4

### Bringing together datasets that describe the same individuals/units

# We've already come across problem number four of tidy data (observations spread out across multiple
# data frames) in our longitudinal example. In cases like that, where we have information about the 
# same individuals or groups spread out across data sets, join() offers us a trivial solution to
# merge them together. This is very useful in cases of multilevel modelling where you might have
# a separate dataset for individuals, with an ID for the group that they are in, and for the group level
# data themselves. Merging the two together is as simple as:

join(data1, data2)

# Note that join is in the plyr package, so you'll need that enabled to use it. One thing
# to be aware of with join is that be default, it performs a 'left' join, which means it
# will keep each row in data1, and merge in matching rows from data2. Rows from data2 that
# don't have a match in data1 will be discarded. You can change this with the type argument
# to 'inner', which only keeps rows that have a value in both data frames, or 'full', which
# keeps all rows, so the rows from data2 without a match go to the bottom of the new data
# frame.

join(data1, data2, type = 'inner')

### Bringing together datasets that describe different individuals/units

# There is another form of problem number four though, and that is when you have your observational
# units for a single experiment or study spread out across files or data frames. For instance, you
# might have a separate .csv file for each subject from a reaction time experiment. Or you might
# have a separate file for each year level from a school you surveyed. In this case, R offers us
# useful ways to deal with this in the form of list.files and ldply.

# In this example, we have data from a reaction time experiment on 20 individuals stored in the
# "Pattern_Discrimination Task" folder. We want to take all 20 files and put them into a single
# data frame. The functions below will do that.

# list.files is a handy R function that, if you give it a folder name as input, will return all the file
# names in that folder. If you have set your working directory to the data folder in Week 6, the following
# code will save a list of all the .csv files in the pattern discrimination task folder. The '.', when
# used in file paths in R, indicates 'my current working directory'. So the file path we specify looks
# for a folder 'Pattern_Discrimination Task' in our current working directory. Of course, you could also
# always just specify the full file path. The pattern = "\\.csv$" argument tells list.files to filter the
# search and only return files that end in .csv (this is a regular expression pattern) - the double 
# backslash is required before searching for a full stop (.) or other special regular expression 
# character in R (like $, ^, etc) to 'escape' it so the search knows it's looking for an actual full stop
# instead of 'anything' which is the typical meaning. the full.names argument just tells list.files that
# we want the name of the files including the directory path, which will make it easier to search them.

paths <- list.files('./Pattern_Discrimination Task', 
             pattern = "\\.csv$", 
             full.names = TRUE)

# Now that we have paths (our list of the files we would like to read) ldply will do the reading
# for us. ldply is from a family of data cleaning functions in plyr that we haven't focused on, 
# but it's the best thing for the job here. The code below uses basename to extract the actual
# file names of our pattern discrimination files. Then ldply essentially performs a loop, running
# through each of the file names, performing a specified function (in this case, read.csv), 
# and creates a 'filename' column that wasn't in the original data, but will tell us what the
# file name of the .csv that each row came from was. This can be very handy if our pariticpant
# ids are not in the data itself, but only stored in file names. 

names(paths) <- basename(paths)
speed <- ldply(paths, read.csv, stringsAsFactors = FALSE, .id = 'filename')

# Voila! With only a few lines of code, we can essentially take any directory that contains a 
# file for each participant (or school, or group) and stitch them together, stacking them on
# top of one another. 

# ldply can take any function and apply it to a list, turning it into a data frame (hence the name, which
# stands for list to dataframe apply). So if you have spss files instead of .csv files, you could use 
# read_sav instead of read.csv and ldply should still work. The same goes for other types of files, providing
# they have a read method in R that returns a data frame.
