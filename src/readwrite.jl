""" 
Function to save the wantedlabels as a file in a certain directory 
Arguments:
myscratch::Boostscratch -> Container with the data to be written
filepath::ASCIIString -> Path where the data should be saved
"""
function write_wantedlabels(myscratch::Boostscratch, filepath::ASCIIString)
	h5open(filepath, "w") do file	
		write(file, "wantedlabels", myscratch.wantedlabels)
		if(!isempty(myscratch.pooledcovarmat.labels))
			write(file, "usedlabels", myscratch.pooledcovarmat.labels)
		else
			write(file, "usedlabels", "")
		end
	end
end
"""
Function to read the values of the covarmat 
Arguments:
filepath::ASCIIString -> Path where the data data is saved
"""
function read_covarmat(filepath::ASCIIString)
	covarmat = Covarmat(Array{Float64,2}(), Array{ASCIIString,1}())
	h5open(filepath, "r") do file
		covarmat.covarmat = read(file, "covarmat")
		covarmat.labels = read(file, "labels")
	end
	return covarmat
end
"""
Function to save all for the boostingprocess-relevant data and the results as a file in a certain directory
Arguments:
myscratch::Boostscratch -> Container with the data to be written
filepath::ASCIIString -> Path where the data should be saved 
"""
function write_boostscratch(myscratch::Boostscratch, filepath::ASCIIString)
	h5open(filepath, "w") do file
		write(file, "actualstepno", myscratch.actualstepno)
		write(file, "actualbeta", myscratch.actualbeta)
		write(file, "actualscore", myscratch.actualscore)
		write(file, "pooledunibeta", myscratch.pooledunibeta.unibeta)
		write(file, "pooledunibetalabels", myscratch.pooledunibeta.labels)
		write(file, "pooledunibetan", myscratch.pooledunibeta.n)
		write(file, "pooledcovarmat", myscratch.pooledcovarmat.covarmat)
		write(file, "pooledcovarmatlabels", myscratch.pooledcovarmat.labels)
		write(file, "actualupdates", myscratch.actualupdates)
		write(file, "selections", myscratch.selections)
		write(file, "wantedlabels", myscratch.wantedlabels)
		write(file, "nu", myscratch.nu)
		write(file, "stepno", myscratch.stepno)
		write(file, "actualsel", myscratch.actualsel)
		write(file, "actualnom", myscratch.actualnom)
		write(file, "a", myscratch.a)
		write(file, "x", myscratch.x)
	end
end
"""
Function to set the saved data to continue the boosting (since the process could be interrupted to perform a new data call)
Arguments:
myscratch::Boostscratch -> Container with the data which need to be set to perform the boostingsteps
filepath::ASCIIString -> Path where the data data is saved
"""
function set_boostscratch!(myscratch::Boostscratch, filepath::ASCIIString)
	h5open(filepath, "r") do file
		myscratch.actualstepno = read(file, "actualstepno")
		myscratch.actualbeta  = read(file, "actualbeta")
		myscratch.actualscore  = read(file, "actualscore")
		myscratch.pooledunibeta.unibeta  = read(file, "pooledunibeta")
		myscratch.pooledunibeta.labels  = read(file, "pooledunibetalabels")
		myscratch.pooledunibeta.n  = read(file, "pooledunibetan")
		myscratch.actualupdates  = read(file, "actualupdates")
		myscratch.selections  = read(file, "selections")
		myscratch.wantedlabels  = read(file, "wantedlabels")
		myscratch.nu  = read(file, "nu")
		myscratch.stepno  = read(file, "stepno")
		myscratch.actualsel  = read(file, "actualsel")
		myscratch.actualnom  = read(file, "actualnom")
		myscratch.a  = read(file, "a")
		myscratch.x  = read(file, "x")
		if(myscratch.actualsel != 1)
			myscratch.pooledcovarmat.covarmat  = read(file, "pooledcovarmat")
			myscratch.pooledcovarmat.labels  = read(file, "pooledcovarmatlabels")
		end
	end
end
"""
Function to read the univariate estimators from a certain directory
Arguments:
filepath::ASCIIString -> Path where the data data is saved
"""
function read_unibeta(filepath::ASCIIString)
	unibeta = Unibeta(Array{Float64,1}(), Array{Int,1}(), Array{ASCIIString, 1}())
	h5open(filepath, "r") do file
		unibeta.unibeta = read(file, "unibeta")
		unibeta.n = read(file, "n")
		unibeta.labels = read(file, "labels")
	end
	return unibeta
end
"""
Function to save the univarite estimators as a file in a certain directory
Arguments:
unibeta::Unibeta -> Container with the data to be written
filepath::ASCIIString -> Path where the data should be saved 
"""
function write_unibeta(unibeta::Unibeta, filepath::ASCIIString)
	h5open(filepath, "w") do file
		write(file, "unibeta", unibeta.unibeta)
		write(file, "n", unibeta.n)
		write(file, "labels", unibeta.labels)
	end
end
"""
Function to save the covariances matrices as a file in a certain directory
Arguments:
covarmat::Covarmat -> Container with the data to be written
filepath::ASCIIString -> Path where the data should be saved 
"""
function write_covarmat(covarmat::Covarmat, filepath::ASCIIString)
	h5open(filepath, "w") do file
		write(file, "covarmat", covarmat.covarmat)
		write(file, "labels", covarmat.labels)
	end
end
"""
Function to read the labels which were already used and the labels which are asked for in a new data call.
Arguments:
filepath::ASCIIString -> Path where the data data is saved
"""
function read_labels(filepath::ASCIIString)
	wantedlabels = Array{ASCIIString,1}()
	usedlabels = Array{ASCIIString, 1}()
	h5open(filepath,"r") do file 
		wantedlabels = read(file, "wantedlabels")
		usedlabels = read(file, "usedlabels")
	end
	return wantedlabels, usedlabels
end
"""
Function to read the individual data of a cohort from a certain directory
Arguments:
filepath::ASCIIString -> Path where the data data is saved
"""
function read_data(filepath::ASCIIString)
	mycohort = Discohort(Array{Float64,2}(), Array{Float64,1}(), Array{ASCIIString,1}())
	h5open(filepath, "r") do file
		mycohort.x = read(file, "x")
		mycohort.y = read(file, "y")
		mycohort.labels = read(file, "labels")
		#mycohort.id = read(file, "id")
	end
	return mycohort
end