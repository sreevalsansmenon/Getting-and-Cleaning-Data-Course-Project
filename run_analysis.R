# Load packages
library(plyr)
library(dplyr)

# Extract data from features and activities text file
features            <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
# Remove paranthesis
feature             <- gsub("\\(\\)","",as.character(features[,2]))
activities          <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
# Remove unused variable
rm(features)

# Extract test data
features_test_data  <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
activity_test_data  <- join(read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char=""),activities)
subject_test        <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
data_test           <- cbind( subject_test,  activity_test_data[,2], features_test_data)
#Remove unused variable
rm(subject_test,  activity_test_data, features_test_data)

# Extract train data
features_train_data <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
activity_train_data <- join(read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char=""),activities)
subject_train       <- read.table("~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
data_train <- cbind(subject_train, activity_train_data[,2], features_train_data)
#Remove unused variable
rm(subject_train, activity_train_data, features_train_data, activities)

# Input column names
names(data_test)    <- c("subject_id", "activity", feature)
names(data_train)   <- c("subject_id", "activity", feature)
#Remove unused variable
rm(feature)

# Merge data
merged_data         <- rbind(data_test,data_train)
valid_column_names <- make.names(names=names(merged_data), unique=TRUE, allow_ = TRUE)
names(merged_data) <- valid_column_names
# Convert merged data to dplyr
merged_data <- tbl_df(merged_data)
# Remove library plyr to use summarize in dplyr
detach(package:plyr)
#Remove unused variable
rm (data_test,data_train,valid_column_names)
head(merged_data)

# Filtering Extracts only the measurements on the mean and standard deviation for each measurement
mean_standard_deviation_values = select(merged_data,matches("mean|std|subject_id|activity"))

# Summarize: average of each variable for each activity and each subject
summary_data <- mean_standard_deviation_values %>%
  group_by(subject_id,activity) %>%
  summarize_all(mean)

write.table(summary_data,file = "~/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/Summary_Data.txt",row.name=FALSE)