library("dplyr")

# Merges the training and the test sets to create one data set.
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

train_set_x <- read.table("./UCI HAR Dataset/train/X_train.txt", colClasses='numeric') # vectors
train_set_y <- read.table("./UCI HAR Dataset/train/y_train.txt") # activity label number
colnames(train_set_x) <- features$V2 # set the column names
train_set_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt") # subjects for train set
train_set_x['subject'] <- train_set_subject
train_set_activity_label <- activity_label$V2[train_set_y$V1] # map number to activity label
train_set_x['activity'] <- train_set_activity_label # add activity label to data frame

test_set_x <- read.table("./UCI HAR Dataset/test/X_test.txt", colClasses='numeric') # vectors
test_set_y <- read.table("./UCI HAR Dataset/test/y_test.txt") # activity label number
colnames(test_set_x) <- features$V2 # set column names for the test set
test_set_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt") # subjects for test set
test_set_x['subject'] <- test_set_subject
test_set_activity_label <- activity_label$V2[test_set_y$V1] # map numbers to activity label
test_set_x['activity'] <- test_set_activity_label # add column with activity label

merged_set <- rbind(train_set_x, test_set_x) # merge both data sets

# Extracts only the measurements on the mean and standard deviation for each measurement.
only_mean_and_std <- merged_set[,grep('mean\\(|std\\(|activity|subject', names(merged_set))]

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject
summary_set <- only_mean_and_std %>% 
  group_by(subject, activity) %>%
  summarise_all(mean)
    
write.table(summary_set, file="./result.txt", row.names=FALSE)

