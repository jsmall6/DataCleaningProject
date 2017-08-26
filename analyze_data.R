# File: analyze_data.R
# Author: James Small
# Class: Data Cleansing
# Date: 8/24/2017

#install and load necessary packages

install.packages("dplyr")
install.packages("tidyr")
install.packages("data.table")
install.packages("readr")
install.packages("reshape2")

library(dplyr)
library(tidyr)
library(data.table)
library(readr)
library(reshape2)


#Set working directory
dir.create("C:/Users/jsmall/Documents/GitHub/CleaningCourseProject")
setwd("C:/Users/jsmall/Documents/GitHub/CleaningCourseProject")


#Download and unzip the project file.
fileloc <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileloc, "../DataSets/Dataset.zip", mode="wb")
unzip("../DataSets/Dataset.zip", exdir = "../DataSets")

#prepare filename handles based on unzipped file path.
file_activity_labels <- "../DataSets/UCI HAR Dataset/activity_labels.txt"
file_features <- "../DataSets/UCI HAR Dataset/features.txt"

file_test_subjects <- "../DataSets/UCI HAR Dataset/test/subject_test.txt"
file_test_x <- "../DataSets/UCI HAR Dataset/test/x_test.txt"
file_test_y <- "../DataSets/UCI HAR Dataset/test/y_test.txt"

file_train_subjects <- "../DataSets/UCI HAR Dataset/train/subject_train.txt"
file_train_x <- "../DataSets/UCI HAR Dataset/train/x_train.txt"
file_train_y <- "../DataSets/UCI HAR Dataset/train/y_train.txt"

#import files
activity_labels <- tbl_df(read.table(file_activity_labels, colClasses = c("numeric", "factor")))
features <-  tbl_df(read.table(file_features, colClasses = c("numeric", "character")))

test_subjects <- tbl_df(read.table(file_test_subjects, colClasses = c("numeric")))
test_x <- tbl_df(read.table(file_test_x))
test_y <- tbl_df(read.table(file_test_y))

train_subjects <- tbl_df(read.table(file_train_subjects, colClasses = c("numeric")))
train_x <- tbl_df(read.table(file_train_x))
train_y <- tbl_df(read.table(file_train_y))

#----------------
#Assignment Objective 1 - Merges the training and the test sets to create one data set.
#----------------
#First we merge the subjects, test and training in the studentds, x and y files together respectively.
  subjects <- rbind(test_subjects, train_subjects)
  xData <- rbind(test_x, train_x)
  yData <- rbind(test_y, train_y)
  
  #Second we use column bind to pull the subjects, activity (yData), and measurement values (xData) into one dataset.
  fullData <- cbind(subjects, yData, xData)
  
  #Finally update the table to to set the column names appropriately.
  names(fullData) <- c("SubjectID", "ActivityID", names(xData))


  #Clean up unnecessary data sets after they've been merged.
  rm(test_subjects, test_x, test_y, train_subjects, train_x, train_y)


#----------------
#Assignment Objective 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
#----------------
  #create a list of featureIDs that contain the word "mean" or "std" for the "mean and "Standard Deviation"
  #The specific grep command is looking for mean()-X or mean()-Y or mean()-Z in the variable name. Case is ignored.
  meanFeatures <- lapply(features$V2, function(x) grep("mean\\(\\)-[XYZ]$", x, ignore.case=TRUE))
  MeanIds <- logical(length(meanFeatures))
  for (x in 1:length(meanFeatures)){
    ifelse (length(meanFeatures[[x]]) == 0, MeanIds[x] <- FALSE, MeanIds[x] <- TRUE)
  }
  
  #The specific grep command is looking for std()-X or std()-Y or std()-Z in the variable name. Case is ignored.
  SDFeatures <- lapply(features$V2, function(x) grep("std\\(\\)-[XYZ]$", x, ignore.case=TRUE))
  SDIds <- logical(length(SDFeatures))
  for (x in 1:length(SDFeatures)){
    ifelse (length(SDFeatures[[x]]) == 0, SDIds[x] <- FALSE, SDIds[x] <- TRUE)
  }


  #Collect only those features that were flagged in the prior step.
  MeanFeatures <- features[MeanIds,]
  SDFeatures <- features[SDIds,]

  
  #Union_all the features for Mean and SD.
  FeaturesKept <- union_all(MeanFeatures, SDFeatures)
  
  names(FeaturesKept) <- c("MeasurementTypeID", "OriginalMeasurementName")
  
  #List of all features selected for the analysis
  select(FeaturesKept, c(MeasurementTypeID, OriginalMeasurementName))

  
#----------------
#Assignment Objective 3 - Uses descriptive activity names to name the activities in the data set
#----------------
  #Data is already collected into a merged data set. Let's add a column for the activity name and treat as factor variable of ActivityID
  #Normally we would not do things this way, but for the sake of easier grading we are adding a duplicate column and applying a factor label to it. 
  #This affects the naming of the column as ID to Name so it makes more sense.
  fullData$ActivityName <- fullData$ActivityID
  fullData$ActivityName <- factor(fullData$ActivityName, labels = activity_labels$V2)
  
  #check that the factor was applied correctly.
  unique(fullData[,c("ActivityName","ActivityID")])
  
  
#----------------
#Assignment Objective 4 - Appropriately labels the data set with descriptive variable names.
#----------------
  #Sort the data by MeasurementTypeID
  FeaturesKept <- FeaturesKept %>% arrange(MeasurementTypeID)
  
  #Generate a new more readable MeasurementTypeID and column bind the variable to the table
  #Excel was used to parse the names and build a function to concatinate a more appropriate measurement name for each variable.
  FeaturesKept$MeasurementName <- cbind(c("Mean_X_Time_Body_Accelerometer","Mean_Y_Time_Body_Accelerometer","Mean_Z_Time_Body_Accelerometer","SD_X_Time_Body_Accelerometer",
                              "SD_Y_Time_Body_Accelerometer","SD_Z_Time_Body_Accelerometer","Mean_X_Time_Gravity_Accelerometer","Mean_Y_Time_Gravity_Accelerometer",
                              "Mean_Z_Time_Gravity_Accelerometer","SD_X_Time_Gravity_Accelerometer","SD_Y_Time_Gravity_Accelerometer","SD_Z_Time_Gravity_Accelerometer",
                              "Mean_X_Time_Body_Accelerometer_AV","Mean_Y_Time_Body_Accelerometer_AV","Mean_Z_Time_Body_Accelerometer_AV","SD_X_Time_Body_Accelerometer_AV",
                              "SD_Y_Time_Body_Accelerometer_AV","SD_Z_Time_Body_Accelerometer_AV","Mean_X_Time_Body_Gyroscope_AV","Mean_Y_Time_Body_Gyroscope_AV",
                              "Mean_Z_Time_Body_Gyroscope","SD_X_Time_Body_Gyroscope","SD_Y_Time_Body_Gyroscope","SD_Z_Time_Body_Gyroscope",
                              "Mean_X_Time_Body_Gyroscope_AV","Mean_Y_Time_Body_Gyroscope_AV","Mean_Z_Time_Body_Gyroscope_AV","SD_X_Time_Body_Gyroscope_AV",
                              "SD_Y_Time_Body_Gyroscope_AV","SD_Z_Time_Body_Gyroscope_AV","Mean_X_Frequency_Body_Accelerometer","Mean_Y_Frequency_Body_Accelerometer",
                              "Mean_Z_Frequency_Body_Accelerometer","SD_X_Frequency_Body_Accelerometer","SD_Y_Frequency_Body_Accelerometer","SD_Z_Frequency_Body_Accelerometer",
                              "Mean_X_Frequency_Body_Accelerometer_AV","Mean_Y_Frequency_Body_Accelerometer_AV","Mean_Z_Frequency_Body_Accelerometer_AV","SD_X_Frequency_Body_Accelerometer_AV",
                              "SD_Y_Frequency_Body_Accelerometer_AV","SD_Z_Frequency_Body_Accelerometer_AV","Mean_X_Frequency_Body_Gyroscope","Mean_Y_Frequency_Body_Gyroscope",
                              "Mean_Z_Frequency_Body_Gyroscope","SD_X_Frequency_Body_Gyroscope","SD_Y_Frequency_Body_Gyroscope","SD_Z_Frequency_Body_Gyroscope"))


  #Create a mapped ID based on the Measurement Type ID + the prefix "V". The reason for this is the fullData set contains variable names by measurement by V<number>.  
  FeaturesKept$MeasurementTypeIDMapped <- paste(c("V"), FeaturesKept$MeasurementTypeID, sep="")
  FinalDataSubset <- fullData %>% select(SubjectID, ActivityID, ActivityName, FeaturesKept$MeasurementTypeIDMapped)
  
  #Rename the columns to according to the cleaned up names.
  names(FinalDataSubset) <- c("SubjectID", "ActivityID", "ActivityName", FeaturesKept$MeasurementName)
  
  #output the variables for the assignment objective 4
  names(FinalDataSubset)  

#----------------
#Assignment Objective 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#----------------
  
  #Tidy the table results using melt from reshape2 library. Keep SubjectID, ActivityID, ActivityName variables. 
  #This is tidy since each subject, activity type (ID/Name) and measurement variable has 1 value reported in the Value column
  TidyTable <- melt(FinalDataSubset, id.vars = c("SubjectID", "ActivityID", "ActivityName"), variable.name = "MeasurementVariable", value.name = "Value")
  
  #Remove the ActivityID with a select, group by the subjecttID, ActivityName and MeasurementVariable and then apply the mean function to each group
  Objective5Result <- TidyTable %>% select(-ActivityID) %>% group_by(SubjectID, ActivityName, MeasurementVariable) %>% summarise_all(funs(mean))

  #output the results to the target file for submission "CourseProjectOutput.txt"
  write.table(Objective5Result, file="CourseProjectOutput.txt", sep=",", row.names = FALSE)      
  
  
#Code to read the output file and display the first and last 50 records  
x <- read.table(file="CourseProjectOutput.txt", header = TRUE, sep=",")
head(x, 50)  
tail(x, 50)
  
  
  