URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "~/Documents/Project/CourseProject.zip")
unzip("~/Documents/Project/CourseProject.zip",exdir = "~/Documents/Project")

#merging training and test sets to create one dataset
