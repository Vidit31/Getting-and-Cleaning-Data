if(!dir.exists("./Data")){
  dir.create("./Data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Data/data.zip")
setwd("./Data")
unzip("data.zip")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt") 

#Merging of test and train sets
dat <- rbind(X_train,X_test)

#extraction of Mean and Standard deviation columns
MeanStd <- grep("std()|mean()", features[, 2]) 
dat <- dat[,MeanStd]

#appropriate labelling of variable names
Colnames <- sapply(features[, 2], function(l) {gsub("[()]", "",l)})
names(dat) <- Colnames[MeanStd]

#combining subject and activity data of test and train and giving descriptive column names
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

#forming complete dataset
dat <- cbind(subject,activity, dat)

#labeling of activity
activ <- factor(dat$activity)
levels(activ) <- activity_labels[,2]
dat$activity <- activ

library("reshape2")

#independent tidy dataset
bdata <- melt(dat,(id.vars=c("subject","activity")))
TidData <- dcast(bdata, subject + activity ~ variable, mean)
names(TidData)[-c(1:2)] <- paste("mean of" , names(TidData)[-c(1:2)] )
write.table(TidData, "tidy_data.txt", sep = ",")