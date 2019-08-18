# assignment4datacleaning
assignment 4 data cleaning coursera course
run_analysis.R script does following
1) download zip file and unzip in the project folder.
2) read activity labels like 1-WALKING, 2- WALKING-UPSTAIRS etc.
3) read features like 1-tBodyAcc-mean()-X, 2-tBodyAcc-mean()-Y etc.
4) get all the feature names which has mean or std
5) load train and test dataset, merge them
6) melt the data with id=subject and activity
7) dcast and aggregate using mean function
