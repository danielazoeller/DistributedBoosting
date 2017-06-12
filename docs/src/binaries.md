## Binaries

If you want to use the package without having julia installed you can easily build binaries of the package. Currently you can do it under windows using the BuildExecutable package. To install the package you need to type:

    Pkg.add("BuildExecutable")

The main() function for building the binary is provided separatly in the deps folder of the package. To build the binaries you need to call:

    using BuildExecutable
    build executable("binaryname", "path_to_pkg/deps/main.jl", "path_to_the_folder_with_binaries","native")

The folder where the binaryfiles should be saved has to be empty. If you want to use the binary now you just have to call the binary from the console with the arguments you already know from the "Usage"-section. The only difference is that you need a keyword now. If you want to initialze the containerfile, the keyword you need to use is "init". The method is analogue to the method in the Usage section. The first call from the console would look like this:

    binaryname.exe init 100 10 20 path_to_store_container"
	
For providing data the keyword is provide and to perform the boostingsteps and saving the wanted labels you need the keyword boost.
