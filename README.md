Getting and Cleaning Data Course Project
========================================

## Contents

This reporitory contains the code and auxiliary files for the course project of
the Getting and Cleaning Data course:

* `run_analysis.R`  
The R script that reads and manipulates the data provided and produce as a
result the tidy data set.  

* `CodeBook.md`  
A markdown code book for the data set. This was adapted from the file
`features_info.txt` in the original data set.  

* `README.md`  
This readme file.  

* `tidyData.txt`  
The file with the resulting tidy data set from running `run_analysis.R`.

## Introduction

The purpose of the main script of the project, `run_analysis.R`, is to read,
extract, clean and output a subset of the data set from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#). Namely, the instructions state:

>You should create one R script called run_analysis.R that does the following.
    
> 1.  Merges the training and the test sets to create one data set.
> 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3.  Uses descriptive activity names to name the activities in the data set
> 4.  Appropriately labels the data set with descriptive variable names. 
> 5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The data provided comes from taking measurements of 30 subjects performing
several activities (walking, walking upstairs, walking downstairs, sitting,
standing, and laying). The bulk data set was then divided into two subsets,
a *train* set and a *test* set, by randomly choosing 70% of the subjects for
the train ser and 30% for the test set.

## Analysis

The `run_analysis.R` script creates the file `tidyData.txt` containing the tidy
data set specified in step 5 of the instructions. It does this by:

1. **Reading the data from file**. The script assumes the unziped folder
`UCI HAR Dataset` is in the current working directory. It reads 3 files from
the *train* set and 3 files from the *test* set. Each of these sets contains a
file with the measurements, `X_train.txt` and `X_test.txt`, a file with the
activity label corresponding to each row of measurements, `Y_train.txt` and
`Y_test.txt`, and a file with a subject id corresponding to each row of
measurements (1--30). Along with these, two other files are relevant: the
`features.txt` file contains the labels for the measurements in the `X` files
(one for each column), and the `activity_labels.txt` file contains a
correspondence between the activity performed and the activity label used in
the `Y` file. The relevant files read are:
   * `UCI HAR Dataset/train/X_train.txt`
   * `UCI HAR Dataset/train/Y_train.txt`
   * `UCI HAR Dataset/train/subject_train.txt`
   * `UCI HAR Dataset/test/X_test.txt`
   * `UCI HAR Dataset/test/Y_test.txt`
   * `UCI HAR Dataset/test/subject_test.txt`
   * `UCI HAR Dataset/features.txt`
   * `UCI HAR Dataset/activity_labels.txt`   

2. **Merging the test and train data**. We merge the train and test data (in
this order) by simply binding the rows of the test data at the end of the train
data. We now have 3 data frames, `X`, `Y` and `subject`, with the merged data.

3. **Renaming columns**. Next we rename the columns of the measurements data
frame `X` with the names given in `features`. Note that we first get rid of the
first column in `features` (which is just a sequencial numbering) and
parentheses in the names with  
`features = gsub("\\(\\)","",features[,2])`.

4. **Keep mean and std**. Following step 2. of the instructions, we then
extract only the measurements on the mean and standard deviation for each
measurement. We do this by matching the patterns `"mean\b"` (with a word
boundary at the end) and `"std"` on the features vector and extracting from `X`
the columns whose indeces have matched. For the mean regular expression, we use
a word boundary at the end because we do not want to match `meanFreq`
measurements, only `mean` and `std`.

5. **Replace Activity labels**. Next, we replace the activity labels in the `Y`
vector with the more descriptive values obtained from `activity_labels`. We do
this by mapping (with `sapply`) the first column of `activity_labels` to its
second column.

6. **Bild data set**. We then can bind Subject and Activity vectors together
with the measurements to form a big data set (we use `cbind` for this), and
rename the two first columns with useful names.

7. **Bild separate tidy data set**. The last step in buiding the second data
set mentioned in the instructions is to compute the average for each
measurement/subject/activity combination. We do this using the capabilities of
the `data.table` package to `lapply` column-wise, by a set of variables:  
`Xave = Xave[, lapply(.SD,mean), by=list(Subject,Activity)]`

8. **Save to file**. The final step os to save to the file `tidyData.txt` the
resulting set. Note that we reorder the rows by Subject and Activity before
doing so.