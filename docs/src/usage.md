## Usage

To get in touch with the package one sample data set is provided. The data set contains two files which are meant to be merged and analized. The first step of using the package is to type

    using DistributedBoosting

The next step is to set the parameters for boosting. Let´s say we want to perform 100 boostingsteps, start with a covariance matrix which contains 10 different labels and we want to ask for 20 extra-labels which are called additionally to the labels which were selected because of the heuristic criterion. The resulting call would be

    DistributedBoosting.boosting(100, 10, 20, "path_out/boostscratch.h5")
	
This call creates a file with the information which is need to perform the algorithm. If the parameters are set, we can start providing the data. At first the algorithm needs the univariate estimators of each data set. A valid call for the sample data would be:

    DistributedBoosting.provide("path_to_pkg/TestData/exampleCohort1.h5", "path_to_store_the_estimators")

We got to data sets which should be merged, so we need to provide the estimators of the second data set as well:

    DistributedBoosting.provide("path_to_Pkg/TestData/exampleCohort2.h5", "path_to_store_the_estimators")	
	
Now the univariate estimators should be provided and can be added to the file which already contains the boosting parameters. The file will save the pooled estimators and covariances. To continue the estimators need to be pooled. Based on the pooled estimators the probably most relevant labels can be found. To proceed type:

    DistributedBoosting.boosting("path_to_boostscratch.h5","path_to_store_wantedlabels.h5",["paths_to_the_univariate_estimators.h5", "path_to_the_other_estimators.h5"])

The paths to the univariate estimators should be given as an array of stings to the function. Now the algorithm is able to decide which labels should be called first. We use a startblock of size 10 here, so the 10 labels with highest score are selected and added to a file called wantedlabels.h5 for example. Since we got the labels we can start providing covariances. For that, we need the provide function again.

    DistributedBoosting.provide("path_to_pkg/TestData/exampleCohort1.h5","path_to_store_the_covariance_matrix.h5", "path_to_the_wantedlabels.h5")

And for the second data set:	

     DistributedBoosting.provide("path_to_package/TestData/exampleCohort2.h5","path_to_store_the_covariance_matrix.h5", "path_to_the_wantedlabels.h5")
	 
The covariance matrices should be calculated now. To run the boosting with the calculated matrices you follow the same call used for pooling the univariate estimators. Just type the paths of the covariance matrices instead of typing the paths of the estimators:
    
	DistributedBoosting.boosting("path_to_boostscratch.h5","path_to_store_wantedlabels.h5",["paths_to_the_covariance_matrix.h5", "path_to_another_covariance_matrix.h5"])

Now the first boostingssteps are performed untill a new data call needs to be performed. Then a new set of wanted labels are saved and the next covariances should be provided using the provide function again. These steps are repeated untill all boostingsteps are performed. 
	