## Mergeing the training and the test sets to create one data set.
## Extracting only the measurements on the mean and standard deviation for each measurement. 
## Useing descriptive activity names to name the activities in the data set
## Appropriately labeling the data set with descriptive variable names.
## Creating a second, from the data set in step 4, independent tidy data set with the average of each variable for each activity and each subject.
##@@@@@@@@@@@@@@@@@@@@@@@@@##


# Reading X_test.txt & y_test.txt data.
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("UCI HAR Dataset/test/y_test.txt")
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurement
XTest = XTest[,extract_features]

# Loading
YTest[,2] = activity_labels[YTest[,1]]
names(YTest) = c("Activity_ID", "Activity_Label")
names(SubjectTest) = "subject"

# Binding into the TestData
TestData <- cbind(as.data.table(subject_test), YTest, XTest)

# Reading
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("UCI HAR Dataset/train/y_train.txt")

SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

names(XTrain) = features
XTrain = XTrain[,extract_features]
YTrain[,2] = activity_labels[YTrain[,1]]
names(YTrain) = c("Activity_ID", "Activity_Label")
names(SubjectTrain) = "subject"

# Binding into TrainData
TrainData <- cbind(as.data.table(SubjectTrain), YTrain, XTrain)

# Merging
data = rbind(TestData, TrainData, fill=TRUE)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
MeltData = melt(data, id = id_labels, measure.vars = data_labels)

# Mean & writing the table write.table to the outpout folder
TidyData = dcast(MeltData, subject + Activity_Label ~ variable, mean)

## Creating a second, from the data set in step 4, independent tidy data set with the average of each variable for each activity and each subject.
write.table(TidyData, file = "./output/tidy_data.txt")
##@@@@@@@@@@@@@@@@@@@@@@@@@##
