#install.packages("dplyr")
library(dplyr)

#set the wd
setwd("C:/Users/USER/Documents/getdata_projectfiles_UCI HAR Dataset")
getwd()

#read data
##label
activity_labels <- read.table("activity_labels.txt", header = F)
colnames(activity_labels) <- c("code", "activity")
##subject
train_subject <- read.table("train/subject_train.txt", col.names = "subject")
test_subject <- read.table("test/subject_test.txt", col.names = "subject")
##activity
train_activity <- read.table("train/y_train.txt", col.names = "code")
test_activity <- read.table("test/y_test.txt", col.names = "code")
###name the activity
test_activity <- merge(test_activity, activity_labels, by = c("code"))
train_activity <- merge(train_activity, activity_labels, by = c("code"))



##data
train_data <- read.table("train/x_train.txt")
test_data <- read.table("test/x_test.txt")
##feature
feature <- read.table("features.txt")
###only needed variables
feature_only_needed <- feature %>% filter(grepl('std|mean', V2)) %>% select(1)
feature_only_needed_2 <- feature %>% filter(grepl('std|mean', V2)) %>% select(2)

###select and name the variables
train <- train_data %>% select(feature_only_needed$V1)
names(train) <- feature_only_needed_2$V2
test <- test_data %>% select(feature_only_needed$V1)
names(test) <- feature_only_needed_2$V2


#cbind the data (activity and subject)
test <- cbind(test_activity, test_subject, test)
test <- test %>% select(-1)
train <- cbind(train_activity, train_subject, train)
train <- train %>% select(-1)

#rbind test and train data
all_raw <- rbind(test, train)
#summarize
outcome <- all_raw %>% group_by(subject, activity) %>%
                       summarize_all("mean")

#write table
write.table(outcome,"outcome.txt" ,row.names = F)
