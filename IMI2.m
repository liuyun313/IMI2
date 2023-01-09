function [clusteringLabel,k_imi2]=IMI2(X,kmin,kmax,IterNum)
%%%%-------This is a fuzzy CVI for imbalanced data sets-------
% X is the feature matrix, N*m
% kmin and kmax are the minimum and maximum numbers of clusters
% respectively, kmax should be greater than kmin
% IterNum is the runs number of FCM with each number of clusters

if kmin>=kmax
    error("kmax should be greater than kmin");
end

%%---------delete objects that contains missing features-----------
missing=isnan(X);
if ~isempty(find(missing==1))
    c=X;
    c(any(missing'),:) = [];
    X=c(:,1:end-1);
end

k=[kmin:kmax];
q=2;
[N,m]=size(X);

%%--------------Normalization----------------
max_value=max(X);
X1=X./(ones(N,1)*max_value);
%%--------------Initial clustering by IMI----------------
Center=cell(length(k),1);
U=cell(length(k),1);
imi=zeros(IterNum,length(k));
for i=1:length(k)
    imi_min=1e50;
    for j=1:IterNum
        [center,u,o]=fcm(X1, k(i),[2;100;0;0]);
        center=center';
        u=u';
        [imi(j,i)]=IMI(u,center,q,X1');
        if imi(j,i)<imi_min
            imi_min=imi(j,i);
            Center{i}=center;
            U{i}=u;
        end
    end
end

Imi=min(imi);
[~,k_imi]=min(Imi);
k_imi=k_imi+k(1)-1;

%%--------------Determine which clusters should be merged----------------
center=Center{k_imi-k(1)+1};
u=U{k_imi-k(1)+1};

[a,I]=max(u,[],2);
[imi1,com,sep,com1]=IMI(u,center,q,X1');
[com,com_index]=sort(com);
com=com/sum(com);
x=com>=1/k_imi;
com_index1=com_index(x);

sep_index=sep(:,2:3);
sep=sep(:,1);
[sep,sep_idx]=sort(sep);
sep_index=sep_index(sep_idx,:);

figure
plot(sep,'*-')

% 
% figure
% gscatter(X1(1,:),X1(2,:),I)

%%--------------Final clustering----------------
num=input('the number of merged clusters=');
merged_clusters=reshape(sep_index(1:num,:),[],1);
if length(unique(merged_clusters))==k_imi
    clusteringLabel=I;
else
    idx=zeros(num,1);
    clu=0;
    for i=1:num-1
        if idx(i)==0        
            clu=clu+1;
            idx(i)=clu;
        end
        for j=i+1:num
            if idx(j)~=0
                continue
            end
            if ~isempty(intersect(sep_index(i,:),sep_index(j,:)))            
                idx(j)=idx(i);
            end
        end
    end

    if idx(num)==0
        clu=clu+1;
        idx(num)=clu;
    end

    clusteringLabel=I;
    for i=1:max(idx)
        a=find(idx==i);
        merge=sep_index(a,:);
        merge=reshape(merge,[],1);
        merge=unique(merge);
        merge=sort(merge);
        for j=2:length(merge)
            clusteringLabel(clusteringLabel==merge(j))=merge(1);
        end
    end

    for i=max(clusteringLabel):-1:1
        while isempty(find(clusteringLabel==i, 1))
            clusteringLabel(clusteringLabel>i)=clusteringLabel(clusteringLabel>i)-1;
        end
    end
end

k_imi2=length(unique(clusteringLabel)); 


function [cvi,compactness1,d,com]=IMI(u,v,q,X)
%%clustering validity index for FCM method, considering cluster sizes.
k=size(v,2);
N=size(X,2);
%%compactness
f=sum(u)/N;
com=[];
for j=1:k
    a=EuclidDist(X,v(:,j)*ones(1,N));
    a=a';
    a=a.^2.*u(:,j).^q;
    com(:,j)=a;
    compactness(j)=sum(a)/sum(u(:,j));
end
compactness1=compactness;
compactness=sum(compactness);
%%separation
d=[];
d_index=[];
d_min=[];
for i=1:k-1
%     d_1=[];
    for j=i+1:k
        if f(i)>f(j)
            delta=f(i)/f(j);
        else
            delta=f(j)/f(i);
        end
        d1=EuclidDist(v(:,i),v(:,j));
        d=[d,d1^2*delta];   
        d_index=[d_index;i,j];
    end
end
% d(d==0)=[];
% d_min=[d_min',d_index];
if sum(d)==0
    print("All clusters are the same!")
    cvi=-1;
else
    separation=min(d)+median(d);
    d=[d',d_index];    
    cvi=compactness/separation;
end
