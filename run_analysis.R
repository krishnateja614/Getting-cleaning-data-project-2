traindata = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
traindata[,562] = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
traindata[,563] = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testdata = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testdata[,562] = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testdata[,563] = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features 
features = read.csv("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", sep="", header=FALSE)
# Better naming for features
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and test sets 
fullData = rbind(traindata, testdata)

# Get only mean and std. dev from features.
reqCols <- grep(".*Mean.*|.*Std.*", features[,2])

# Reduce the features table to what we want
features <- features[reqCols,]

# Add the last two columns subject and activity
reqCols <- c(reqCols, 562, 563)

# Remove the unwanted columns from fullData
fullData <- fullData[,reqCols]
# Add the column names (features) to fullData
colnames(fullData) <- c(features$V2, "Activity", "Subject")
colnames(fullData) <- tolower(colnames(fullData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  fullData$activity <- gsub(currentActivity, currentActivityLabel, fullData$activity)
  currentActivity <- currentActivity + 1
}

fullData$activity <- as.factor(fullData$activity)
fullData$subject <- as.factor(fullData$subject)

tidy = aggregate(fullData, by=list(activity = fullData$activity, subject=fullData$subject), mean)

# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL

#Writing to a file named tidy.txt
write.table(tidy, "tidydata.txt", sep="\t")