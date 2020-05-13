## Peer-graded Assignment: Getting and Cleaning Data Course Project
## Create destination / download / unzip data files
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

##Unzipped files - define the path / file created for the file names
path <- file.path("./data", "UCI HAR Dataset")
files <- list.files(path, recursive = TRUE)
files

## 1 - Read the train/test/features/activity labels data
x_train <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)
y_train <- read.table(file.path(path, "train", "y_train.txt"), header = FALSE)
subject_train <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)
x_test <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
y_test <- read.table(file.path(path, "test", "y_test.txt"), header = FALSE)
subject_test <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
features <- read.table(file.path(path, "features.txt"), header = FALSE)
activityLabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)

## Assigning variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
colnames(activityLabels) <- c("activityID", "activityType")

## Merging all data 
mergetrain <- cbind(x_train, y_train, subject_train)
mergetest <- cbind(x_test, y_test, subject_test)
fulldata <- rbind(mergetrain, mergetest)

## 2 - Extracting only mean and standard deviation measurements
colNames <- colnames(fulldata)
colNames

mean_std <- (grepl("activityID", colNames) | grepl("subjectID", colNames)
             | grepl("mean..", colNames) | grepl("std..", colNames))
setformeanandstd <- fulldata[, mean_std == TRUE]

## 3 - Descriptive activity names
setwithactivitynames <- merge(setformeanandstd, activityLabels, by = "activityID",
                              all.x = TRUE)

## 4 - SEE ABOVE 
## fulldata / mean_std / setformeanandstd

## 5 - Creating a tidy data set with avg of each variable 
## for each activity and each subject
tidydataset <- aggregate(. ~subjectID + activityID, setwithactivitynames, mean)
tidydataset <- tidydataset[order(tidydataset$subjectID, tidydataset$activityID),]

# Writing tidy data set into txt file
write.table(tidydataset, "tidydataset.txt", row.names = FALSE)
