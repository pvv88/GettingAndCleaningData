
# 1. Merges the training and the test sets to create one data set.

## Download and unzip file
setwd("C:/Users/Dell/Downloads")
sourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(sourceURL, 'rawdata.zip')
zFiles <- unzip(zipfile="rawdata.zip")

## Load data into variables
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subj.train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
X.test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subj.test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Merge train and test data
data.subject <- rbind(subj.train,subj.test)
data.activity <- rbind(y.train, y.test)
data.features <- rbind(x.train,X.test)

names(data.subject) <- c("subject")
names(data.activity) <- c("activity")
data.features.names <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(data.features) <- data.features.names[,2]

Data <- cbind(data.subject, data.activity, data.features)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  
file.features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
mean.std <- file.features[grep("-(mean|std)\\(\\)",file.features[,2]),2]
selected <- c(as.character(mean.std), "subject","activity")
tidydata <- subset(Data, select=selected)

# 3. Uses descriptive activity names to name the activities in the data set

label.activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
tidydata$activity <- label.activity[tidydata$activity,2]

# 4. Appropriately labels the data set with descriptive variable names.
names.temp <- names(tidydata)
names.temp <- gsub("\\()","", names.temp)
names.temp <- gsub("Acc", "Accelerometer", names.temp)
names.temp <- gsub("BodyBody", "Body", names.temp)
names.temp <- gsub("^f", "FrequencyDomain", names.temp)
names.temp <- gsub("Gyro", "Gyroscope", names.temp)
names.temp <- gsub("Mag", "Magnitude", names.temp)
names.temp <- gsub("-mean", "_Mean_", names.temp)
names.temp <- gsub("-std", "_StandardDeviation_", names.temp)
names.temp <- gsub("^t", "TimeDomain", names.temp)
names(tidydata) <- names.temp

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata2 <- aggregate(. ~subject + activity, tidydata,mean)
tidydata2 <- tidydata2[order(tidydata2$subject,tidydata2$activity),]
write.table(tidydata2, file = "../philip.vallejo@gmail.com/coursera/GettingAndCleaningData/tidydata.txt",
            sep= " ", 
            row.names = FALSE)
