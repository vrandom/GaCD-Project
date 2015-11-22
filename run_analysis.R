library(dplyr)
library(tidyr)

load_data <- function()
{
    # Read feature names
    feature_names <- read.table("UCI HAR Dataset/features.txt",
                                as.is = TRUE)[, 2]
    
    # Read train data
    train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt",
                                col.names = "subject")
    train_activities <- read.table("UCI HAR Dataset/train/y_train.txt",
                                  col.names = "activity")
    train_data <- read.table("UCI HAR Dataset/train/X_train.txt",
                            check.names = FALSE,
                            col.names = feature_names)
    train_table <- cbind(train_subjects, train_activities, train_data)
    
    # Read test data
    test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt",
                                col.names = "subject")
    test_activities <- read.table("UCI HAR Dataset/test/y_test.txt",
                                  col.names = "activity")
    test_data <- read.table("UCI HAR Dataset/test/X_test.txt",
                            check.names = FALSE,
                            col.names = feature_names)
    test_table <- cbind(test_subjects, test_activities, test_data)
    
    # Merge both data sets
    tbl_df(rbind(train_table, test_table))
}

data <- load_data()
rm("load_data")

# Extract only the measurements on the mean and standard deviation for each measurement.
selected_cols = grepl("mean", colnames(data)) |
                grepl("std", colnames(data))

# Also select columns "subject" and "activity"
selected_cols[1:2] = TRUE

data <- data[selected_cols]
rm("selected_cols")

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
data <- mutate(data, activity = activities[activity, 2])
rm("activities")

# Group data by subject and activity and summarize each column,
# except the "subject" and "activity" columns.

avg_data <- data %>% 
            group_by(subject, activity) %>%
            summarize_each(funs(mean(.)), -subject, -activity)

# Avoid returning data so RStudio won't draw its View.
return(NULL)
