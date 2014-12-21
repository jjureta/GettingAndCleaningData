# run_analysis.R

A command line tool to create and summarise tiddy data from "UCI HAR Dataset" 

run_analysis.R is a single script that has two major functions:

* create tiddy data
* calculate the mean of the mean and the standard deviation columns

The scrip perform multiple steps:

1. load the definition of activities and features (see files activity_labels.txt and features.txt in "UCI HAR Dataset" folder)
2. load subjects, measures and labels (see files subjects_test.txt, X_test.txt and y_test.txt in the test folder) of test data 
3. create test data set with cbind of subjects, measures and labels
4. load subjects, measures and labels (see files subjects_train.txt, X_train.txt and y_train.txt in the train folder) of train data 
5. create train data set with cbind of subjects, measures and labels
6. merge test and train data by using rbind
7. remove all columns but those contining either -std() or -mean
8. replace the acivity id column by activity which contains textual description of the activities (see file activity_labels.txt)
9. Clean column names by replacing std() by StandardDeviation, mean() by Mean, - by ., Acc by Accelerometer and Gyro by Gyroscope.
10. calculate the mean on all column values excpt SubjectID and Activity.
11. Rename columns by appending .Mean
12. If specified so ,the resulting data set is saved in a file.

# Installation

Run source('run_analysis.R').

This script depends on following packages :
- data.table
- dplyr

# Data set

Data set used by this script must be downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ) and unzipped into local folder.

More information on this data set can be found [here] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).

License:
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

# How to run

After run_analysis.R is sourced meanValues function must be called with two parameters:
- path - path to folder where is "UCI HAR Dataset" dataset
- writeToFile - write created dataset into "datamean.txt" file. The file is writen in the folder defined by path variable. Default value is FALSE.

Sample: 
```{r}
meanValues("\\data", writeToFile = TRUE)

