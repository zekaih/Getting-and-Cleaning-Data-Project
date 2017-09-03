URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "~/Documents/Project/CourseProject.zip")
unzip("~/Documents/Project/CourseProject.zip",exdir = "~/Documents/Project")

#1. merging training and test sets to create one dataset
features <- read.table("~/Documents/Project/UCI HAR Dataset/features.txt")
activitylabels <- read.table("~/Documents/Project/UCI HAR Dataset/activity_labels.txt")

xtrain <- read.table("~/Documents/Project/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("~/Documents/Project/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("~/Documents/Project/UCI HAR Dataset/train/subject_train.txt")
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityID"
colnames(subjecttrain) <- "subjectID"
colnames(activitylabels) <- c("activityID","activityType")
trainingset <- cbind(ytrain,subjecttrain,xtrain)

xtest <- read.table("~/Documents/Project/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("~/Documents/Project/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("~/Documents/Project/UCI HAR Dataset/test/subject_test.txt")
colnames(xtest) <- features[,2]
colnames(ytest) <- "activityID"
colnames(subjecttest) <- "subjectID"
testset <- cbind(ytest,subjecttest,xtest)

mergedset <- rbind(trainingset,testset)

#2. extract measurements on mean and sd for each measurement
columnname <- colnames(mergedset)
matchname <- (grepl("mean..",columnname) | grepl("std..",columnname))
newmergedset <- mergedset[,matchname=="TRUE"]
newmergedset <- cbind(mergedset[,1:2],newmergedset)

#3. use descriptive activity names to name activities in the dataset
newmergedset1 <- merge(newmergedset,activitylabels,by="activityID",all.x = TRUE)
newmergedset1 <- newmergedset1[,2:82]
names(newmergedset1)[81] <- "activityID" 
summary(newmergedset1$activityID)

#4. approriately label dataset with descriptive variabl names
names(newmergedset1) <- gsub("^t","time",names(newmergedset1))
names(newmergedset1) <- gsub("^f","frequency",names(newmergedset1))
names(newmergedset1) <- gsub("Acc","Accelerometer",names(newmergedset1))
names(newmergedset1) <- gsub("Gyro","Gyroscope",names(newmergedset1))
names(newmergedset1) <- gsub("Mag","Magnitude",names(newmergedset1))

#5. create a second tidy data set and write to the directory as output
newmergedset2 <- aggregate(.~subjectID+activityID,newmergedset1,mean)
write.table(newmergedset2,file = "finaltidydataset.txt",row.names = FALSE)

