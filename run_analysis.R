#Load data

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
features <- read.table("features.txt")
activityLabels = read.table("activity_labels.txt")

#Give names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merge

all_train <- cbind(y_train, subject_train, x_train)
all_test <- cbind(y_test, subject_test, x_test)
all<- rbind(all_train, all_test)

#extract mean and std

col<-colnames(all)
mean_and_std <- ( grepl("mean.." , col) | 
                   grepl("std.." , col) )

allmeanstd <- all[ , mean_and_std == TRUE]

#Activity names

allactivityNames <- merge(allmeanstd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#creating second tidy dataset

tidy <- aggregate(. ~subjectId + activityId, allactivityNames, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]
write.table(tidy, "tidy.txt", row.name=FALSE)
