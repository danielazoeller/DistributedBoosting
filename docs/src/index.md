#Distributed Boosting

Distributed Boosting is a package which can be used to analize SNP-data. It tries to find the most relevant SNPs following a covariance-based boosting algorithm with block-heuristic behaviour. Its meant to make it easy to merge data of different data sets with respect to clinical data protection contraints. To achieve that you don´t need individual data tu run the boosting algorithm, the individual data is standardized to achieve comparability between different data sets. The basis for analyzing data are the univariate estimators und the covariances based on the individual data. The provided data will be pooled and the boosting algorithm can be performed. 

Since the data which should be analized can be a large amount of data only a subset of the data is called step by step. So the boosting algorithm performs boostingsteps as long as no new data is needed. Instead of providing only the covariances that are needed in one certain boostingstep the algorithm provides whole blocks of data and the poled covariance matrix is expanded after every data call resulting in a smaller amount of data calls compared to the classic heuristic approach. 

