""" 
Function to perform a single boostingstep, which is called by the wrapper-function 'boosting'
Arguments:
myscratch::Boostscratch -> Container with data which are relevant to perform the boostinsteps
"""
function boost!(myscratch::Boostscratch)
	myscratch.actualscore = myscratch.actualnom.^2 # ./varx
	myscratch.actualsel = indmax(myscratch.actualscore)
	myscratch.selections[myscratch.actualstepno] = myscratch.pooledunibeta.labels[myscratch.actualsel]
	myscratch.actualupdates[myscratch.actualstepno] = myscratch.nu * myscratch.actualnom[myscratch.actualsel]
	myscratch.actualbeta[myscratch.actualsel] += myscratch.actualupdates[myscratch.actualstepno]
	covar = getcovarfromtriangular(myscratch.pooledcovarmat.covarmat, findfirst(myscratch.pooledcovarmat.labels, myscratch.pooledunibeta.labels[myscratch.actualsel]))
	@simd for i = 1 : length(covar)
		@inbounds myscratch.actualnom[findfirst(myscratch.pooledunibeta.labels, myscratch.pooledcovarmat.labels[i])] -= myscratch.actualupdates[myscratch.actualstepno] * covar[i]
	end
	newselval = myscratch.actualnom[myscratch.actualsel]^2
	return newselval
end
"""
Function to repeat the boostingsteps (which were already performed) with new data resulting from a new data call.  
Arguments:
myscratch::Boostscratch -> Container with data which are relevant to perform the boostinsteps
"""
function reboost!(myscratch::Boostscratch)
	for i = 1 : myscratch.actualstepno
		covar = getcovarfromtriangular(myscratch.pooledcovarmat.covarmat, findfirst(myscratch.pooledcovarmat.labels, myscratch.selections[i]))
		@simd for j = 1 : length(myscratch.wantedlabels)
			@inbounds myscratch.actualnom[findfirst(myscratch.pooledunibeta.labels, myscratch.wantedlabels[j])] -= myscratch.actualupdates[i] * covar[findfirst(myscratch.pooledcovarmat.labels, myscratch.wantedlabels[j])]
		end
	end
	myscratch.actualstepno += 1
end