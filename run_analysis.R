library(dplyr)

# Checks if the tidydata directory exists and creates it if it does not exist.
if (!file.exists("tidyata")) {
        dir.create("tidydata")
}

setwd("tidydata/")

# Downloads the UCI HAR dataset.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="HAR.zip")

# Unzips the UCI HAR dataset file
unzip("HAR.zip")

setwd("tidydata/UCI HAR Dataset/")

# Read and then merge the test data.
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")

testData <- cbind(subject_test, Y_test, X_test)
names(testData)[1] <- "subject.id"
names(testData)[2] <- "activity"

# Read and then merge the train data.
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")

trainData <- cbind(subject_train, Y_train, X_train)
names(trainData)[1] <- "subject.id"
names(trainData)[2] <- "activity"

# Number 1
# Merge the test and train data and then sort by subject id.
activityData <- rbind(testData, trainData)
activityData <- arrange(activityData, subject.id)

# Saves the feature labels into a table and converts names to characters.
# Additionally, it cleans up the feature labels.
featureLabels <- read.table("features.txt")
featureLabels[,2] <- as.character(featureLabels[,2])
featureLabels[,2] <- gsub("\\(|\\)|,", "", featureLabels[,2])

# Saves the activity lables into a table and converts names to characters.
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
activityLabels[,2] <- tolower(activityLabels[,2])
activityLabels[,2] <- gsub("_", ".", activityLabels[,2])

# Number 4
# Relabels the column names.
names(activityData)[2] <- "activity"
names(activityData)[3:length(names(activityData))] <- featureLabels[,2]

# Number 3
# Relabels the activities.
for(j in 1:dim(activityData)[1]) {
        for(i in activityLabels[,1]) {
                if(activityLabels[i,1]==activityData[j,2]) {
                        activityData[j,2] <- activityLabels[i,2]
                }
        }
}

# Number 2
# Selects only the columns that are concerned with mean and standard deviation.
# First, drops the duplicated names so that select can be used.
activityData <- subset(activityData, 
                       select=which(!duplicated(names(activityData))))
# Selects the columns that contain mean or data.
activityData <- select(activityData, 
                       "subject.id",
                       "activity",
                       matches("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]"))

# Number 5
# Create new data set and add the mean and standard deviation 
meanstdData <- activityData %>% 
        select("subject.id", 
               "activity",
               matches("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]"))

meanstdData <- meanstdData %>% 
        group_by(subject.id, activity) %>%
        summarize_all(mean)

# Writes the tidy data set to file.
setwd("..")
write.table(meanstdData, file="tidydata.txt", sep=" ", row.names=FALSE)