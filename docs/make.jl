using Documenter, SpreadboostDummy

makedocs(
	format = :html,
	sitename = "Distributed Boosting",
	pages = ["index.md",
			 "installation.md",
			 "usage.md",
			 "binaries.md"]
	)
deploydocs(
	repo= "",
	target = "build",
	deps = nothing,
	make = nothing
	)