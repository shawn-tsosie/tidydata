---
title: "README"
output: github_document
---

This script will the UCI HAR dataset and ouput a tidy data set containing the means, ordered by subject ID and activity, of specific attributes of the original dataset.

First, the script checks whether or not a `~/tidydata/` folder exists.  If it doesn't, then it creates it.
Next, the script downloads the UCI HAR dataset from:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "UCI HAR Dataset")
and saves it to `HAR.zip`.

The script then combines the test data to one file and it does the same for the train data.
It then combines both of these files into one large dataset and arranges the dataset by subject ID.

The script extracts the activity labels and it extracts the feature labels.
Then it saves them to file.
After changing the labels from factors to characters, the script labels the columns with the feature names.
The script then removes the parentheses and commas from the column names.
The script also changes the activity labels from their numeric values to their character values as indicated in the `activity_labels.txt` file in the UCI HAR dataset.

The script then gets rid of duplicate column names and then selects only those which have `mean` and `std` in the name.
It then creates a new table titled `meanstdData` which contains only the mean for each column grouped by subject ID and activity.

Finally, the script writes `meanstdData` to `tidydata.txt`.
