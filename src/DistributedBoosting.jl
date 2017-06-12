module DistributedBoosting
using HDF5 

type Unibeta
	unibeta::Array{Float64,1}
	n::Array{Int,1}
	labels::Array{ASCIIString,1}
end

type Covarmat
	covarmat::Array{Float64,2}
	labels::Array{ASCIIString,1}
end

abstract Abstractdiscohort

type Discohort <: Abstractdiscohort
	x::Array{Float64,2}
	y::Array{Float64,1}
	labels::Array{ASCIIString,1}
end

type Remotecohort <: Abstractdiscohort #hier nochmal schauen
	filename::ASCIIString
	unibeta::Unibeta
	covarmat::Covarmat
end

type Boostscratch
	actualstepno::Int
	actualbeta::Array{Float64,1}
	actualscore::Array{Float64,1}
	pooledunibeta::Unibeta
	pooledcovarmat::Covarmat
	actualupdates::Array{Float64,1}
	selections::Array{ASCIIString,1}
	wantedlabels::Array{ASCIIString,1}
	nu::Float64
	stepno::Int
	actualsel::Int
	actualnom::Array{Float64,1}
	a::Int
	x::Int
end



include("boost.jl")
include("boosting.jl")
include("calc.jl")
include("fetch_pool.jl")
include("getselections.jl")
include("pooling.jl")
include("readwrite.jl")

end
