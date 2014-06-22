## The following code read text files containing data collected from the 
## accelerometers from the Samsung Galaxy S smartphone, and obtained from the 
## Coursera website at 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## After running, there will be a file called "CourseProjectResult.txt" in the
## working directory, containing one tidy dataset with the average of each 
## variable that is either a mean or a standard deviation, for each subject and 
## each activity. This .txt file can be read into R using for instance
## read.table("CourseProjectResult.txt", header = TRUE)

## NOTE: the working directory must be set to "UCI HAR Dataset", or -if you 
## changed the folder name when unzipping- the one containing 'README.txt',
## 'features_info.txt', 'features.txt' and 'activity_labels.txt', for 
## this script to run properly.

## Requirements: library(reshape2)

## Read data into R, starting with common tables 
features <- read.table("features.txt", check.names=TRUE)
activity_labels <- read.table("activity_labels.txt")

## Fix names in table "features" to make them descriptive variable names
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("^t","timesignal", x)) ## replace leading "t" with "timesignal"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("^f","frequencysignal", x)) ## replace leading "f" with "frequencysignal"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("Mag","magnitude", x)) ## replace "Mag" with "magnitude"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("Gyro","angularvelocity", x))      ## replace "Gyro" with "angularvelocity"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("Acc","acceleration", x))    ## replace "Acc" with "acceleration"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("\\(","", x)) ## remove all starting parentheses
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("\\)","", x)) ## remove all ending parentheses
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub(",","", x)) ## remove all commas
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("-X","onaxisx", x)) ## replace all "-X" with "onaxisx"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("-Y","onaxisy", x)) ## replace all "-Y" with "onaxisy"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("-Z","onaxisz", x)) ## replace all "-Z" with "onaxisz"
features$V2 <- tapply(features[,2], features[,1], FUN = function(x) gsub("-","", x)) ## remove all remaining hyphens
features$V2 <- tolower(features$V2) ## change all letters to lowercase

## "Test" dataset: Load data into R
subject_test <- read.table("./test/subject_test.txt", col.names="subjectTest")
y_test <- read.table("./test/y_test.txt", col.names="activityLabel")
x_test <- read.table("./test/x_test.txt")

## Add names of activities to table y_test
y_test$activity <- activity_labels[y_test$activityLabel,2]

## set names contained in "features" to be names of table x_test
names(x_test) <- features[,2]

## add to x_test the id of the person whose data is measured
x_test$subject <- subject_test[,1]

## add the activity the person was performing at time of measurement
x_test$activity <- y_test$activity 


## "Training" dataset: Load data into R
subject_train <- read.table("./train/subject_train.txt", col.names="subjectTrain")
y_train <- read.table("./train/y_train.txt", col.names="activityLabel")
x_train <- read.table("./train/x_train.txt")

## Add names of activities to table y_train
y_train$activity <- activity_labels[y_train$activityLabel,2]

## set names contained in "features" to be names of table x_train
names(x_train) <- features[,2]

## add to x_train the id of the person whose data is measured
x_train$subject <- subject_train[,1]

## add the activity the person was performing at time of measurement
x_train$activity <- y_train$activity 

## merge in a single dataframe. This step answers point # 1 of the Course Project,
## "Merges the training and the test sets to create one data set." It also answers 
## points #3 and #4, since the activities are given descriptive names and the
## dataset is labeled with descriptive variable names.
firstdataset <- rbind(x_test, x_train)

## As requested in point #2 of the Course Project, "Extracts only the measurements
## on the mean and standard deviation for each measurement". First select which 
## columns to keep, then save only those columns in the dataset.
colstokeep <- grepl('mean|std', names(firstdataset)) | grepl('activity', names(firstdataset)) | grepl('subject', names(firstdataset))
firstdataset <- firstdataset[, colstokeep]

## Answering point #5 of the Course Project, melt the dataset into one arranged by 
## "subject" and "activity" as variables, all other columns as measurements. Then ## cast this molten dataset into a tidy form, with the average of each variable 
## for each activity and each subject. 
molten <- melt(firstdataset, id.vars=c("subject", "activity"))
seconddataset <- dcast(molten, subject + activity ~ variable, mean)

## Writes this result dataset to disk as a .txt, ready to be loaded into R using
## "read.table"
write.table(seconddataset, "CourseProjectResult.txt", row.names=FALSE)


