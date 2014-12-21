# run_analysis.R

A command line tool to create and summarise tiddy data from "UCI HAR Dataset" 

run_analysis.R is a single script that has two major functions:

* create tiddy data
* calculate the mean of the mean and the standard deviation columns

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
```{r}
