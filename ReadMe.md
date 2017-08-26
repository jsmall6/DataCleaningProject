## File: ReadMe.md
### Author: James Small
### Class: Data Cleansing
### Date: 8/24/2017


##Introduction 
This assignment submission is in response to the Getating and Cleaning Data Course Project. The objective is to clean a messy data set and produce a summary data set that is "Tidy".

##Included Artifacts
1. analyze_data.R - Script used to do the analysis
2. CourseProjectOutput.txt - output tidy data set for review
3. Codebook - describes the tidy data set produced


##Script Description
The script execution follows the following execution plan to construct the analysis.


1. install and load necessary packages
2. Set working directory
3. Download and unzip the project file.
4. Prepare filename handles based on unzipped file path.
5. import files into separate objects

6. Assignment Objective 1 - Merges the training and the test sets to create one data set.
  + First, we merge the subjects, test and training in the studentds, x and y files together respectively.
  + Second, we use column bind to pull the subjects, activity (yData), and measurement values (xData) into one dataset.
  + Finally, update the table to to set the column names appropriately.
  
7. Assignment Objective 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
  + create a list of featureIDs that contain the word "mean" or "std" for the "mean and "Standard Deviation"
  + The specific grep command is looking for mean()-X or mean()-Y or mean()-Z in the variable name. Case is ignored.
  + The specific grep command is looking for std()-X or std()-Y or std()-Z in the variable name. Case is ignored.
  + Collect only those features that were flagged in the prior step.
  + Union_all the features for Mean and SD.
  + Output to consol - List of all features selected for the analysis
  

8. Assignment Objective 3 - Uses descriptive activity names to name the activities in the data set
  + Data is already collected into a merged data set. Let's add a column for the activity name and treat as factor variable of ActivityID
  + Normally we would not do things this way, but for the sake of easier grading we are adding a duplicate column and applying a factor label to it. 
  + This affects the naming of the column as ID to Name so it makes more sense.
  
9. Assignment Objective 4 - Appropriately labels the data set with descriptive variable names.
  + Sort the data by MeasurementTypeID
  + Generate a new more readable MeasurementTypeID and column bind the variable to the table
  + Excel was used to parse the names and build a function to concatinate a more appropriate measurement name for each variable.
  + Create a mapped ID based on the Measurement Type ID + the prefix "V". The reason for this is the fullData set contains variable names by measurement by V<number>.  
  + Rename the columns to according to the cleaned up names.
  + output the variables for the assignment objective 4
  
10. Assignment Objective 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

  + Tidy the table results using melt from reshape2 library. Keep SubjectID, ActivityID, ActivityName variables. 
  + This is tidy since each subject, activity type (ID/Name) and measurement variable has 1 value reported in the Value column
  + Remove the ActivityID with a select, group by the subjecttID, ActivityName and MeasurementVariable and then apply the mean function to each group
  + output the results to the target file for submission "CourseProjectOutput.txt"

  
##Reading Output File

Code to read the output file and display the first and last 50 records  

    ```
    x <- read.table(file="CourseProjectOutput.txt", header = TRUE, sep=",")
    head(x, 50)  
    tail(x, 50)
    ```
  
  
  




