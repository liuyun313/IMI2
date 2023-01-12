cd ./demo
d='D_5';
load (d)
X=X';
cd ..
[clusteringLabel, k_imi2]=IMI2(X, 2, 10, 10);
