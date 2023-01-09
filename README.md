# IMI2
This is a fuzzy CVI for imbalanced data sets.

# Usage
[clusteringLabel, k_imi2]=IMI2(X, kmin, kmax, IterNum)
# Input
X: feature matrix, N*m. N is the number of data point, and m is the dimension of features.
kmin and kmax: the minimum and maximum numbers of clusters respectively, kmax should be greater than kmin
IterNum: the runs number of FCM with each number of clusters to avoid the intial sensitivity of FCM.
# Output
clusteringLabel: the clustering label of each data point.
k_imi2: the number of clusters determined by IMI2.
