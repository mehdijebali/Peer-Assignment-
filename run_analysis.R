library(dplyr)

### Setting working directory
setwd("C:/Users/MJB/Documents/Peer Assignment/")

### Read training data
Sub_train=read.table("UCI HAR Dataset/train/subject_train.txt")
X_train=read.table("UCI HAR Dataset/train/X_train.txt")
Y_train=read.table("UCI HAR Dataset/train/y_train.txt")

### Read test data
Sub_test=read.table("UCI HAR Dataset/test/subject_test.txt")
X_test=read.table("UCI HAR Dataset/test/X_test.txt")
Y_test=read.table("UCI HAR Dataset/test/y_test.txt")

# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

##############################################################################
# Step 1 - Merge the training and the test sets to create one data set
##############################################################################
humanActivity <- rbind(
  cbind(Sub_train, X_train, Y_train),
  cbind(Sub_test, X_test, Y_test)
)

colnames(humanActivity) <- c("subject", features[, 2], "activity")

##############################################################################
# Step 2 - Extract only the measurements on the mean and standard deviation
#          for each measurement
##############################################################################

columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))
humanActivity <- humanActivity[, columnsToKeep]

##############################################################################
# Step 3 - Use descriptive activity names to name the activities in the data
#          set
##############################################################################

# replace activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])


##############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names
##############################################################################

# get column names
humanActivityCols <- colnames(humanActivity)

# remove special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

# correct typo
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols


##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject
##############################################################################

# group by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)



