""" 
Function which calculates the covariance matrix of a cohort with respect to the relevant labels (for the first matrix calculation)
Arguments:
mycohort::Discohort -> contains all information of one cohort 
wantedlabels::Array{ASCIIString,1} -> Array which contains the wantedlabels to give information about which covariances need to be calculated
"""
function calc_covarmat(mycohort::Discohort, wantedlabels::Array{ASCIIString,1})
	ncor = length(mycohort.y) - 1
	labelmap1 = labelmap(mycohort, wantedlabels)
	covmat = triu(ones(length(wantedlabels),length(wantedlabels)))
	@simd for i = 1 : length(labelmap1) - 1
		@simd for j = i + 1 : length(labelmap1)
			@inbounds covmat[i,j] = sum(mycohort.x[:, labelmap1[i]] .* mycohort.x[:, labelmap1[j]]) / ncor
		end
	end
	return Covarmat(covmat, wantedlabels)
end
"""
Function which calculates the expansions of the covariance matrix of a cohort with respect to the relevant labels
Arguments:
mycohort::Discohort -> contains all information of one cohort 
wantedlabels::Array{ASCIIString,1} -> Array which contains the wantedlabels to give information about which covariances need to be calculated
usedlabels::Array{ASCIIString,1} -> Array which contains the labels which were already used to give information about which covariances need to be calculated
"""	
function calc_covarmat(mycohort::Discohort, wantedlabels::Array{ASCIIString,1}, usedlabels::Array{ASCIIString,1})
	ncor = length(mycohort.y) - 1 
	labelmap1 = labelmap(mycohort, wantedlabels)
	covmat = triu(ones(length(wantedlabels), length(wantedlabels)))
	covmat2 = zeros(length(usedlabels), length(wantedlabels))
	labelmap2 = labelmap(mycohort, usedlabels)
	@simd for i = 1 : max(length(labelmap1), length(labelmap2))
		@simd for j = 1 : max(length(labelmap1), length(labelmap2))
			if(i <= length(usedlabels) && j <= length(wantedlabels))
				@inbounds covmat2[i,j] = sum(mycohort.x[:,labelmap1[j]] .* mycohort.x[:,labelmap2[i]]) / ncor
			end
			if(j >= i+1 && i <= length(wantedlabels) && j <= length(wantedlabels)) 
				@inbounds covmat[i,j]  = sum(mycohort.x[:,labelmap1[i]] .* mycohort.x[:,labelmap1[j]]) / ncor
			end
		end
	end
	return Covarmat(vcat(covmat2, covmat), vcat(usedlabels, wantedlabels))
end
"""
Function for the calculation of the univariate estimators
Arguments:
cohort::Discohort -> contains all information about one cohort 
"""
function calc_unibeta(cohort::Discohort)
	n = length(cohort.y)
	unibeta::Array{Float64} = zeros(size(cohort.x)[2])
	for i in 1:size(cohort.x)[2]
		@simd for j in 1:n
			@inbounds unibeta[i] += cohort.x[j,i]*cohort.y[j]
		end
		unibeta[i] /= n-1
	end
	return Unibeta(unibeta,ones(2500),cohort.labels)
end