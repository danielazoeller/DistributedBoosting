""" 
Function to initialize the container-type (Boostscratch) and to find the first labels to be called
Arguments:
stepno::Int -> Number of Boostingsteps which should be performed
a::Int -> Number of labels for the covariance matrix to start with
x::Int -> Number of labels which should be additionally called 
path_out_myscratch::ASCIIString -> Path where the container (Boostscratch) should be stored
path_out_wantedlabels::ASCIIString -> Path where the wanted labels should be stored
"""
function boosting(stepno::Int, a::Int, x::Int, path_out_myscratch::ASCIIString)
	myscratch = Boostscratch(1, Array{Float64,1}(), Array{Float64,1}(), Unibeta(Array{Float64,1}(),Array{Int,1}(),Array{ASCIIString,1}()), Covarmat(Array{Float64,2}(), Array{ASCIIString,1}()), Array{Float64,1}(stepno), Array{ASCIIString, 1}(stepno), Array{ASCIIString,1}(), 0.1, stepno, 1, Array{Float64,1}(), a, x)
	write_boostscratch(myscratch, path_out_myscratch)
end


"""
Function to perform the boosting algorithm
Arguments:
path_boostscratch::ASCIIString -> Path where the container (Boostscratch) is stored to set the parameters needed for running 
path_out_wantedlabels::ASCIIString -> Path where the wanted labels should be stored
paths_in_data::Array{ASCIIString, 1} -> Array with paths which lead to the provided covariance matrices or univariate estimators 
"""
function boosting(path_boostscratch::ASCIIString, path_out_wantedlabels::ASCIIString, paths_in_data::Array{ASCIIString, 1})
	exist = true
	myscratch = Boostscratch(0, Array{Float64,1}(), Array{Float64,1}(), Unibeta(Array{Float64,1}(),Array{Int,1}(),Array{ASCIIString,1}()), Covarmat(Array{Float64,2}(), Array{ASCIIString,1}()), Array{Float64,1}(), Array{ASCIIString, 1}(), Array{ASCIIString,1}(), 0, 0, 0, Array{Float64,1}(), 0, 0)
	set_boostscratch!(myscratch, path_boostscratch)
	if(length(myscratch.pooledunibeta.unibeta) == 0)
		fetch_pool_unibeta!(myscratch, paths_in_data)
		myscratch.wantedlabels = selectionofcovs(Unibeta(myscratch.actualnom, ones(1), myscratch.pooledunibeta.labels), myscratch.x)
	else
		fetch_pool_covarmat!(myscratch, paths_in_data)
		if(myscratch.actualstepno > 1)
			reboost!(myscratch)
		end
		while(myscratch.actualstepno <= myscratch.stepno && exist == true)
			newselval = boost!(myscratch)
			myscratch.wantedlabels = getselections(myscratch, newselval)
			if(length(myscratch.wantedlabels) > 0)
				exist = false
			end
			if(exist == true)
				myscratch.actualstepno += 1
			end
		end	
	end
	write_wantedlabels(myscratch, path_out_wantedlabels)
	write_boostscratch(myscratch, path_boostscratch)
	if(myscratch.actualstepno >= 2)
		println(myscratch.actualstepno," bsteps performed \n recent selected labels: ",myscratch.selections)
	end
end