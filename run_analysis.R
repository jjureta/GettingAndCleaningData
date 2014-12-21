library(data.table)

dataPath <- ".\\data\\UCI HAR Dataset"


#################################################
# Load activities into data.table
#
# path - path where is the file activity_labels.txt
loadActivities <- function(path) {
  activityLabelsFilePath <- paste0(dataPath, "\\activity_labels.txt")
  activityLabels <- fread(activityLabelsFilePath)
  ## add header
  setnames(activityLabels, 1:2, c("ID", "Name"))
}

## Load features into data.table
##
## 
loadFeatures <- function(path) {
  featuresFilePath <- paste0(dataPath, "\\features.txt")
  featuresLabels <- fread(featuresFilePath)
  ## add header
  setnames(featuresLabels, 1:2, c("ID", "Name"))
}


loadSubjects <- function(path, dataType) {
  filename <- paste0("subject_", dataType, ".txt")
  path <-  paste(path, dataType, filename, sep = "\\")
  
  fread(path)
}

loadMesures <- function(path, dataType) {
  filename <- paste0("X_", dataType, ".txt")
  path <-  paste(path, dataType, filename, sep = "\\")
  
  print(path)
  ## bug in fread prevent to use it
  read.table(path)
}

loadTestSubjects <- function(path) {
  loadSubjects(path, "test")  
}

loadTestMesures <- function(path) {
  loadMesures(path, "test")  
}

testSubjects <- loadTestSubjects(dataPath)
testMesures <- loadTestMesures(dataPath)