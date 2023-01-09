# IMI2
This is a fuzzy CVI for imbalanced data sets.  

# Usage
[clusteringLabel, k_imi2]=IMI2(X, kmin, kmax, IterNum)  
Please check the demo.doc for how to use 
## Input
1. X: Feature matrix, N*m. N is the number of data point, and m is the dimension of features.  
2. kmin and kmax: The minimum and maximum numbers of clusters respectively, kmax should be greater than kmin.  
3. IterNum: The runs number of FCM with each number of clusters to avoid the intial sensitivity of FCM.  
## Output
1. clusteringLabel: The clustering label of each data point.  
2. k_imi2: The number of clusters determined by IMI2.  
# Contact
liuyun313@jlu.edu.cn
