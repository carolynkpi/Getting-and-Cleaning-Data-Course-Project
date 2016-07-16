##SECTION 1: load required libraries
library(reshape2)

##SECTION 2: read files
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

##SECTION 3: Extracts only the measurements on the mean and standard deviation for each measurement.
#assumes meanFeq is not part of the required data.
#if meanFreq needs to be counted, replace firt code below with 
#meanIndex <- grepl("mean",features$V2)

meanIndex <- grepl("mean[()]",features$V2)  
stdIndex <- grepl("std[()]",features$V2)
x_test <- x_test[,meanIndex|stdIndex]
x_train <- x_train[, meanIndex|stdIndex]
features <- features[meanIndex|stdIndex, ]

##SECTION 4: Appropriately labels the data set with descriptive variable names.
names(x_test) <- features[,2]
names(x_train)<- features[,2]
names(y_test)<- "activityid"
names(y_train)<- "activityid"
names(subject_test) <- "subjectid"
names(subject_train) <- "subjectid"
names(activity)<- c("activityid", "activityname")

##SECTION 5: Merge the training and the test sets to create one data set.
subject_test$subjectcategory <- "test"
subject_train$subjectcategory <- "train"
test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)
data <- rbind(test, train)

##SECTION 6: Uses descriptive activity names to name the activities in the data set
data <- merge(activity,data)

##SECTION 7: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
measures <- names(data[,5:ncol(data)])
dataMelt <- melt(data, id= c("subjectid","activityname"), measure.vars = measures)
dataMelt$subjectid <- as.factor(dataMelt$subjectid)
data2 <- recast(dataMelt, subjectid+activityname~variable,mean)
names(data2) <- gsub("[()]", "", names(data2))
names(data2) <- gsub("[-]", ".", names(data2))
write.table(data2, file = "HAR Experimental Data Summary.txt", row.name = FALSE)

###CODES TO READ THE RESULTING DATA INTO R ############
#readData <- read.table("HAR Experimental Data Summary.txt", header =TRUE)
#View(readData)
#######################################################

