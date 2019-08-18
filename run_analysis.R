
library(dplyr)
library(reshape2)


#' This function is used to download zip file
#' and extract it. only if it is not already downloaded

downloadFile <- function(url,filename)
{
  if(!file.exists(filename))
  {
    download.file(url = url, destfile = filename)
    unzip(filename)
  }
  else
  {
    print("File already exists!")
  }
}

#' this function merges the two given data set along the row
#'
#'@author Rajesh k S
#'

merge_data_set <- function(ds1,ds2)
{
  rbind(ds1,ds2)
}

#'find mean or std and then clean up and assign as Std, Mean
#'
#'
getFeatures <- function(aFeatures,featuresWanted)
{
  featuresWanted.names <- aFeatures[featuresWanted,2]
  featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
  featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
  featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
  return(featuresWanted.names)
}

#'
#'load data given X,Y, subjects and wanted features
#'
loadData <- function(X,Y,subject,featuresWanted)
{
  train <- read.table(X)[featuresWanted]
  trainActivities <- read.table(Y)
  trainSubjects <- read.table(subject)
  cbind(trainSubjects, trainActivities, train)
}

myfilename <- "dataset.zip"
downloadFile("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",myfilename)

# activity labels contains activity tracked like walking etc
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses = c("numeric","character"))
features <- read.table("UCI HAR Dataset/features.txt")

featuresWanted <- grep("mean|std", features[,2])
featuresWanted.names <- getFeatures(features,featuresWanted)


#load the training data set
train <- loadData(X="UCI HAR Dataset/train/X_train.txt",Y="UCI HAR Dataset/train/Y_train.txt",subject = "UCI HAR Dataset/train/subject_train.txt",featuresWanted)


#load test data
test <- loadData(X="UCI HAR Dataset/test/X_test.txt",Y="UCI HAR Dataset/test/Y_test.txt",subject ="UCI HAR Dataset/test/subject_test.txt",featuresWanted)


mergedData <- merge_data_set(train, test)
colnames(mergedData) <- c("subject", "activity", featuresWanted.names)

# turn activities into factor with label so that we see 'WALKING' in tidy data
#instead of digits
mergedData$activity <- factor(mergedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#lookup the doumentation of melt seems that without creating factor also this should work,
#since melt works on id and uses as factor. The only reason why we created factor above was to have readable string

mergedData.melted <- melt(mergedData, id = c("subject", "activity"))
mergedData.mean <- dcast(mergedData.melted, subject + activity ~ variable, mean)
write.table(mergedData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
