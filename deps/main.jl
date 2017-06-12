import DistributedBoosting 

function main()
	if(ARGS[1] == "provide")
		if(length(ARGS) == 3)
			DistributedBoosting.provide(join(ARGS[2]),join(ARGS[3]))
		else
			DistributedBoosting.provide(join(ARGS[2]),join(ARGS[3]),join(ARGS[4]))
		end
	end
	if(ARGS[1] == "init")
		DistributedBoosting.boosting(parse(Int,ARGS[2]), parse(Int,ARGS[4]), parse(Int,ARGS[5]), join(ARGS[6]))
	end
	if(ARGS[1] == "boost")
		inputarray = Array{ASCIIString, 1}(length(ARGS)-3)
		for i = 1 : length(ARGS)-3
			inputarray[i] = join(ARGS[i+3])
		end
		DistributedBoosting.boosting(join(ARGS[2]), join(ARGS[3]), inputarray)
	end
end
