#run_analysis.R 
#insert description of this script/function
#######################
run_analysis <-function(){
  
   #load required packages
  rm(list=ls())
  library(dplyr)
  library(stringr)
  library(gdata)
  
  #downloading and unzipping data files
  url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  #download.file(url,"data.zip")
  #unzip("data.zip")
  sourcedir<-list.dirs(recursive = FALSE)
  destdir<-"./"
  for (i in 1:length(sourcedir)){
    filelist<-list.files(sourcedir[i],"*.txt")
    fullfilelist<-paste(sourcedir[i],filelist,sep = "/")
    file.copy(fullfilelist,destdir)
  }
  sourcedir2<-list.dirs(sourcedir,recursive = FALSE)
  
  
  for (i in 1:length(sourcedir2)){
    filelist<-list.files(sourcedir2[i],"*.txt")
    fullfilelist<-paste(sourcedir2[i],filelist,sep = "/")
    file.copy(fullfilelist,destdir)
  }
  
  
  #read and merge training data
  df_train_main<-read.table("X_train.txt",stringsAsFactors = FALSE)
  df_train_activity<-read.table("y_train.txt",stringsAsFactors = FALSE)
  df_train_subject<-read.table("subject_train.txt",stringsAsFactors = FALSE)
  df_features<-read.table("features.txt",stringsAsFactors = FALSE)
  colnames(df_train_main)<-df_features[,2]
  df_train_total<-cbind(df_train_subject,df_train_activity,df_train_main)
  colnames(df_train_total)[1]<-"subject"
  colnames(df_train_total)[2]<-"activity"
  #######################
  #read and merge test data
  df_test_main<-read.table("X_test.txt",stringsAsFactors = FALSE)
  df_test_activity<-read.table("y_test.txt",stringsAsFactors = FALSE)
  df_test_subject<-read.table("subject_test.txt",stringsAsFactors = FALSE)
  colnames(df_test_main)<-df_features[,2]
  df_test_total<-cbind(df_test_subject,df_test_activity,df_test_main)
  colnames(df_test_total)[1]<-"subject"
  colnames(df_test_total)[2]<-"activity"
  
  #######################
  #merge training and test data, filter out only mean and std columns, 
  df_merged_total<-rbind(df_train_total,df_test_total)
  #df_merged_total<-arrange(df_merged_total,subject,activity)
  #df_merged_total_sample<-rbind(df_train_total,df_test_total)
  
  #rename activities by descriptive names
  df_activity<-read.table("activity_labels.txt",stringsAsFactors = FALSE)
  df_activity[,1]<-as.character(df_activity[,1])
  df_activity[,2]<-str_replace_all(df_activity[,2],"WALKING_UPSTAIRS","WK_USTRS")
  df_activity[,2]<-str_replace_all(df_activity[,2],"WALKING_DOWNSTAIRS","WK_DSTRS")
  df_merged_total$activity<-as.character(df_merged_total$activity)
  n<-length(df_activity[,1])
  for (i in 1:n) {
    df_merged_total$activity<-str_replace_all(df_merged_total$activity,df_activity[i,1],df_activity[i,2])
  }
  
  #select only columns containing 'mean' or 'std' in the names
  temp<-names(df_merged_total)
  order1<-grep('*mean*',temp)
  order2<-grep("*std*",temp)
  order3<-sort(c(1,2,order1,order2))
  df_cleaned_total<-df_merged_total[,order3]
  
  #rename the columns according to codebook
  
  mynames<-names(df_cleaned_total)
  mynames2<-str_replace_all(mynames,"\\(\\)","")
  mynames3<-str_replace_all(mynames2,"Body","")
  mynames4<-str_replace_all(mynames3,"^t","time_")
  mynames5<-str_replace_all(mynames4,"^f","freq_")
  mynames6<-str_replace_all(mynames5,"-","_")
  mynames7<-str_replace_all(mynames6,"Gravity","Grav")
  colnames(df_cleaned_total)<-mynames7
  
  
  #######################
  #sort df_cleaned_total by subject then activity
  df_cleaned_total<-arrange(df_cleaned_total,subject,activity)
  #create tidy data set
  df2<-group_by(df_cleaned_total,subject,activity)
  df_tidy<-as.data.frame(summarise_each(df2,funs(mean)))
  ## rename the columns by pre-pending 'mean_'
  temp01<-names(df_tidy)
  temp02<-paste("mean_",temp01[3:length(temp01)],sep = "")
  temp03<-c(temp01[1:2],temp02)
  colnames(df_tidy)<-temp03
  ## format the number columns to limit the each number to 10 digits
  tt<-format(round(df_tidy[3:length(temp01)],8),nsmall = 8)
  df_tidy<-cbind(df_tidy[,1:2],tt)

    #generate final tidy output table as well as exporting 
  #a data frame into the global environment in case required
  #write.table(df_tidy,"final_tidy_dataset3.txt",sep = "\t\t")
  write.fwf(df_tidy,"final_tidy_dataset.tx",justify = "centre", sep = "\t\t")
  return(Final_tidy_data<<-df_tidy)

}

#######the end###########