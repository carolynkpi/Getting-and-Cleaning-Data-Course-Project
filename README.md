## Coursera Getting and Cleaning Data Course Project
#### Submission by Carolyn Koay

<br>

###This submission includes the following files:  

* **'README.md'**
* **'HAR Experimental Data Summary.txt'** : contains the dataset.   
 Read the dataset with the following codes.
 
>readData <- read.table("HAR Experimental Data Summary.txt", header =TRUE)  
>View(readData)  

* **'CodeBook.md'** : contains the dataset's description and study design. 
* **'run_analysis.R'** : contains the R script that processes the raw data to the dataset.  

<br>

###Raw data
The raw data comes from the Human Activity Recoginition Experiment conducted by Davide et al (2012) [1].  
The raw data can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

* **"./test/subject_test.txt"**: contains the subject id for each observation in the test set. 
* **"./test/X_test.txt"**: contains the values of the 561 measurements for each observation in the test set.  
* **"./test/y_test.txt"**: contains the activity id for each observation in the test set. 
* **"./train/subject_train.txt"**: contains the subject id for each observation in the train set. 
* **"./train/X_train.txt"**: contains the values of the 561 measurements for each observation in the train set.  
* **"./train/y_train.txt"**: contains the activity id for each observation in the train set. 
* **"activity_labels.txt"**: contains the list of activities in the experiment.    
* **"features.txt"**: contains the list of 561 measurements in the experiment.  

<br> 

###run_analysis.R
The following sections will describe the methodology of the run_analysis.R script in detail.   
  
<br>

####Section 1
This section loads the reshape2 package required to run the script. Please install this package if you have not already done so.  

<br>

####Section 2
This section reads the downloaded raw files into data frames in R.  The data frames are named similarly to the original text file for easy traceback. There is a total of 8 raw files read into 8 data frames. 

<br>
**R objects:**

* **subject_test**: data frame that contains the subject id for each observation in the test set. 
* **x_test**: data frame that contains the values of the 561 measurements for each observation in the test set.  
* **y_test**: data frame that contains the activity id for each observation in the test set. 
* **subject_train**: data frame that contains the subject id for each observation in the train set. 
* **x_train**: data frame that contains the values of the 561 measurements for each observation in the train set.  
* **y_train**: data frame that contains the activity id for each observation in the train set. 
* **activity**: data frame that contains a list of activities in the experiment.    
* **features**: data frame that contains a list of 561 measurements in the experiment.  

<br>

####Section 3
This section extracts only the required measurements (mean and standard deviation) from the dataset. 

Column index of the required measurements is obtained from the **features** data frame. 
This index is then used to subset the columns in the **x_test**, **x_train** and **features** data frames. 

It is assumed the _meanFreq_ is not part of the required measurements. If it is, replace  

>meanIndex <-grepl("mean[()]",features$V2)  

with 

>meanIndex <- grepl("mean",features$V2)  

<br>
**R objects:**

* **meanIndex**: logical vector with TRUE values for any rows in **features$V2** containing the "mean()" string. 
* **stdIndex**: logical vector with TRUE values for any rows in **features$V2** containing the "std()" string. 

<br>

####Section 4
This section labels the data set with descriptive variable names for easier processing later.  

The **x_test** and **x_train** data frames have their columns named per the values in each row of the second column of **features** data frame. 

The **y_test**, **y_train**, **subject_test**, **subject_train** and **activity** data frames are named manually. 

<br>

####Section 5
This section first combines the subject, activity and measurement data into a single table for both the test set and the train set. 
Then the train set and the test set are joined to create one table.  

Both steps tidy up the data so that each observation type is in one table instead of multiple tables.

This is done in a way that preserved the original source of the dataset under the _subjectcategory_ variable with values being either "test" or "train".  

<br>
**R objects:**

* **subject_test$subjectcategory**: new variable for the *subject_test* data frame to store the test set category before joining.  
* **subject_train$subjectcategory**: new variable for the *subject_train* data frame to store the train set category before joining.  
* **test**: temporary data frame for the test set that combines the subject, the activity and the measurements as different columns in the data frame.
* **train**: temporary data frame for the train set that combines the subject, the activity and the measurements as different columns in the data frame.
* **data**: data frame with **test** and **train** joined. 

<br>

####Section 6
This section merges the **activity** and **data** data frames and overwrites the existing **data** with the resulting data frame.  

This merging will use _activityid_ as a key to match the activity names correctly to each observation. 

<br>

####Section 7
This section melts and recasts *data* to give the final data structure in the **HAR Experimental Data Summary** dataset. _subjectid_ and _activityname_ are used as id during melting and recast.  The _mean_ function is included into the _recast_ function to calculate the mean of the measurements for each subject and for each activity.  

After reshaping, the resulting data frame, *data2* has its columns renamed to standardize name strings to contain only "." special character. This is for consistency when reading data later. 

*data2* is then written to an output text file. 

<br>
**R objects:**

* **measures**: temporary vector to hold the names of the measurements.  
* **dataMelt**: temporary data frame to hold the melted data. 
* **data2**: data frame which is the final output data to be written out. 

<br>

The output data is tidy because: 

* Each row represents an observation for one subject doing one activity.  
* Each column is a variable describing one condition/measurement of each observation. 
* Only one kind of observation (test condition and measurement) is listed in this table. The activity and features tables are kept separately in other tables. 
* All the observations from the same kind of observation have been combined to one table (i.e. test and train sets are combined) 



<br>
**REFERENCES**

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012