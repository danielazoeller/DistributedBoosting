""" 
Function to fetch and pool the covariances matrices.
Calls the function read_covarmat to fetch and pool_covarmats to pool the matrices.
Arguments:
myscratch::Boostscratch -> Container with data which are relevant to perform the boostinsteps
paths_in_covarmat::Array{ASCIIString, 1} -> Array with the paths which lead to the provided covariance matrices
"""
function fetch_pool_covarmat!(myscratch::Boostscratch, paths_in_covarmat::Array{ASCIIString, 1})
	covarmats = Array{Covarmat, 1}(length(paths_in_covarmat))
	for i = 1 : length(paths_in_covarmat)
		covarmats[i] = read_covarmat(paths_in_covarmat[i])
	end
	if(isempty(myscratch.pooledcovarmat.covarmat))
		myscratch.pooledcovarmat.covarmat = pool_covarmats(myscratch.pooledunibeta, covarmats)
		myscratch.pooledcovarmat.labels = myscratch.wantedlabels
	else
		pooled = pool_covarmats(myscratch.pooledunibeta, covarmats)
		merge_covarmats!(myscratch, pooled)
	end
end
"""
Function to fetch and pool the univariate estimators.
Calls the function read_unibeta to fetch and pool_unibetas to pool the estimators.
Arguments:
myscratch::Boostscratch -> Container with data which are relevant to perform the boostinsteps
paths_in_unibeta::Array{ASCIIString, 1} -> Array with the paths which lead to the provided univariate estimators
"""
function fetch_pool_unibeta!(myscratch::Boostscratch, paths_in_unibeta::Array{ASCIIString,1})
	unibetas = Array{Unibeta, 1}(length(paths_in_unibeta))
	for i = 1 : length(paths_in_unibeta)
		unibetas[i] = read_unibeta(paths_in_unibeta[i])
	end
	myscratch.pooledunibeta = pool_unibetas(unibetas)
	myscratch.actualbeta = zeros(length(myscratch.pooledunibeta.unibeta))
	myscratch.actualnom = myscratch.pooledunibeta.unibeta
end