Course Project: Getting and Cleaning Data
========================================================
Description of "run_analysis.R" script and accompanying files    
Specialization on Data Science - Johns Hopkins University  
(http://www.coursera.org)  
**Ricardo Gonzalez**

The submitted script "run_analysis.R" read text files containing data collected from the accelerometers from the Samsung Galaxy S smartphone, obtained from the Coursera website at 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Before exiting, the script writes to disk -in the working directory- a text file called "CourseProjectResult.txt", containing one tidy dataset with the average of each variable that is either a mean or a standard deviation, for each subject and each activity. This text file can be read into R using read.table, for instance: 
> read.table("CourseProjectResult.txt", header = TRUE)

The result dataset complies with the principles of tidy data as follows:
1. Each variable forms a column
2. Each observation forms a row
3. The table/file stores data about only one kind of observation (subject activities / smartphone data).

### NOTES:
- The working directory must be set to "UCI HAR Dataset", or -if you changed the folder name when unzipping- the one containing 'README.txt', 'features_info.txt', 'features.txt' and 'activity_labels.txt', for this script to run properly.
- The library "reshape2" must be installed and sourced for this script to run properly.
- More information on Tidy Datasets: 
 - See forum discussion at https://class.coursera.org/getdata-004/forum/thread?thread_id=262
 - See Hadley Wickam Tiday paper on tidy datasets at http://vita.had.co.nz/papers/tidy-data.pdf

### HOW THE SCRIPT WORKS:
First it reads the "common"" tables into R, "features.txt" and "activity_labels.txt". Then it fixes the names in "features.txt" to make them descriptive variable names able to be used in R: 
- expanding abbreviations ("t" to "timesignal", "Acc" to "acceleration", "-X" to "onaxisx", etc.), 
- removing problematic characters (such as commas, parentheses and hyphens),
- setting all characters to lowercase

Then it loads the Test dataset into R: 
- "subject_test" (IDs of the subjects from whose smartphones the data was taken),
- "y_test" (IDs of the activities were performing, at the time the measures were taken),
- "x_test" (actual dataset, containing the measurements taken)
A column is added to the table "y_test", containing the label of the activity taking place (e.g. if the value in the "y_test" row is "1", the value for the added column is "WALKING").
The variable names contained in the table "features" is assigned to the names of the dataset. These names are already descriptive variable names.
A new variable is created in the "x_test" dataset, containing the ID of the subject whose measurements are taken (from the table subject_test). 
Another new variable is created to the same dataset, containing the descriptive activity name of what was the subject doing at time of measurement.

The same sequence of activities is performed for "Training" data. We now have two datasets, with the same number of columns but with measurements from two differents group of people ("Training" and "Test").

Using rbind, the script joins the two dataframes in a single one, "firstdataset". This step answers point # 1 of the Course Project, **"1. Merges the training and the test sets to create one data set."**
It also answers points **#3** and **#4**, since the activities are given descriptive names and the dataset is labeled with descriptive variable names.

Then the dataset is subsetted as requested by point **"2. Extracts only the measurements on the mean and standard deviation for each measurement"**. In order to select which columns to keep, I searched for the ones containing either the string "mean" or "std". After selecting the columns, it stores them in the same dataset "firstdataset".
NOTE: I decided to include not only the columns ending with the words "mean" or "std", but also the columns thad had them somewhere else in their names, since I understand them to be also "measurements on the mean and standard deviation"."  

To answer point **#5**, the script melts the dataset into one arranged by "subject" and "activity" as variables, and all other columns as measurements. The result is a 4-columns dataset which is already tidy ("subject", "activity", name of measurement, value). 
Then, the script casts this molten dataset into another tidy form (as per the principles detailed above), with the average of each variable for 
each activity and each subject. The resulting dataset ("seconddataset") is written to disk with the name "CourseProjectResult.txt". This text file can be read into R using read.table, for instance: 
> read.table("CourseProjectResult.txt", header = TRUE)

**SUBMITTED FILES**
This submission for the Course Project includes: 
- the main script "run_analysis.R",
- this "README.md" file, 
- the resulting data frame "CourseProjectResult.txt", and 
- "Codebook.md", which is a codebook explaining all the columns in the resulting data frame

