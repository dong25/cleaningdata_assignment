#Getting and Cleaning Data: Course Assignment (Week 4)
##Introduction
This repository includes all the R scripts and supporting files to execute the Course Assignment for Getting and Cleaning Data. The purpose of this project is to clean up fitness data collected from Samsung Galaxy S Smartfone worn 30 subjects taking part into 6 different activities. 

##analysis.R
The main R script 'analysis.R' performs the following functions
- load required packages
- download and unzip raw data files - this step can be skipped if files are already downloaded and unzipped
- read and merge sets of data related to training subsets - about 70% of the subjects
- read and merge sets of data related to test subjects - the remaining 30% of subjects
- extract only columns related to mean and standard deviations of various parameters;
- rename columns so that they are meaningful
- generate the final tidy data set which has the average of each variable for each activity and each subject


##Code execution
- clone this repo
- run 'anslysis.R'
- final tidy dataset is named 'final_tidy_dataset.txt' - a tab delimited text file, located in the working directory.

##Code Book
The CodeBook.ms file explains the strcuture of the raw data, the transformation process and the strucuture of the finally generated tidy dataset.

