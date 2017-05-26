Codebook
========

Description of measurements
---------------------------

-   t = time
-   f = frequency
-   Body = body movement.
-   Gravity = acceleration of gravity
-   Acc = accelerometer measurement
-   Gyro = gyroscopic measurements
-   Jerk = sudden movement acceleration
-   Mag = magnitude of movement

Data Set Information:
---------------------

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by
applying noise filters and then sampled in fixed-width sliding windows.
From each window, a vector of features was obtained by calculating
variables from the time and frequency domain.

### 1. Merges the training antd the test sets to create one data set.

-   Download from URL and unzip file
-   name of zip file is rawdata.zip
-   rawdata.zip contains UCI HAR Dataset folder
-   Read the files from UCI HAR Dataset folder. the folder consists of
    y\_train.txt, subject\_train.txt, X\_test.txt
-   Organize data by subject, activity, and features. Subject consists
    of files subject\_train.txt and subject\_test.txt. Activity consists
    of y\_train.txt and y\_test.txt while features consists of
    X\_train.txt and X\_test.txt.
-   column names were assigned to dataset such as subject, activity, and
    columns retrieved from features.txt. Data from subject, activity,
    and features were combined using cbind.

<!-- -->

    #### Download and unzip file
    setwd("C:/Users/Dell/Downloads")
    sourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(sourceURL, 'rawdata.zip')
    zFiles <- unzip(zipfile="rawdata.zip")

    #### Load data into variables
    x.train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
    y.train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
    subj.train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
    X.test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
    y.test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
    subj.test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

    #### Merge train and test data
    data.subject <- rbind(subj.train,subj.test)
    data.activity <- rbind(y.train, y.test)
    data.features <- rbind(x.train,X.test)

    names(data.subject) <- c("subject")
    names(data.activity) <- c("activity")
    data.features.names <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
    names(data.features) <- data.features.names[,2]

    Data <- cbind(data.subject, data.activity, data.features)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

-   dataset was filtered to data containing mean and standard deviation.
    The result was use to create a new subset called tidydata. Tidydata
    contains rows that has mean and standard deviation.

<!-- -->

    file.features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
    mean.std <- file.features[grep("-(mean|std)\\(\\)",file.features[,2]),2]
    selected <- c(as.character(mean.std), "subject","activity")
    tidydata <- subset(Data, select=selected)

### 3. Uses descriptive activity names to name the activities in the data set

-   column V1 from activity\_labels.txt was mapped to column activity of
    tidydata to replace the column activity with V2 data.

<!-- -->

    label.activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
    tidydata$activity <- label.activity[tidydata$activity,2]

### 4. Appropriately labels the data set with descriptive variable names.

-   tidydata was laeled properly through the use of gsub.

<!-- -->

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

### 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

-   tidydata2 contains average of each variable for each activity
    and subject. This was sorted by subject and activity and written in
    file name tidydata.txt

<!-- -->

    tidydata2 <- aggregate(. ~subject + activity, tidydata,mean)
    tidydata2 <- tidydata2[order(tidydata2$subject,tidydata2$activity),]
    write.table(tidydata2, file = "tidydata.txt",
                sep= " ", 
                row.names = FALSE)

The resulting data table has 180 rows and 68 columns consisting of 33
Mean variables + 33 Standard deviation variables + Subject + Activity.
