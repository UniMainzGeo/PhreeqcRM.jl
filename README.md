# PhreeqcRM.jl
Julia interface to [PhreeqcRM](https://github.com/usgs-coupled/phreeqcrm), which allows running `PhreeqcRM` directly from julia (without having to use textfiles)


A few examples are translated from the main code in the [examples](./examples) directory.

#### Installation
As the code is not yet registered, install it with
```julia
julia>]
pkg> add https://github.com/UniMainzGeo/PhreeqcRM.jl
``` 
and test with
```julia
pkg> test PhreeqcRM
```

#### Usage
We use a precompiled version of the library and autowrapped all functions of the C-library. The help comments are directly translated from C, so they do not directly translate to the julia version, but you'll get the idea.
As we follow the same nomenclature as C, you can mostly directly translate the C-functions to julia (which will usually be a bit smaller)

Start a code with:
```julia
import PhreeqcRM.LibPhreeqcRM as PC

nxyz = 20;
id = PC.RM_Create(nxyz, 1);
```

and finalize it with:
```julia
status = PC.RM_Destroy(id);
```
