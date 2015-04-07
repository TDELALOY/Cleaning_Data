
## DATA SCIENCE - COURSERA - T DELALOY


## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## first time
install.packages("data.table") 
install.packages("reshape2") 

#load libraries
library(data.table) 
library(reshape2) 
library(plyr)

#define working directory
setwd("C:/Users/I051921/Desktop/Prediction (KXEN)/Coursera")

# load column names 
column_names <- read.table("data_acquisition/features.txt")[,2] 

# load activity labels 
activity_labels <- read.csv("data_acquisition/activity_labels.txt", sep="", header=FALSE)[,2]
names(activity_labels) <- c('name')

# load training dataset
train_data_x <- read.csv("data_acquisition/train/X_train.txt", sep="", header=FALSE)
names(train_data_x) <- column_names
train_data_y <- read.csv("data_acquisition/train/Y_train.txt", sep="", header=FALSE)
train_data_y [,2] <-  activity_labels[train_data_y [,1]]
names(train_data_y) <- c("activity.id","activity.name")

train_row <- read.table("data_acquisition/train/subject_train.txt")
names(train_row) <- c("subject.id")
train_data <-cbind(train_row,train_data_y)
train_data <-cbind(train_data,train_data_x)

# load test dataset
test_data_x <- read.csv("data_acquisition/test/X_test.txt", sep="", header=FALSE)
names(test_data_x) <- column_names
test_data_y <- read.csv("data_acquisition/test/Y_test.txt", sep="", header=FALSE)
test_data_y [,2] <-  activity_labels[test_data_y [,1]]
names(test_data_y) <- c("activity.id","activity.name")

test_row <- read.table("data_acquisition/test/subject_test.txt") 
names(test_row) <- c("subject.id")
test_data <-cbind(test_row,test_data_y)
test_data <-cbind(test_data,test_data_x)

# Merge training and test sets together 
final_data <- rbind(train_data, test_data) 

# filter with grep column with pattern : mean|std 
sel_column_names <- grepl("activity.*|subject.id|mean|std", names(final_data)) 
final_data <- final_data[,sel_column_names]

id_labels   = c("subject.id", "activity.id", "activity.name") 
var_labels <- grep("mean|std", names(final_data),value=TRUE)
melt_data      = melt(final_data, id = id_labels, measure.vars = var_labels) 
 
# Apply mean function to dataset using dcast function 
tidy_data   = dcast(melt_data, subject.id + activity.id + activity.name ~ variable, mean) 

write.table(tidy_data, file = "data_acquisition/tidy_data.txt") 

#end
