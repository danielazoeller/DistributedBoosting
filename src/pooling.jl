""" 
Function to pool the univariate estimators
Arguments:
unibetas::Array{Unibeta, 1} -> Array which contains the univariate estimators which have to be pooled
"""
function pool_unibetas(unibetas::Array{Unibeta, 1})
	pooledbetas = unibetas[1].n .* unibetas[1].unibeta
	sumN = unibetas[1].n
	@simd for i = 2 : length(unibetas)
		@inbounds pooledbetas = pooledbetas .+ unibetas[i].n .* unibetas[i].unibeta
		@inbounds sumN = sumN .+ unibetas[i].n
	end
	pooledbetas = pooledbetas ./ sumN
	return Unibeta(pooledbetas, sumN, unibetas[1].labels)
end
"""
Function to pool the covariance matrices
Arguments:
covarmat::Array{Covarmat, 1} -> Array which contains the covariances which have to be pooled
"""
function pool_covarmats(unibeta::Unibeta, covarmat::Array{Covarmat, 1})
	pooledcovarmat = zeros(size(covarmat[1].covarmat))
	sumN = unibeta.n[1:size(covarmat[1].covarmat)[1]]
	@simd for i = 1 : size(covarmat[1].covarmat)[2]
		@inbounds pooledcovarmat[:,i] = covarmat[1].covarmat[:,i] .* unibeta.n[1:size(covarmat[1].covarmat)[1]]
	end
	@simd for i = 2 : length(covarmat)
		@simd for j = 1 : size(covarmat[1].covarmat)[2]
			@inbounds pooledcovarmat[:,j] = pooledcovarmat[:,j] .+ covarmat[i].covarmat[:,j] .* unibeta.n[1:size(covarmat[1].covarmat)[1]]
		end
		@inbounds sumN = sumN .+ unibeta.n[1:size(covarmat[1].covarmat)[1]]
	end
	@simd for i = 1 : size(covarmat[1].covarmat)[2]
		@inbounds pooledcovarmat[:,i] = pooledcovarmat[:,i] ./ sumN
	end
	return pooledcovarmat	
end