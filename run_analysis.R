#This scrip Runs the analysis on the Human Activity Recognition Using
#Smartphones data set. It assumes the unziped folder "UCI HAR Dataset" is on
#the current working directory.

#Read all the data from the data set.
X_train = read.table("UCI HAR Dataset/train/X_train.txt")
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")

X_test = read.table("UCI HAR Dataset/test/X_test.txt")
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")

features = read.table("UCI HAR Dataset/features.txt")
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")

#Merge train and test data, in this order, and get rid of the separate
#variables from the environment
X = rbind(X_train,X_test)
Y = rbind(Y_train,Y_test)
subject = rbind(subject_train,subject_test)
rm(X_test, X_train, Y_test, Y_train, subject_test, subject_train)

#Rename the columns in the merged data X with the names provided in "features".
features = gsub("\\(\\)","",features[,2])
colnames(X) = features

#As per the instructions, we keep only the columns corresponding to the mean
#and standard deviation values. For the mean we match a word boundary at the
#end of the word because we do not want to match the quantities where meanFreq
#was applied.
X = X[,which(grepl("mean\\b",features) | grepl("std",features))]
rm(features)

#Rename the values of Y with the corresponding activity labels as factors
Y = sapply(Y,FUN=function(x) activity_labels[x,2])
Y = factor(Y,levels=activity_labels[,2])
rm(activity_labels)

#Bind the subject and activities vectors to the data set and rename these two
#columns with useful names
X = cbind(subject,Y,X)
colnames(X)[1:2] = c("Subject", "Activity")
rm(subject,Y)

#Create the second independent tidy data set. We use a data.table in order to
#apply the mean to each column of the table for a particular Subject and
#Activity
require(data.table)
Xave = data.table(X)
Xave = Xave[, lapply(.SD,mean), by=list(Subject,Activity)]

#Sort the tidy data set by Subject and Activity using "arrange" from the plyr
#package, and save the data to the "tidyData.txt" file
require(plyr)
Xave = arrange(Xave,Subject,Activity)
write.table(Xave, file="tidyData.txt", row.names=F)

#Clean workspace
rm(X,Xave)
