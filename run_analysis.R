setwd("C:/Users/MJB/Documents/Peer Assignment/")
train_set=read.table("UCI HAR Dataset/train/X_train.txt")
test_set=read.table("UCI HAR Dataset/test/X_test.txt")

#merge train & test data
Data_set <- rbind(train_set, test_set)
