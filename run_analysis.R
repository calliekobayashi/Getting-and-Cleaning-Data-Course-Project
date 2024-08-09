library(dplyr)

#DOwnload dataset
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read and assign column names
features <- read.table('./data/UCI HAR Dataset/features.txt',col.names=c("n","functions"))
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt', col.names=c("activityId","activityType"))

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt",col.names="activityId")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",col.names="subjectId")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt",col.names="activityId")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",col.names="subjectId")

#1.Merge data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
final_mrg <- rbind(mrg_train, mrg_test)

#2.Extract column with mean or std in column name
TidyData <- final_mrg %>% select(activityId, subjectId, contains("mean"), contains("std"))

#3.Name activities in data set
TidyData$activityId <- activityLabels[TidyData$activityId, 2]

#4.Create Appropriate column name
  #already performed during the "read and assign column names"

#5.Create tidy data with average of each variable
secTidySet <- aggregate(. ~subjectId + activityId, TidyData, mean)
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)