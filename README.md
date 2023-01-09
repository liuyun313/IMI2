# IMI2
This is a fuzzy CVI for imbalanced data sets.  

# Usage
[clusteringLabel, k_imi2]=IMI2(X, kmin, kmax, IterNum)  
## Input
### X
Feature matrix, N*m. N is the number of data point, and m is the dimension of features.  
### kmin and kmax
The minimum and maximum numbers of clusters respectively, kmax should be greater than kmin.  
### IterNum
The runs number of FCM with each number of clusters to avoid the intial sensitivity of FCM.  
## Output
### clusteringLabel The clustering label of each data point.  
### k_imi2
The number of clusters determined by IMI2.  
