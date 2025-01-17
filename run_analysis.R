library(data.table)
library(plyr)
library(dplyr)


#################################################
# Load activities into data.table
#
# path - path where is the file activity_labels.txt
loadActivities <- function(path) {
  activityLabelsFilePath <- paste0(path, "\\activity_labels.txt")
  activityLabels <- fread(activityLabelsFilePath)
  ## add header
  setnames(activityLabels, 1:2, c("ID", "Name"))
}

## Load features into data.table
##
## path - path where is the file features.txt
loadFeatures <- function(path) {
  featuresFilePath <- paste0(path, "\\features.txt")
  featuresLabels <- fread(featuresFilePath)
  ## add header
  setnames(featuresLabels, 1:2, c("ID", "Name"))
}

## Load subjects into data.table. Subjects are loaded from the file in folder named dataType.
## The file name is subject_%dataType%.
##
## path - path to folder which contains data
## dataType - Can be either "test" or "training"
loadSubjects <- function(path, dataType) {
  filename <- paste0("subject_", dataType, ".txt")
  path <-  paste(path, dataType, filename, sep = "\\")
  
  subjects <- fread(path)
  setnames(subjects, 1, c("SubjectID"))
  subjects
}

## Load measures into data.table. Measures are loaded from the file in folder named dataType.
## The file name is X_%dataType%.
##
## path - path to folder which contains data
## dataType - Can be either "test" or "training"
loadMeasures <- function(path, dataType) {
  filename <- paste0("X_", dataType, ".txt")
  path <-  paste(path, dataType, filename, sep = "\\")
  
  ## bug in fread prevent to use it
  read.table(path)
}

## Load measure labels into data.table. Labels are loaded from the file in folder named dataType.
## The file name is y_%dataType%.
##
## path - path to folder which contains data
## dataType - Can be either "test" or "training"
loadLabels <- function(path, dataType) {
  filename <- paste0("y_", dataType, ".txt")
  path <-  paste(path, dataType, filename, sep = "\\")
  
  ## bug in fread prevent to use it
  labels <- read.table(path)
  setnames(labels, 1, c("ActivityID"))
  labels
}

## Load test subjects. Same as loadSubjects(path, dataType = "test")
##
## path - path to folder which contains data
loadTestSubjects <- function(path) {
  loadSubjects(path, "test")  
}

## Load test measures. Same as loadSubjects(path, dataType = "test")
##
## path - path to folder which contains data
loadTestMeasures <- function(path) {
  loadMeasures(path, "test")  
}

## Load test labels. Same as loadLabels(path, dataType = "test")
##
## path - path to folder which contains data
loadTestLabels <- function(path) {
  loadLabels(path, "test")  
}

## Load train subjects. Same as loadSubjects(path, dataType = "train")
##
## path - path to folder which contains data
loadTrainSubjects <- function(path) {
  loadSubjects(path, "train")  
}

## Load train measures. Same as loadSubjects(path, dataType = "train")
##
## path - path to folder which contains data
loadTrainMeasures <- function(path) {
  loadMeasures(path, "train")  
}

## Load train labels. Same as loadLabels(path, dataType = "train")
##
## path - path to folder which contains data
loadTrainLabels <- function(path) {
  loadLabels(path, "train")  
}

#######################################################################
## This function:
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##
## path - pat which contains "UCI HAR Dataset" data
## writeToFile - write created dataset into "datamean.txt" file. Default value is FALSE 
meanValues <- function(path = ".", writeToFile = TRUE) {
  dataPath <- paste(path, "UCI HAR Dataset", sep = "\\")
  #######################################################################
  ## 1.Merges the training and the test sets to create one data set.
  activities <- loadActivities(dataPath)
  features <- loadFeatures(dataPath)
  
  # Load test data
  testSubjects <- loadTestSubjects(dataPath)
  testMeasures <- loadTestMeasures(dataPath)
  testLabels <- loadTestLabels(dataPath)
  testData <- cbind(testSubjects, testLabels, testMeasures)
  
  # Load train data
  trainSubjects <- loadTrainSubjects(dataPath)
  trainMeasures <- loadTrainMeasures(dataPath)
  trainLabels <- loadTrainLabels(dataPath)
  trainData <- cbind(trainSubjects, trainLabels, trainMeasures)
  
  data <- rbind(testData, trainData)
  
  setnames(data, 3:563, features[[2]])
  
  #######################################################################
  ## 2.Extracts only the measurements on the mean and standard deviation 
  ## for each measurement. 
  ## Keep columns: SubjectID, ActivityID and all other columns containing std() or mean() 
  data <- data[, grepl("-std\\(\\)|-mean\\(\\)|ID", colnames(data), ignore.case = TRUE), with=FALSE]
  
  #######################################################################
  ## 3.Uses descriptive activity names to name the activities in the data set
  match.idx <- match(data$ActivityID, activities$ID)
  data$ActivityID <- ifelse(is.na(match.idx), data$ActivityID, activities$Name[match.idx])
  setnames(data, 2, "Activity")
  
  #######################################################################
  ## 4.Appropriately labels the data set with descriptive variable names
  columnNames <- names(data)
  
  setnames(data, 3:68, sapply(columnNames[3:68], function(val) {
    ## Remove () from column name
    val <- gsub("\\(\\)", "", val) 
    ## Replace - by . in column name
    val <- gsub("-", ".", val)
    ## Replace .std by .StandardDeviation
    val <- gsub("\\.std", "\\.StandardDeviation", val)
    ## Replace .mean by .Mean
    val <- gsub("\\.mean", "\\.Mean", val)
    ## Replace Acc by Accelerometer
    val <- gsub("Acc", "Accelerometer", val)
    ## Replace Gyro by Gyroscope
    val <- gsub("Gyro", "Gyroscope", val)
    val <- gsub("^t", "Time.", val)
    val <- gsub("^f", "FastFourierTransform.", val)
    val
  })) 
  
  #######################################################################
  ## 5.From the data set in step 4, creates a second, independent tidy 
  ## data set with the average of each variable for each activity and each subject.
  columnNames <- names(data)
  datamean <- ddply(data,.(SubjectID, Activity),colwise(mean, columnNames[3:68]))
  
  setnames(datamean, 3:68, sapply(columnNames[3:68], function(val) {
    paste(val, "Mean", sep = ".")
  }))
  
  if (writeToFile) {
    write.table(datamean, paste(path, "datamean.txt", sep = "\\"), row.name=FALSE) 
  }
  
  datamean
}

