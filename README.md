# Welcome to my project for this week!

Our first step is to load the libraries we'll use: dplyr and tidyr.

```{r}
library(dplyr)
library(tidyr)
```

## Step 1: Load and merge data

A small function is made, so the workspace stays clean.

```{r}
load_data <- function()
{
```

Now, we load our feature names, which are in the second column of the "features.txt" file:

``` {r}
    # Read feature names
    feature_names <- read.table("UCI HAR Dataset/features.txt",
                                as.is = TRUE)[, 2]
```

We proceed by reading the train and test data with subjects, activities and the measured data:

```{r}
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
```

And we merge everything into a tbl_df:

```{r}
    # Merge both data sets
    tbl_df(rbind(train_table, test_table))
}
```

Now, we simply have to call our function and it'll do everything we need:

```{r}
data <- load_data()
rm("load_data")
```

## Step 2: Extract only "mean" and "std" columns

We extract only the measurements on the mean and standard deviation for each measurement, by using the **grepl** function to identify the presence of substrings "mean" and "std" in our column names defined in the previous step:

```{r}
selected_cols = grepl("mean", colnames(data)) |
                grepl("std", colnames(data))

# Also select columns "subject" and "activity"
selected_cols[1:2] = TRUE

data <- data[selected_cols]
rm("selected_cols")
```

## Step 3: Map activities to their respective names

Now we simply read the "activity_labels.txt" file and map our previously numeric data to the six factors corresponding to the six activities in the dataset:

```{r}
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
data <- mutate(data, activity = activities[activity, 2])
rm("activities")
```

## Step 4: Name our columns appropriately

This step can be safely skipped as we have done this when loading data.

## Step 5: Generate statistics with means for subjects, per activity

Group data by subject and activity and summarize each column, except the "subject" and "activity" columns.

```{r}
avg_data <- data %>% 
            group_by(subject, activity) %>%
            summarize_each(funs(mean(.)), -subject, -activity)
```

## Final thoughts:

At this point, only two things from our code will be available to the environment: *data*, the loaded and neatly formatted data from the training and test datasets merged and *avg_data*, our grouping of means for subjects per activities.

Thanks for reading and I hope you liked it!