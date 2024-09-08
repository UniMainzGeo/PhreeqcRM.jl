module LibPhreeqcRM

using PhreeqcRM_jll
export PhreeqcRM_jll

using CEnum

#
# START OF PROLOGUE
#
using PhreeqcRM, PhreeqcRM_jll
const HASH_JEN = 0;


function __init__()
    global libPhreeqcRM = PhreeqcRM_jll.libPhreeqcRM
end

#
# END OF PROLOGUE
#

"""
    IRM_RESULT

Enumeration for PhreeqcRM function return codes.
"""
@cenum IRM_RESULT::Int32 begin
    IRM_OK = 0
    IRM_OUTOFMEMORY = -1
    IRM_BADVARTYPE = -2
    IRM_INVALIDARG = -3
    IRM_INVALIDROW = -4
    IRM_INVALIDCOL = -5
    IRM_BADINSTANCE = -6
    IRM_FAIL = -7
end

"""
    RM_BmiCreate(nxyz, nthreads)

[`RM_BmiCreate`](@ref) Creates a BMI reaction module, which allows use of all of the RM\\_Bmi methods.  If the code is compiled with the preprocessor directive USE\\_OPENMP, the reaction module is multithreaded. If the code is compiled with the preprocessor directive USE\\_MPI, the reaction module will use MPI and multiple processes. If neither preprocessor directive is used, the reaction module will be serial (unparallelized).

\\retvalId of the BMIPhreeqcRM instance, negative is failure.

\\par C example:

```c++
    <CODE>
    <PRE>
    nxyz = 40;
    nthreads = 3;
    id = RM_BmiCreate(nxyz, nthreads);
    </PRE>
    </CODE>
```

\\par MPI: Called by root and workers.

# Arguments
* `nxyz`: The number of grid cells in the user's model.
* `nthreads`: (or *comm*, MPI) When using OPENMP, the argument (*nthreads*) is the number of worker threads to be used. If *nthreads* <= 0, the number of threads is set equal to the number of processors of the computer. When using MPI, the argument (*comm*) is the MPI communicator to use within the reaction module.
# See also
RM_BmiFinalize.
"""
function RM_BmiCreate(nxyz, nthreads)
    ccall((:RM_BmiCreate, libPhreeqcRM), Cint, (Cint, Cint), nxyz, nthreads)
end

"""
    RM_BmiDestroy(id)

[`RM_BmiDestroy`](@ref) Destroys a BMI reaction module; same as RM_BmiFinalize.

\\retval0 is success, 0 is failure.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiDestroy(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root and workers.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiCreate.
"""
function RM_BmiDestroy(id)
    ccall((:RM_BmiDestroy, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_BmiAddOutputVars(id, option, def)

[`RM_BmiAddOutputVars`](@ref) allows selection of sets of variables that can be retieved by the *RM_BmiGetValue* methods. Sets of variables can be included or excluded with multiple calls to this method. All calls must precede the final call to the PhreeqcRM method FindComponents. FindComponents generates SELECTED\\_OUTPUT 333 and USER\\_PUNCH 333 data blocks that make the variables accessible. Variables will only be accessible if the system includes the given reactant; for example, no gas variables will be Created if there are no GAS\\_PHASEs in the model.

\\retval0 is success, 0 is failure. <p> Values for the the parameter *option*: </p> *AddOutputVars*: False excludes all variables; True causes the settings for each variable group to determine the variables that will be defined. Default True; *SolutionProperties*: False excludes all solution property variables; True includes variables pH, pe, alkalinity, ionic strength, water mass, charge balance, percent error, and specific conductance. Default True. *SolutionTotalMolalities*: False excludes all total element and element redox state variables; True includes all elements and element redox state variables for the system defined for the calculation; list restricts variables to the specified elements and redox states. Default True. *ExchangeMolalities*: False excludes all variables related to exchange; True includes all variables related to exchange; list includes variables for the specified exchange species. Default True. *SurfaceMolalities*: False excludes all variables related to surfaces; True includes all variables related to surfaces; list includes variables for the specified surface species. Default True. *EquilibriumPhases*: False excludes all variables related to equilibrium phases; True includes all variables related to equilibrium phases; list includes variables for the specified equilibiurm phases. Default True. *Gases*: False excludes all variables related to gases; True includes all variables related to gases; list includes variables for the specified gas components. Default True. *KineticReactants*: False excludes all variables related to kinetic reactants; True includes all variables related to kinetic reactants; list includes variables for the specified kinetic reactants. Default True. *SolidSolutions*: False excludes all variables related to solid solutions; True includes all variables related to solid solutions; list includes variables for the specified solid solutions components. Default True. *CalculateValues*: False excludes all calculate values; True includes all calculate values; list includes the specified calculate values. CALCLUATE\\_VALUES can be used to calculate geochemical quantities not available in the other sets of variables. Default True. *SolutionActivities*: False excludes all aqueous species; True includes all aqueous species; list includes only the specified aqueous species. Default False. *SolutionMolalities*: False excludes all aqueous species; True includes all aqueous species; list includes only the specified aqueous species. Default False. *SaturationIndices*: False excludes all saturation indices; True includes all saturation indices; list includes only the specified saturation indices. Default False.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiAddOutputVars(id, "SolutionMolalities", "True");
    status = RM_BmiAddOutputVars(id, "SaturationIndices", "Calcite Dolomite");
    </PRE>
    </CODE>
```

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `option`: A string value, among those listed below, that includes or excludes variables from RM_BmiGetOutputVarName, *RM_BmiGetValue* methods, and other BMI methods.
* `def`: A string value that can be "false", "true", or a list of items to be included as accessible variables. A value of "false", excludes all variables of the given type; a value of "true" includes all variables of the given type for the current system; a list specifies a subset of items of the given type.
"""
function RM_BmiAddOutputVars(id, option, def)
    ccall((:RM_BmiAddOutputVars, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}), id, option, def)
end

"""
    RM_BmiFinalize(id)

[`RM_BmiFinalize`](@ref) Destroys a reaction module.

\\retval0 is success, 0 is failure.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiFinalize(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root and workers.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiCreate.
"""
function RM_BmiFinalize(id)
    ccall((:RM_BmiFinalize, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_BmiGetComponentName(id, component_name, l)

[`RM_BmiGetComponentName`](@ref) returns the component name--"BMIPhreeqcRM".

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiGetComponentName(id, component_name);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `component_name`: Returns "BMIPhreeqcRM", the name of the component.
* `l`: Length of string buffer *component_name*.
"""
function RM_BmiGetComponentName(id, component_name, l)
    ccall((:RM_BmiGetComponentName, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, component_name, l)
end

"""
    RM_BmiGetCurrentTime(id)

[`RM_BmiGetCurrentTime`](@ref) returns the current simulation time, in seconds.

\\retvalThe current simulation time, in seconds.

\\par C example:

```c++
    <CODE>
    <PRE>
    now = RM_BmiGetCurrentTime(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetEndTime, RM_BmiGetTimeStep, RM_BmiGetTime.
"""
function RM_BmiGetCurrentTime(id)
    ccall((:RM_BmiGetCurrentTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_BmiGetEndTime(id)

[`RM_BmiGetEndTime`](@ref) returns RM_BmiGetCurrentTime plus RM_BmiGetTimeStep, in seconds.

\\retvalThe end of the time step, in seconds.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiGetEndTime(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetCurrentTime, RM_BmiGetTimeStep.
"""
function RM_BmiGetEndTime(id)
    ccall((:RM_BmiGetEndTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_BmiGetGridRank(id, grid)

[`RM_BmiGetGridRank`](@ref) returns a rank of 1 for grid 0. BMIPhreeqcRM has a 1D series of cells; any grid or spatial information must be found in the user's model.

\\retvalRank of 1 is returned for grid 0; 0 for all other values of *grid*.

\\par C example:

```c++
    <CODE>
    <PRE>
    rank = RM_BmiGetGridRank(id, grid)
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `grid`: Grid number, only grid 0 is considered.
"""
function RM_BmiGetGridRank(id, grid)
    ccall((:RM_BmiGetGridRank, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

"""
    RM_BmiGetGridSize(id, grid)

RM_BmiGetGridSize returns the number of cells specified at creation of the BMIPhreeqcRM instance.

\\retvalNumber of cells. Same value as RM_BmiGetValueInt(id, "GridCellCount") is returned for grid 0; 0 for all other values of *grid*.

\\par C example:

```c++
    <CODE>
    <PRE>
    nxyz = RM_BmiGetGridSize(id, grid);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `grid`: Grid number, only grid 0 is considered.
"""
function RM_BmiGetGridSize(id, grid)
    ccall((:RM_BmiGetGridSize, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

"""
    RM_BmiGetGridType(id, grid, str, l)

[`RM_BmiGetGridType`](@ref) defines the grid to be points. No grid information is available in BMIPhreeqcRM; all grid information must be found in the user's model.

\\retval0 is success, 1 is failure, negative indicates the buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiGetGridType(id, grid, str, l)
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `grid`: Grid number, only grid 0 is considered.
* `str`: "Points" is returned for grid 0; "Undefined grid identifier" is returned for all other values of *grid*.
* `l`: Length of string buffer *str*.
"""
function RM_BmiGetGridType(id, grid, str, l)
    ccall((:RM_BmiGetGridType, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, grid, str, l)
end

"""
    RM_BmiGetInputItemCount(id)

[`RM_BmiGetInputItemCount`](@ref) returns count of variables that can be set with *RM_BmiSetValue* methods.

\\retvalNumber of input variables that can be set with *RM_BmiSetValue* methods.

\\par C example:

```c++
    <CODE>
    <PRE>
    count = RM_BmiGetInputItemCount(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetInputVarName, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetInputItemCount(id)
    ccall((:RM_BmiGetInputItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_BmiGetInputVarName(id, i, name, l)

[`RM_BmiGetInputVarName`](@ref) returns the ith variable name that can be set with *RM_BmiSetValue* methods.

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char name[256];
    status = RM_BmiGetInputVarName(id, 0, name, 256);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `i`: 0-based index of variable name to retrieve.
* `name`: Retrieved variable name.
* `l`: Length of buffer for *name*.
# See also
RM_BmiGetInputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetInputVarName(id, i, name, l)
    ccall((:RM_BmiGetInputVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

"""
    RM_BmiGetOutputItemCount(id)

[`RM_BmiGetOutputItemCount`](@ref) returns count of output variables that can be retrieved with *RM_BmiGetValue* methods.

\\retvalNumber of output variables that can be retrieved with *RM_BmiGetValue* methods.

\\par C example:

```c++
    <CODE>
    <PRE>
    count = RM_BmiGetOutputItemCount(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetOutputVarName, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetOutputItemCount(id)
    ccall((:RM_BmiGetOutputItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_BmiGetOutputVarName(id, i, name, l)

[`RM_BmiGetOutputVarName`](@ref) returns ith variable name for which a pointer can be retrieved with *RM_BmiGetValue* methods.

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char name[256]
    status = RM_BmiGetOutputVarName(id, 0, name, 256);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `i`: 0-based index of variable name to retrieve.
* `name`: Retrieved variable name.
* `l`: Length of buffer for *name*.
# See also
RM_BmiGetOutputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetOutputVarName(id, i, name, l)
    ccall((:RM_BmiGetOutputVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

"""
    RM_BmiGetPointableItemCount(id)

[`RM_BmiGetPointableItemCount`](@ref) returns count of pointable variables that can be retrieved with RM_BmiGetValuePtr.

\\retvalNumber of output variables that can be retrieved with RM_BmiGetValuePtr.

\\par C example:

```c++
    <CODE>
    <PRE>
    count = RM_BmiGetPointableItemCount(id);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetPointableVarName, RM_BmiGetValuePtr, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetPointableItemCount(id)
    ccall((:RM_BmiGetPointableItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_BmiGetPointableVarName(id, i, name, l)

[`RM_BmiGetPointableVarName`](@ref) returns ith variable name for which a pointer can be retrieved with RM_BmiGetValuePtr.

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char name[256];
    status = RM_BmiGetPointableVarName(id, 0, name, 256);
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `i`: 0-based index of variable name to retrieve.
* `name`: Retrieved variable name.
* `l`: Length of buffer for *name*.
# See also
RM_BmiGetPointableItemCount, RM_BmiGetValuePtr, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetPointableVarName(id, i, name, l)
    ccall((:RM_BmiGetPointableVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

"""
    RM_BmiGetStartTime(id)

[`RM_BmiGetStartTime`](@ref) returns the current simulation time, in seconds. (Same as RM_BmiGetCurrentTime.)

\\retvalThe current simulation time, in seconds.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
"""
function RM_BmiGetStartTime(id)
    ccall((:RM_BmiGetStartTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_BmiGetTime(id)

[`RM_BmiGetTime`](@ref) returns the current simulation time, in seconds. (Same as RM_BmiGetCurrentTime.)

\\retvalThe current simulation time, in seconds.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
"""
function RM_BmiGetTime(id)
    ccall((:RM_BmiGetTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_BmiGetTimeStep(id)

[`RM_BmiGetTimeStep`](@ref) returns the current simulation time step, in seconds.

\\retvalThe current simulation time step, in seconds.

\\par C example:

```c++
    <CODE>
    <PRE>
    time_step = RM_BmiGetTimeStep(id)
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
# See also
RM_BmiGetCurrentTime, RM_BmiGetEndTime.
"""
function RM_BmiGetTimeStep(id)
    ccall((:RM_BmiGetTimeStep, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_BmiGetTimeUnits(id, units, l)

[`RM_BmiGetTimeUnits`](@ref) returns the time units of PhreeqcRM. All time units are seconds for PhreeqcRM.

\\retval0 is success, 1 failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char time_units[256]
    status = RM_BmiGetTimeUnits(id, time_units, 256)
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `units`: Returns the string "seconds".
* `l`: Length of the string buffer *units*.
# See also
RM_BmiGetCurrentTime, RM_BmiGetEndTime, RM_BmiGetTimeStep.
"""
function RM_BmiGetTimeUnits(id, units, l)
    ccall((:RM_BmiGetTimeUnits, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, units, l)
end

"""
    RM_BmiGetValueInt(id, var, dest)

[`RM_BmiGetValueInt`](@ref) retrieves int model variables. Only variables in the list provided by RM_BmiGetOutputVarName can be retrieved.

\\retval0 is success, 1 is failure. <p> Variable names for the second argument (*var*). </p>  "ComponentCount"  "CurrentSelectedOutputUserNumber"  "GridCellCount"  "SelectedOutputColumnCount"  "SelectedOutputCount"  "SelectedOutputOn"  "SelectedOutputRowCount".

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiGetValueInt(id, "ComponentCount", &count);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `var`: Name of the variable to retrieve.
* `dest`: Variable in which to place results.
# See also
RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetValueInt(id, var, dest)
    ccall((:RM_BmiGetValueInt, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cint}), id, var, dest)
end

"""
    RM_BmiGetValueDouble(id, var, dest)

[`RM_BmiGetValueDouble`](@ref) retrieves model variables. Only variables in the list provided by RM_BmiGetOutputVarName can be retrieved.

\\retval0 is success, 1 is failure. <p> Variables in addition to the ones listed below may be retrieved by this method, depending on variables selected by RM_BmiAddOutputVars. All variables added by RM_BmiAddOutputVars will be double arrays of size equal to the number of model cells [RM_BmiGetValueInt(id, "GridCellCount")]. </p> <p> Variable names for the second argument (*var*). </p>  "Concentrations"  "DensityCalculated"  "Gfw"  "Porosity"  "Pressure"  "SaturationCalculated"  "SelectedOutput"  "SolutionVolume"  "Temperature"  "Time"  "TimeStep"  "Viscosity".

\\par C example:

```c++
    <CODE>
    <PRE>
    density = (double *)malloc(nxyz*sizeof(double));
    status = RM_BmiGetValueDouble(id, "DensityCalculated", density);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `var`: Name of the variable to retrieve.
* `dest`: Variable in which to place results.
# See also
RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetValueDouble(id, var, dest)
    ccall((:RM_BmiGetValueDouble, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cdouble}), id, var, dest)
end

"""
    RM_BmiGetValueChar(id, var, dest, l)

[`RM_BmiGetValueChar`](@ref) retrieves char model variables. Only variables in the list provided by RM_BmiGetOutputVarName can be retrieved.

\\retval0 is success, 1 is failure; negative indicates buffer is too small. <p> The buffer length must be at least one character greater than the value returned by RM_BmiGetVarNbytes to allow for null termination. "ErrorString" and "FilePrefix" return single strings. "Components" and "SelectedOutputHeadings" retrieve a string that is a concatenated list of components or selected-output headings. The length of each item in a list is given by RM_BmiGetVarItemsize. The concatenated list must be processed to extract each component or heading and a null termination must be appended. Alternatively, the components can be retrieved one at a time with [`RM_GetComponent`](@ref) or [`RM_GetSelectedOutputHeading`](@ref). </p> <p> Variable names for the second argument (*var*). </p>  "Components"  "ErrorString"  "FilePrefix"  "SelectedOutputHeadings".

\\par C example:

```c++
    <CODE>
    <PRE>
    char string[256];
    status = RM_BmiGetValueChar(id, "FilePrefix", string);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `var`: Name of the variable to retrieve.
* `dest`: Variable in which to place results.
* `l`: Length of the string buffer *dest*.
# See also
RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetValueChar(id, var, dest, l)
    ccall((:RM_BmiGetValueChar, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, var, dest, l)
end

"""
    RM_BmiGetValuePtr(id, var)

[`RM_BmiGetValuePtr`](@ref) retrieves pointers to model variables. Only variables in the list provided by RM_BmiGetPointableVarName can be pointed to.

\\retvalPointer to an up-to-date copy of the variable's data. <p> The following list gives the name in the second argument (*var*) and the data type the pointer: </p>  "ComponentCount"  "Concentrations"  "DensityCalculated"  "Gfw"  "GridCellCount"  "Porosity"  "Pressure"  "SaturationCalculated"  "SelectedOutputOn"  "SolutionVolume"  "Temperature"  "Time"  "TimeStep"  "Viscosity"

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `var`: Name of the variable to retrieve.
"""
function RM_BmiGetValuePtr(id, var)
    ccall((:RM_BmiGetValuePtr, libPhreeqcRM), Ptr{Cvoid}, (Cint, Ptr{Cchar}), id, var)
end

"""
    RM_BmiGetVarGrid(id, var)

[`RM_BmiGetVarGrid`](@ref) returns a value of 1, indicating points. BMIPhreeqcRM does not have a grid of its own. The cells of BMIPhreeqcRM are associated with the user's model grid, and all spatial characterists are assigned by the user's model.

\\retval1 (points). BMIPhreeqcRM cells derive meaning from the user's model.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `var`: Varaiable name. (Return value is the same regardless of value of @ var.)
"""
function RM_BmiGetVarGrid(id, var)
    ccall((:RM_BmiGetVarGrid, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, var)
end

"""
    RM_BmiGetVarItemsize(id, name)

[`RM_BmiGetVarItemsize`](@ref) retrieves the size, in bytes, of a variable that can be set with *RM_BmiSetValue* methods, retrieved with *RM_BmiGetValue* methods, or pointed to with RM_BmiGetValuePtr. Sizes may be the size of an integer, double, or a character length for string variables.

\\retvalSize, in bytes, of one element of the variable.

\\par C example:

```c++
    <CODE>
    <PRE>
    for(i = 0; i < GetInputVarCount(id); i++)
    {
        itemsize = GetVarItemsize(id, name);
    }
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of the variable to retrieve the item size.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetPointableVarName, RM_BmiGetPointableItemCount, RM_BmiGetValuePtr, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetVarItemsize(id, name)
    ccall((:RM_BmiGetVarItemsize, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, name)
end

"""
    RM_BmiGetVarNbytes(id, name)

[`RM_BmiGetVarNbytes`](@ref) retrieves the total number of bytes needed for a variable that can be set with *RM_BmiSetValue* methods, retrieved with *RM_BmiGetValue* methods, or pointed to with RM_BmiGetValuePtr.

\\retvalTotal number of bytes needed for the variable.

\\par C example:

```c++
    <CODE>
    <PRE>
    for(i = 0; i < GetInputVarCount(id); i++)
    {
        nbytes = GetVarNbytes(id, name);
    }
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of the variable to retrieve the number of bytes needed to retrieve or store the variable.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetPointableVarName, RM_BmiGetPointableItemCount, RM_BmiGetValuePtr, RM_BmiGetVarItemsize, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiGetVarNbytes(id, name)
    ccall((:RM_BmiGetVarNbytes, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, name)
end

"""
    RM_BmiGetVarType(id, name, vtype, l)

[`RM_BmiGetVarType`](@ref) retrieves the type of a variable that can be set with *RM_BmiSetValue* methods, retrieved with *RM_BmiGetValue* methods, or pointed to with RM_BmiGetValuePtr. Types are "char", "double", or "int", or an array of these types.

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char string[256];
    for(i = 0; i < GetInputVarCount(id); i++)
    {
        status = GetVarType(id, i, string, 256);
    }
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of the variable to retrieve the type.
* `vtype`: Type of the variable.
* `l`: Length of string buffer *vtype*.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetPointableVarName, RM_BmiGetPointableItemCount, RM_BmiGetValuePtr, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarUnits.
"""
function RM_BmiGetVarType(id, name, vtype, l)
    ccall((:RM_BmiGetVarType, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, name, vtype, l)
end

"""
    RM_BmiGetVarUnits(id, name, units, l)

[`RM_BmiGetVarType`](@ref) retrieves the units of a variable that can be set with *RM_BmiSetValue* methods, retrieved with *RM_BmiGetValue* methods, or pointed to with RM_BmiGetValuePtr.

\\retval0 is success, 1 is failure; negative indicates buffer is too small.

\\par C example:

```c++
    <CODE>
    <PRE>
    char string[256];
    for(i = 0; i < GetInputVarCount(id); i++)
    {
        status = GetVarUnits(id, i, string, 256);
    }
    </PRE>
    </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of the variable to retrieve the type.
* `units`: Units of the variable.
* `l`: Length of string buffer *units*.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetOutputVarName, RM_BmiGetOutputItemCount, RM_BmiGetPointableVarName, RM_BmiGetPointableItemCount, RM_BmiGetValuePtr, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType.
"""
function RM_BmiGetVarUnits(id, name, units, l)
    ccall((:RM_BmiGetVarUnits, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, name, units, l)
end

"""
    RM_BmiInitialize(id, config_file)

[`RM_BmiInitialize`](@ref) uses a YAML file to initialize an instance of BMIPhreeqcRM.

\\retval0 is success, 1 is failure. <p> The file contains a YAML map of PhreeqcRM methods and the arguments corresponding to the methods. For example, </p>

```c++
    <CODE>
    <PRE>
    - key: LoadDatabase
      database: phreeqc.dat
    - key: RunFile
      workers: true
      initial_phreeqc: true
      utility: true
      chemistry_name: advect.pqi
    </PRE>
    </CODE>
```

<p> [`RM_BmiInitialize`](@ref) will read the YAML file and execute the specified methods with the specified arguments. Using YAML terminology, the argument(s) for a method may be a scalar, a sequence, or a map, depending if the argument is a single item, a single vector, or there are multiple arguments. In the case of a map, the name associated with each argument (for example "chemistry\\_name" above) is arbitrary. The names of the map keys for map arguments are not used in parsing the YAML file; only the order of the arguments is important. </p> <p> The following list gives the PhreeqcRM methods that can be specified in a YAML file and the arguments that are required. The arguments are described with C++ formats, which are sufficient to identify which arguments are YAML scalars (single bool/logical, int, double, string/character argument), sequences (single vector argument), or maps (multiple arguments). </p>

```c++
    <CODE>
    <PRE>
    CloseFiles();
    CreateMapping(std::vector< int >& grid2chem);
    DumpModule();
    FindComponents();
    InitialEquilibriumPhases2Module(std::vector< int > equilibrium_phases);
    InitialExchanges2Module(std::vector< int > exchanges);
    InitialGasPhases2Module(std::vector< int > gas_phases);
    InitialKineticss2Module(std::vector< int > kinetics);
    InitialSolidSolutions2Module(std::vector< int > solid_solutions);
    InitialSolutions2Module(std::vector< int > solutions);
    InitialSurfaces2Module(std::vector< int > surfaces);
    InitialPhreeqc2Module(std::vector< int > initial_conditions1);
    InitialPhreeqc2Module(std::vector< int > initial_conditions1,
    std::vector< int > initial_conditions2, std::vector< double > fraction1);
    InitialPhreeqcCell2Module(int n, std::vector< int > cell_numbers);
    LoadDatabase(std::string database);
    OpenFiles();
    OutputMessage(std::string str);
    RunCells();
    RunFile(bool workers, bool initial_phreeqc, bool utility, std::string chemistry_name);
    RunString(bool workers, bool initial_phreeqc, bool utility, std::string input_string);
    ScreenMessage(std::string str);
    SetComponentH2O(bool tf);
    SetConcentrations(std::vector< double > c);
    SetCurrentSelectedOutputUserNumber(int n_user);
    SetDensityUser(std::vector< double > density);
    SetDumpFileName(std::string dump_name);
    SetErrorHandlerMode(int mode);
    SetErrorOn(bool tf);
    SetFilePrefix(std::string prefix);
    SetGasCompMoles(std::vector< double > gas_moles);
    SetGasPhaseVolume(std::vector< double > gas_volume);
    SetPartitionUZSolids(bool tf);
    SetPorosity(std::vector< double > por);
    SetPressure(std::vector< double > p);
    SetPrintChemistryMask(std::vector< int > cell_mask);
    SetPrintChemistryOn(bool workers, bool initial_phreeqc, bool utility);
    SetRebalanceByCell(bool tf);
    SetRebalanceFraction(double f);
    SetRepresentativeVolume(std::vector< double > rv);
    SetSaturationUser(std::vector< double > sat);
    SetScreenOn(bool tf);
    SetSelectedOutputOn(bool tf);
    SetSpeciesSaveOn(bool save_on);
    SetTemperature(std::vector< double > t);
    SetTime(double time);
    SetTimeConversion(double conv_factor);
    SetTimeStep(double time_step);
    SetUnitsExchange(int option);
    SetUnitsGasPhase(int option);
    SetUnitsKinetics(int option);
    SetUnitsPPassemblage(int option);
    SetUnitsSolution(int option);
    SetUnitsSSassemblage(int option);
    SetUnitsSurface(int option);
    SpeciesConcentrations2Module(std::vector< double > species_conc);
    StateSave(int istate);
    StateApply(int istate);
    StateDelete(int istate);
    UseSolutionDensityVolume(bool tf);
    WarningMessage(std::string warnstr);
    </PRE>
    </CODE>
```

\\par C example:

```c++
    <CODE>
    <PRE>
    id = RM_BmiCreate(nxyz, nthreads);
    status = RM_BmiInitializeYAML(id, "myfile.yaml");
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `config_file`: String containing the YAML file name.
"""
function RM_BmiInitialize(id, config_file)
    ccall((:RM_BmiInitialize, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, config_file)
end

"""
    RM_BmiSetValueChar(id, name, src)

[`RM_BmiSetValueChar`](@ref) sets model character variables. Only variables in the list provided by RM_BmiGetInputVarName can be set.

\\retval0 is success, 1 is failure. <p> Variable names for the second argument (*var*): </p>  "FilePrefix"

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiSetValueChar(id, "FilePrefix", "my_prefix");
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of variable to set.
* `src`: Data to use to set the variable.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiSetValueChar(id, name, src)
    ccall((:RM_BmiSetValueChar, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}), id, name, src)
end

"""
    RM_BmiSetValueDouble(id, name, src)

[`RM_BmiSetValueDouble`](@ref) sets model double variables. Only variables in the list provided by RM_BmiGetInputVarName can be set.

\\retval0 is success, 1 is failure. <p> Variable names for the second argument (*var*): </p>  "Time"  "TimeStep".

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiSetValueDouble(id, "TimeStep", 86400.0);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of variable to set.
* `src`: Data to use to set the variable.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiSetValueDouble(id, name, src)
    ccall((:RM_BmiSetValueDouble, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cdouble), id, name, src)
end

"""
    RM_BmiSetValueDoubleArray(id, name, src)

[`RM_BmiSetValueDoubleArray`](@ref) sets model double array variables. Only variables in the list provided by RM_BmiGetInputVarName can be set.

\\retval0 is success, 1 is failure. <p> Variable names for the second argument (*var*): </p>  "Concentrations"  "DensityUser"  "Porosity"  "Pressure"  "SaturationUser"  "Temperature".

\\par C example:

```c++
    <CODE>
    <PRE>
    tc = (double *)malloc(nxyz*sizeof(double));
    for(i=0; i < nxyz; i++) tc[i] = 28.0e0;
    status = RM_BmiSetValueDoubleArray(id, "Temperature", tc);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of variable to set.
* `src`: Data to use to set the variable.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiSetValueDoubleArray(id, name, src)
    ccall((:RM_BmiSetValueDoubleArray, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cdouble}), id, name, src)
end

"""
    RM_BmiSetValueInt(id, name, src)

[`RM_BmiSetValueInt`](@ref) sets model int variables. Only variables in the list provided by RM_BmiGetInputVarName can be set.

\\retval0 is success, 1 is failure. <p> Variable names for the second argument (*var*): </p>  "NthSelectedOutput"  "SelectedOutputOn".

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiSetValueInt(id, "SelectedOutputOn", 1);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
* `name`: Name of variable to set.
* `src`: Data to use to set the variable.
# See also
RM_BmiGetInputVarName, RM_BmiGetInputItemCount, RM_BmiGetVarItemsize, RM_BmiGetVarNbytes, RM_BmiGetVarType, RM_BmiGetVarUnits.
"""
function RM_BmiSetValueInt(id, name, src)
    ccall((:RM_BmiSetValueInt, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, name, src)
end

"""
    RM_BmiUpdate(id)

[`RM_BmiUpdate`](@ref) runs a reaction step for all of the cells in the reaction module.

\\retval0 is success, 1 is failure. <p> Tranported concentrations are transferred to the reaction cells (RM_BmiSetValueDoubleArray "Concentrations") before reaction calculations are run. The length of time over which kinetic reactions are integrated is set by RM_BmiSetValueDouble "TimeStep". Other properties that may need to be updated as a result of the transport calculations include porosity, pressure, saturation, temperature. </p>

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiSetValue(id, "Porosity", por);                ! If pore volume changes
    status = RM_BmiSetValue(id, "SaturationUser", sat);          ! If saturation changes
    status = RM_BmiSetValue(id, "Temperature", temperature);     ! If temperature changes
    status = RM_BmiSetValue(id, "Pressure", pressure);           ! If pressure changes
    status = RM_BmiSetValue(id, "Concentrations", c);            ! Transported concentrations
    status = RM_BmiSetValue(id, "TimeStep", time_step);          ! Time step for kinetic reactions
    status = RM_BmiUpdate(id);
    status = RM_BmiGetValue(id, "Concentrations", c);            ! Concentrations after reaction
    status = RM_BmiGetValue(id, "DensityCalculated", density);   ! Density after reaction
    status = RM_BmiGetValue(id, "SolutionVolume", volume);       ! Solution volume after reaction
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate.
"""
function RM_BmiUpdate(id)
    ccall((:RM_BmiUpdate, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_BmiUpdateUntil(id, end_time)

[`RM_BmiUpdateUntil`](@ref) is the same as RM_BmiUpdate, except the time step is calculated from the argument *end_time*. The time step is calculated to be *end_time* minus the current time (RM_BmiGetCurrentTime).

\\par C example:

```c++
    <CODE>
    <PRE>
    status = RM_BmiSetValue(id, "Time", time);
    status = RM_BmiSetValue(id, "Concentrations", c);
    status = RM_BmiUpdateUntil(id, time + 86400.0);
    status = RM_BmiGetValue(id, "Concentrations", c);
    </PRE>
    </CODE>
```

\\par MPI: Called by root, workers must be in the loop of [`RM_MpiWorker`](@ref).

# Arguments
* `id`: Id number returned by RM_BmiCreate..
* `end_time`: Time at the end of the time step.
# See also
RM_BmiInitialize, RM_BmiUpdate.
"""
function RM_BmiUpdateUntil(id, end_time)
    ccall((:RM_BmiUpdateUntil, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, end_time)
end

"""
    RM_BmiGetValueAtIndices(id, name, dest, inds, count)

[`RM_BmiGetValueAtIndices`](@ref) is not implemented
"""
function RM_BmiGetValueAtIndices(id, name, dest, inds, count)
    ccall((:RM_BmiGetValueAtIndices, libPhreeqcRM), Cvoid, (Cint, Ptr{Cchar}, Ptr{Cvoid}, Ptr{Cint}, Cint), id, name, dest, inds, count)
end

"""
    RM_BmiSetValueAtIndices(id, name, inds, count, src)

[`RM_BmiSetValueAtIndices`](@ref) is not implemented.
"""
function RM_BmiSetValueAtIndices(id, name, inds, count, src)
    ccall((:RM_BmiSetValueAtIndices, libPhreeqcRM), Cvoid, (Cint, Ptr{Cchar}, Ptr{Cint}, Cint, Ptr{Cvoid}), id, name, inds, count, src)
end

"""
    RM_BmiGetGridShape(id, grid, shape)

[`RM_BmiGetGridShape`](@ref) is not implemented.
"""
function RM_BmiGetGridShape(id, grid, shape)
    ccall((:RM_BmiGetGridShape, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, shape)
end

"""
    RM_BmiGetGridSpacing(id, grid, spacing)

[`RM_BmiGetGridSpacing`](@ref) is not implemented.
"""
function RM_BmiGetGridSpacing(id, grid, spacing)
    ccall((:RM_BmiGetGridSpacing, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, spacing)
end

"""
    RM_BmiGetGridOrigin(id, grid, origin)

[`RM_BmiGetGridOrigin`](@ref) is not implemented.
"""
function RM_BmiGetGridOrigin(id, grid, origin)
    ccall((:RM_BmiGetGridOrigin, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, origin)
end

"""
    RM_BmiGetGridX(id, grid, x)

[`RM_BmiGetGridX`](@ref) is not implemented.
"""
function RM_BmiGetGridX(id, grid, x)
    ccall((:RM_BmiGetGridX, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, x)
end

"""
    RM_BmiGetGridY(id, grid, y)

[`RM_BmiGetGridY`](@ref) is not implemented.
"""
function RM_BmiGetGridY(id, grid, y)
    ccall((:RM_BmiGetGridY, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, y)
end

"""
    RM_BmiGetGridZ(id, grid, z)

[`RM_BmiGetGridZ`](@ref) is not implemented.
"""
function RM_BmiGetGridZ(id, grid, z)
    ccall((:RM_BmiGetGridZ, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, z)
end

"""
    RM_BmiGetGridNodeCount(id, grid)

[`RM_BmiGetGridNodeCount`](@ref) is not implemented.
"""
function RM_BmiGetGridNodeCount(id, grid)
    ccall((:RM_BmiGetGridNodeCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

"""
    RM_BmiGetGridEdgeCount(id, grid)

[`RM_BmiGetGridEdgeCount`](@ref) is not implemented.
"""
function RM_BmiGetGridEdgeCount(id, grid)
    ccall((:RM_BmiGetGridEdgeCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

"""
    RM_BmiGetGridFaceCount(id, grid)

[`RM_BmiGetGridFaceCount`](@ref) is not implemented.
"""
function RM_BmiGetGridFaceCount(id, grid)
    ccall((:RM_BmiGetGridFaceCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

"""
    RM_BmiGetGridEdgeNodes(id, grid, edge_nodes)

[`RM_BmiGetGridEdgeNodes`](@ref) is not implemented.
"""
function RM_BmiGetGridEdgeNodes(id, grid, edge_nodes)
    ccall((:RM_BmiGetGridEdgeNodes, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, edge_nodes)
end

"""
    RM_BmiGetGridFaceEdges(id, grid, face_edges)

[`RM_BmiGetGridFaceEdges`](@ref) is not implemented.
"""
function RM_BmiGetGridFaceEdges(id, grid, face_edges)
    ccall((:RM_BmiGetGridFaceEdges, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, face_edges)
end

"""
    RM_BmiGetGridFaceNodes(id, grid, face_nodes)

[`RM_BmiGetGridFaceNodes`](@ref) is not implemented.
"""
function RM_BmiGetGridFaceNodes(id, grid, face_nodes)
    ccall((:RM_BmiGetGridFaceNodes, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, face_nodes)
end

"""
    RM_BmiGetGridNodesPerFace(id, grid, nodes_per_face)

[`RM_BmiGetGridNodesPerFace`](@ref) is not implemented.
"""
function RM_BmiGetGridNodesPerFace(id, grid, nodes_per_face)
    ccall((:RM_BmiGetGridNodesPerFace, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, nodes_per_face)
end

"""
    RM_Abort(id, result, err_str)

Abort the program. *Result* will be interpreted asan [`IRM_RESULT`](@ref) value and decoded; *err_str* will be printed; and the reaction modulewill be destroyed. If using MPI, an MPI\\_Abort message will be sent before the reactionmodule is destroyed. If the *id* is an invalid instance, [`RM_Abort`](@ref) will return a value ofIRM\\_BADINSTANCE, otherwise the program will exit with a return code of 4.

\\retvalIRM_RESULT Program will exit before returning unless *id* is an invalid reaction module id.

\\par C Example:

```c++
<CODE>
<PRE>
iphreeqc_id = RM_Concentrations2Utility(id, c_well, 1, tc, p_atm);
Utilities::strcpy_safe(str, MAX_LENGTH, "SELECTED_OUTPUT 5; -pH; RUN_CELLS; -cells 1");
status = RunString(iphreeqc_id, str);
if (status != 0) status = RM_Abort(id, status, "IPhreeqc RunString failed");
</PRE>
</CODE>
```

\\par MPI:Called by root or workers.

# Arguments
* `id`: The instance id returned from RM_Create.
* `result`: Integer treated as an [`IRM_RESULT`](@ref) return code.
* `err_str`: String to be printed as an error message.
# See also
RM_Destroy, RM_ErrorMessage.
"""
function RM_Abort(id, result, err_str)
    ccall((:RM_Abort, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}), id, result, err_str)
end

"""
    RM_CloseFiles(id)

Close the output and log files.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_CloseFiles(id);
</PRE>
</CODE>
```

\\par MPI:Called only by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_OpenFiles, RM_SetFilePrefix.
"""
function RM_CloseFiles(id)
    ccall((:RM_CloseFiles, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_Concentrations2Utility(id, c, n, tc, p_atm)

*N* sets of component concentrations are converted to SOLUTIONs numbered 1-*n* in the Utility IPhreeqc.The solutions can be reacted and manipulated with the methods of IPhreeqc. If solution concentration units(RM_SetUnitsSolution) are per liter, one liter of solution is created in the Utility instance; if solutionconcentration units are mass fraction, one kilogram of solution is created in the Utility instance.The motivation for thismethod is the mixing of solutions in wells, where it may be necessary to calculate solution properties(pH for example) or react the mixture to form scale minerals. The code fragments below make a mixture ofconcentrations and then calculate the pH of the mixture.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
c_well = (double *) malloc((size_t) ((size_t) (1 * ncomps * sizeof(double))));
for (i = 0; i < ncomps; i++)
{
  c_well[i] = 0.5 * c[0 + nxyz*i] + 0.5 * c[9 + nxyz*i];
}
tc = (double *) malloc((size_t) (1 * sizeof(double)));
p_atm = (double *) malloc((size_t) (1 * sizeof(double)));
tc[0] = 15.0;
p_atm[0] = 3.0;
iphreeqc_id = RM_Concentrations2Utility(id, c_well, 1, tc, p_atm);
Utilities::strcpy_safe(str, MAX_LENGTH, "SELECTED_OUTPUT 5; -pH; RUN_CELLS; -cells 1");
status = RunString(iphreeqc_id, str);
status = SetCurrentSelectedOutputUserNumber(iphreeqc_id, 5);
status = GetSelectedOutputValue2(iphreeqc_id, 1, 0, &vtype, &pH, svalue, 100);
</PRE>
</CODE>
```

\\par MPI:Called only by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `c`: Array of concentrations to be made SOLUTIONs in Utility IPhreeqc. Array storage is n * ncomps.
* `n`: The number of sets of concentrations.
* `tc`: Array of temperatures to apply to the SOLUTIONs, in degree C. Array of size *n*.
* `p_atm`: Array of pressures to apply to the SOLUTIONs, in atm. Array of size n.
"""
function RM_Concentrations2Utility(id, c, n, tc, p_atm)
    ccall((:RM_Concentrations2Utility, libPhreeqcRM), Cint, (Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cdouble}), id, c, n, tc, p_atm)
end

function RM_Create(nxyz, nthreads)
    ccall((:RM_Create, libPhreeqcRM), Cint, (Cint, Cint), nxyz, nthreads)
end

"""
    RM_CreateMapping(id, grid2chem)

Provides a mapping from grid cells in the user's model to reaction cells in PhreeqcRM.The mapping is used to eliminate inactive cells and to use symmetry to decrease the number of cells for which chemistry must be run.The array *grid2chem* of size *nxyz* (the number of grid cells, RM_GetGridCellCount) must contain the set of all integers 0 <= *i* < *count_chemistry*, where *count_chemistry* is a number less than or equal to *nxyz*.Inactive cells are assigned a negative integer. The mapping may be many-to-one to account for symmetry.Default is a one-to-one mapping--all user grid cells are reaction cells (equivalent to *grid2chem* values of 0,1,2,3,...,*nxyz*-1).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
// For demonstation, two equivalent rows by symmetry
grid2chem = (int *) malloc((size_t) (nxyz * sizeof(int)));
for (i = 0; i < nxyz/2; i++)
{
  grid2chem[i] = i;
  grid2chem[i+nxyz/2] = i;
}
status = RM_CreateMapping(id, grid2chem);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `grid2chem`: An array of integers: Nonnegative is a reaction cell number (0 based), negative is an inactive cell. Array of size *nxyz* (number of grid cells).
"""
function RM_CreateMapping(id, grid2chem)
    ccall((:RM_CreateMapping, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, grid2chem)
end

"""
    RM_DecodeError(id, e)

If *e* is negative, this method prints an error message corresponding to [`IRM_RESULT`](@ref) *e*. If *e* is non-negative, no action is taken.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par [`IRM_RESULT`](@ref) definition:

```c++
<CODE>
<PRE>
typedef enum {
  IRM_OK            =  0,  //Success
  IRM_OUTOFMEMORY   = -1,  //Failure, Out of memory
  IRM_BADVARTYPE    = -2,  //Failure, Invalid VAR type
  IRM_INVALIDARG    = -3,  //Failure, Invalid argument
  IRM_INVALIDROW    = -4,  //Failure, Invalid row
  IRM_INVALIDCOL    = -5,  //Failure, Invalid column
  IRM_BADINSTANCE   = -6,  //Failure, Invalid rm instance id
  IRM_FAIL          = -7,  //Failure, Unspecified
} IRM_RESULT;
</PRE>
</CODE>
```

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_CreateMapping(id, grid2chem);
if (status < 0) status = RM_DecodeError(id, status);
</PRE>
</CODE>
```

\\par MPI:Can be called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `e`: An [`IRM_RESULT`](@ref) value returned by one of the reaction-module methods.
"""
function RM_DecodeError(id, e)
    ccall((:RM_DecodeError, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, e)
end

"""
    RM_Destroy(id)

Destroys a reaction module.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_Destroy(id);
</PRE>
</CODE>
```

\\par MPI:Called by root and workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_Create.
"""
function RM_Destroy(id)
    ccall((:RM_Destroy, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_DumpModule(id, dump_on, append)

Writes the contents of all workers to file in \\_RAW formats, including SOLUTIONs and all reactants.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
dump_on = 1;
append = 0;
status = RM_SetDumpFileName(id, "advection_c.dmp");
status = RM_DumpModule(id, dump_on, append);
</PRE>
</CODE>
```

\\par MPI:Called by root; workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `dump_on`: Signal for writing the dump file: 1 true, 0 false.
* `append`: Signal to append to the contents of the dump file: 1 true, 0 false.
# See also
RM_SetDumpFileName.
"""
function RM_DumpModule(id, dump_on, append)
    ccall((:RM_DumpModule, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint), id, dump_on, append)
end

"""
    RM_ErrorMessage(id, errstr)

Send an error message to the screen, the output file, and the log file.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_ErrorMessage(id, "Goodbye world");
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers; root writes to output and log files.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `errstr`: String to be printed.
# See also
RM_LogMessage, RM_OpenFiles, RM_OutputMessage, RM_ScreenMessage, RM_WarningMessage.
"""
function RM_ErrorMessage(id, errstr)
    ccall((:RM_ErrorMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, errstr)
end

"""
    RM_FindComponents(id)

Returns the number of items in the list of all elements in the InitialPhreeqc instance.Elements are those that have been defined in a solution or any other reactant (EQUILIBRIUM\\_PHASE, KINETICS, and others).The method can be called multiple times and the list that is created is cummulative.The list is the set of components that needs to be transported.By default the listincludes water, excess H and excess O (the H and O not contained in water);alternatively, the list may be set to contain total H and total O (RM_SetComponentH2O),which requires transport results to be accurate to eight or nine significant digits.If multicomponent diffusion (MCD) is to be modeled, there is a capability to retrieve aqueous species concentrations(RM_GetSpeciesConcentrations) and to set new solution concentrations after MCD by using individual species concentrations(RM_SpeciesConcentrations2Module). To use these methods the save-species property needs to be turned on (RM_SetSpeciesSaveOn).If the save-species property is on, [`RM_FindComponents`](@ref) will generatea list of aqueous species (RM_GetSpeciesCount, RM_GetSpeciesName), their diffusion coefficients at 25 C (RM_GetSpeciesD25),their charge (RM_GetSpeciesZ).

\\retvalNumber of components currently in the list, or [`IRM_RESULT`](@ref) error code (see RM_DecodeError).

\\par The [`RM_FindComponents`](@ref) method also generates lists of reactants--equilibrium phases,exchangers, gas components, kinetic reactants, solid solution components, and surfaces.The lists are cumulative, including all reactants that weredefined in the initial phreeqc instance at any time FindComponents was called.In addition, a list of phases is generated for which saturation indices may be calculated from thecumulative list of components.

\\par C Example:

```c++
<CODE>
<PRE>
// Get list of components
ncomps = RM_FindComponents(id);
components = (char **) malloc((size_t) (ncomps * sizeof(char *)));
for (i = 0; i < ncomps; i++)
{
  components[i] = (char *) malloc((size_t) (100 * sizeof(char *)));
  status = RM_GetComponent(id, i, components[i], 100);
}
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetComponent, RM_GetSpeciesConcentrations,RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas, RM_GetSpeciesLog10Molalities,RM_GetSpeciesName,RM_GetSpeciesZ, RM_SetComponentH2O,RM_SetSpeciesSaveOn, RM_SpeciesConcentrations2Module., RM_GetEquilibriumPhasesName,RM_GetEquilibriumPhasesCount,RM_GetExchangeName,RM_GetExchangeSpeciesName,RM_GetExchangeSpeciesCount,RM_GetGasComponentsName,RM_GetGasComponentsCount,RM_GetKineticReactionsName,RM_GetKineticReactionsCount,RM_GetSICount,RM_GetSIName,RM_GetSolidSolutionComponentsName,RM_GetSolidSolutionComponentsCount,RM_GetSolidSolutionName,RM_GetSurfaceName,RM_GetSurfaceSpeciesName,RM_GetSurfaceSpeciesCount,RM_GetSurfaceType.
"""
function RM_FindComponents(id)
    ccall((:RM_FindComponents, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetBackwardMapping(id, n, list, size)

Fills an array with the cell numbers in the user's numbering sytstem that map to a cell in thePhreeqcRM numbering system. The mapping is defined by RM_CreateMapping.

\\retvalIRM_RESULT error code (see RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
if (RM_GetBackwardMapping(rm_id, rm_cell_number, list, &size) == 0)
{
  if (strcmp(str, "HYDRAULIC_K") == 0)
  {
    return data->K_ptr[list[0]];
  }
}
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `n`: A cell number in the PhreeqcRM numbering system (0 <= n < RM_GetChemistryCellCount).
* `list`: Array to store the user cell numbers mapped to PhreeqcRM cell *n*.
* `size`: Input, the allocated size of *list*; it is an error if the array is too small.  Output, the number of cells mapped to cell *n*.
# See also
RM_CreateMapping, RM_GetChemistryCellCount, RM_GetGridCellCount.
"""
function RM_GetBackwardMapping(id, n, list, size)
    ccall((:RM_GetBackwardMapping, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cint}, Ptr{Cint}), id, n, list, size)
end

"""
    RM_GetChemistryCellCount(id)

Returns the number of chemistry cells in the reaction module. The number of chemistry cells is defined bythe set of non-negative integers in the mapping from user grid cells (RM_CreateMapping).The number of chemistry cells is less than or equal to the number of cells in the user's model.

\\retvalNumber of chemistry cells, or [`IRM_RESULT`](@ref) error code (see RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_CreateMapping(id, grid2chem);
nchem = RM_GetChemistryCellCount(id);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_CreateMapping, RM_GetGridCellCount.
"""
function RM_GetChemistryCellCount(id)
    ccall((:RM_GetChemistryCellCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetComponent(id, num, chem_name, l)

Retrieves an item from the reaction-module component list that was generated by calls to RM_FindComponents.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
// Get list of components
ncomps = RM_FindComponents(id);
components = (char **) malloc((size_t) (ncomps * sizeof(char *)));
for (i = 0; i < ncomps; i++)
{
  components[i] = (char *) malloc((size_t) (100 * sizeof(char *)));
  status = RM_GetComponent(id, i, components[i], 100);
}
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the component to be retrieved. C, 0 based.
* `chem_name`: The string value associated with component *num*.
* `l`: The length of the maximum number of characters for *chem_name*.
# See also
RM_FindComponents, RM_GetComponentCount
"""
function RM_GetComponent(id, num, chem_name, l)
    ccall((:RM_GetComponent, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, chem_name, l)
end

"""
    RM_GetComponentCount(id)

Returns the number of components in the reaction-module component list.The component list is generated by calls to RM_FindComponents.The return value from the last call to RM_FindComponents is equal to the return value from [`RM_GetComponentCount`](@ref).

\\retvalThe number of components in the reaction-module component list, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ncomps1 = RM_GetComponentCount(id);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents, RM_GetComponent.
"""
function RM_GetComponentCount(id)
    ccall((:RM_GetComponentCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetConcentrations(id, c)

Transfer solution concentrations from each reaction cellto the concentration array given in the argument list (*c*).Units of concentration for *c* are defined by RM_SetUnitsSolution.For concentration units of per liter,the solution volume is used to calculate the concentrations for *c*.For mass fraction concentration units,the solution mass is used to calculate concentrations for *c*.Two options are available for the volume and mass of solutionthat are used in converting to transport concentrations: (1) the volume and mass of solution arecalculated by PHREEQC, or(2) the volume of solution is the product of saturation (RM_SetSaturationUser),porosity (RM_SetPorosity), and representative volume (RM_SetRepresentativeVolume),and the mass of solution is volume times density as defined by RM_SetDensityUser.RM_UseSolutionDensityVolume determines which option is used.For option 1, the databases that have partial molar volume definitions neededto accurately calculate solution volume arephreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
c = (double *) malloc((size_t) (ncomps * nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetConcentrations(id, c);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `c`: Array to receive the concentrations. Dimension of the array is *nxyz* * *ncomps*,where *nxyz* is the number of user grid cells and *ncomps* is the result of RM_FindComponents or RM_GetComponentCount.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents, RM_GetComponentCount, RM_GetSaturationCalculated,RM_SetConcentrations, RM_SetDensityUser, RM_SetRepresentativeVolume, RM_SetSaturationUser,RM_SetUnitsSolution, RM_UseSolutionDensityVolume.
"""
function RM_GetConcentrations(id, c)
    ccall((:RM_GetConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, c)
end

"""
    RM_GetIthConcentration(id, i, c)

Transfer the concentration from each cell for one component to the array given in theargument list (*c*). The concentrations are those resulting from the last callto RM_RunCells. Units of concentration for *c* are defined by RM_SetUnitsSolution.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
c = (double*)malloc(nxyz * sizeof(double));
status = RM_RunCells(id);
status = RM_GetIthConcentration(id, 0, c)
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: Zero-based index for the component to retrieve. Indices referto the order produced by RM_GetComponent. The total number of components is given byRM_GetComponentCount.
* `c`: Allocated array to receive the component concentrations.Dimension of the array must be at least *nxyz*, where *nxyz* is the number ofuser grid cells (RM_GetGridCellCount). Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetComponent,RM_GetComponentCount,RM_GetConcentrations.
"""
function RM_GetIthConcentration(id, i, c)
    ccall((:RM_GetIthConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

"""
    RM_GetIthSpeciesConcentration(id, i, c)

Transfer the concentrations for one species from each cell to the array given in theargument list (*c*). The concentrations are those resulting from the last callto RM_RunCells. Units of concentration for *c* are mol/L.To retrieve species concentrations, RM_SetSpeciesSaveOn must be set to 1.This method is for use with multicomponent diffusion calculations.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
c = (double*)malloc(nxyz*sizeof(double));
status = RM_RunCells(id);
status = RM_GetIthSpeciesConcentration(id, 0, c);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: Zero-based index for the species to retrieve. Indices referto the order given by RM_GetSpeciesName. The total number of species is givenby RM_GetSpeciesCount.
* `c`: Allocated array to receive the species concentrations.Dimension of the array must be at least *nxyz*, where *nxyz* is the number ofuser grid cells (RM_GetGridCellCount). Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetSpeciesCount,RM_GetSpeciesName,RM_GetSpeciesConcentrations,RM_SetSpeciesSaveOn.
"""
function RM_GetIthSpeciesConcentration(id, i, c)
    ccall((:RM_GetIthSpeciesConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

"""
    RM_SetIthConcentration(id, i, c)

Transfer the concentrations for one component given by the vector *cto* each reaction cell.Units of concentration for *c* are defined by RM_SetUnitsSolution.It is required that [`RM_SetIthConcentration`](@ref) be called for each componentin the system before RM_RunCells is called.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetIthConcentration(id, i, c); ! repeat for all components
...
status = phreeqc_rm.RunCells(id);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: Zero-based index for the component to transfer.Indices refer to the order produced by RM_GetComponent. The total numberof components is given by RM_GetComponentCount.
* `c`: Array of concentrations to transfer to the reaction cells.Dimension of the vector is *nxyz*, where *nxyz* is the number ofuser grid cells (RM_GetGridCellCount). Values for inactive cells are ignored.
# See also
RM_FindComponents,RM_GetComponentCount,RM_GetComponent,RM_SetConcentrations.
"""
function RM_SetIthConcentration(id, i, c)
    ccall((:RM_SetIthConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

"""
    RM_SetIthSpeciesConcentration(id, i, c)

Transfer the concentrations for one aqueous species given by the vector*c* to each reaction cell.Units of concentration for *c* are mol/L. To set species concentrations,RM_SetSpeciesSaveOn must be set to *true*. It is required that[`RM_SetIthSpeciesConcentration`](@ref) be called for each aqueous species in thesystem before RM_RunCells is called. This method is for use withmulticomponent diffusion calculations.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetIthSpeciesConcentration(id, i, c); ! repeat for all species
...
status = RM_RunCells(id);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: Zero-based index for the species to transfer. Indicesrefer to the order produced by RM_GetSpeciesName. The total number ofspecies is given by RM_GetSpeciesCount.
* `c`: Array of concentrations to transfer to the reaction cells.Dimension of the array is *nxyz*, where *nxyz* is the number of user gridcells (RM_GetGridCellCount). Values for inactive cells are ignored.
# See also
RM_FindComponents,RM_GetSpeciesCount,RM_GetSpeciesName,RM_SpeciesConcentrations2Module,RM_SetSpeciesSaveOn.
"""
function RM_SetIthSpeciesConcentration(id, i, c)
    ccall((:RM_SetIthSpeciesConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

"""
    RM_GetCurrentSelectedOutputUserNumber(id)

Returns the user number of the current selected-output definition.RM_SetCurrentSelectedOutputUserNumber or RM_SetNthSelectedOutput specifies which of theselected-output definitions is used.

\\retvalUser number of the the current selected-output definition,negative is failure (See RM_DecodeError).

\\par C Example:

```c++
	<CODE>
	<PRE>
	for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
	{
	  status = RM_SetNthSelectedOutputUser(id, isel);
	  n_user = RM_GetCurrentSelectedOutputUserNumber(id);
	  col = RM_GetSelectedOutputColumnCount(id);
	  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
	  status = RM_GetSelectedOutput(id, selected_out);
	  // Process results here
	  free(selected_out);
	}
	</PRE>
	</CODE>
```

\\par MPI:	Called by root.

# See also
RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetCurrentSelectedOutputUserNumber(id)
    ccall((:RM_GetCurrentSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetDensityCalculated(id, density)

Transfer solution densities from the reaction cells to the array given in the argument list (*density*).Densities are those calculated by the reaction module. This method always returns the calculated densities; RM_SetDensityUser does not affect the result.Only the following databases distributed with PhreeqcRM have molar volume information needed to accurately calculate density:phreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
density = (double *) malloc((size_t) (nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetDensityCalculated(id, density);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `density`: Array to receive the densities. Dimension of the array is *nxyz*,where *nxyz* is the number of user grid cells (RM_GetGridCellCount). Values for inactive cells are set to 1e30.
"""
function RM_GetDensityCalculated(id, density)
    ccall((:RM_GetDensityCalculated, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

"""
    RM_GetDensity(id, density)

Deprecated equivalent of [`RM_GetDensityCalculated`](@ref).
"""
function RM_GetDensity(id, density)
    ccall((:RM_GetDensity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

"""
    RM_GetEndCell(id, ec)

Returns an array with the ending cell numbers from the range of cell numbers assigned to each worker.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
n = RM_GetThreadCount(id) * RM_GetMpiTasks(id);
ec = (int *) malloc((size_t) (n * sizeof(int)));
status = RM_GetEndCell(id, ec);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `ec`: Array to receive the ending cell numbers. Dimension of the array is  the number of threads (OpenMP) or the number of processes (MPI).
# See also
RM_Create, RM_GetMpiTasks, RM_GetStartCell, RM_GetThreadCount.
"""
function RM_GetEndCell(id, ec)
    ccall((:RM_GetEndCell, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, ec)
end

"""
    RM_GetEquilibriumPhasesCount(id)

Returns the number of equilibrium phases in the initial-phreeqc module.RM_FindComponents must be called before RM_GetEquilibriumPhasesCount.This method may be useful when generating selected output definitions related toequilibrium phases.

\\retvalThe number of equilibrium phases in the initial-phreeqc module.

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -equilibrium_phases\\n");
for (i = 0; i < RM_GetEquilibriumPhasesCount(id); i++)
{
status = RM_GetEquilibriumPhasesName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetEquilibriumPhasesName.
"""
function RM_GetEquilibriumPhasesCount(id)
    ccall((:RM_GetEquilibriumPhasesCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetEquilibriumPhasesName(id, num, name, l1)

Retrieves an item from the equilibrium phase list.The list includes all phases included in any EQUILIBRIUM\\_PHASES definitions inthe initial-phreeqc module.RM_FindComponents must be called before RM_GetEquilibriumPhasesName.This method may be useful when generating selected output definitions related to equilibrium phases.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -equilibrium_phases\\n");
for (i = 0; i < RM_GetEquilibriumPhasesCount(id); i++)
{
status = RM_GetEquilibriumPhasesName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the equilibrium phase name to be retrieved. (0 basedindex.)
* `name`: The equilibrium phase name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetEquilibriumPhasesCount.
"""
function RM_GetEquilibriumPhasesName(id, num, name, l1)
    ccall((:RM_GetEquilibriumPhasesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetErrorString(id, errstr, l)

Returns a string containing error messages related to the last call to a PhreeqcRM method tothe character argument (*errstr*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
if (status != IRM_OK)
{
  l = RM_GetErrorStringLength(id);
  errstr = (char *) malloc((size_t) (l * sizeof(char) + 1));
  RM_GetErrorString(id, errstr, l+1);
  fprintf(stderr,"%s", errstr);
  free(errstr);
  RM_Destroy(id);
  exit(1);
}
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `errstr`: The error string related to the last call to a PhreeqcRM method.
* `l`: Maximum number of characters that can be written to the argument (*errstr*).
"""
function RM_GetErrorString(id, errstr, l)
    ccall((:RM_GetErrorString, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, errstr, l)
end

"""
    RM_GetErrorStringLength(id)

Returns the length of the string that contains error messages related to the last call to a PhreeqcRM method.

\\retvalint Length of the error message string (for C, equivalent to strlen, does not include terminating \\0).

\\par C Example:

```c++
<CODE>
<PRE>
if (status != IRM_OK)
{
  l = RM_GetErrorStringLength(id);
  errstr = (char *) malloc((size_t) (l * sizeof(char) + 1));
  RM_GetErrorString(id, errstr, l+1);
  fprintf(stderr,"%s", errstr);
  free(errstr);
  RM_Destroy(id);
  exit(1);
}
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker..

# Arguments
* `id`: The instance *id* returned from RM_Create.
"""
function RM_GetErrorStringLength(id)
    ccall((:RM_GetErrorStringLength, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetExchangeName(id, num, name, l1)

Retrieves an item from the exchange name list.RM_FindComponents must be called before RM_GetExchangeName.The exchange names vector is the same length as the exchange species names vectorand provides the corresponding exchange site (for example, X corresponing to NaX).This method may be useful when generating selected output definitions related to exchangers.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetExchangeSpeciesCount(id); i++)
{
Utilities::strcpy_safe(line, MAX_LENGTH, "");
status = RM_GetExchangeSpeciesName(id, i, line1, 100);
status = RM_GetExchangeName(id, i, line2, 100);
sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the exchange name to be retrieved. (0 based index.)
* `name`: The exchange name associated with exchange species *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetExchangeSpeciesCount, RM_GetExchangeSpeciesName.
"""
function RM_GetExchangeName(id, num, name, l1)
    ccall((:RM_GetExchangeName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetExchangeSpeciesCount(id)

Returns the number of exchange species in the initial-phreeqc module.RM_FindComponents must be called before RM_GetExchangeSpeciesCount.This method may be useful when generating selected output definitions related to exchangers.

\\retvalThe number of exchange species in the initial-phreeqc module.

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetExchangeSpeciesCount(id); i++)
{
Utilities::strcpy_safe(line, MAX_LENGTH), "");
status = RM_GetExchangeSpeciesName(id, i, line1, 100);
status = RM_GetExchangeName(id, i, line2, 100);
sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetExchangeSpeciesName, RM_GetExchangeName.
"""
function RM_GetExchangeSpeciesCount(id)
    ccall((:RM_GetExchangeSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetExchangeSpeciesName(id, num, name, l1)

Retrieves an item from the exchange species list.The list of exchange species (such as "NaX") is derived from the list of components(RM_FindComponents) and the list of all exchange names (such as "X")that are included in EXCHANGE definitions in the initial-phreeqc module.RM_FindComponents must be called before RM_GetExchangeSpeciesName.This method may be useful when generating selected output definitions related to exchangers.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetExchangeSpeciesCount(id); i++)
{
Utilities::strcpy_safe(line, MAX_LENGTH, "");
status = RM_GetExchangeSpeciesName(id, i, line1, 100);
status = RM_GetExchangeName(id, i, line2, 100);
sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the exchange species to be retrieved. (0 based index.)
* `name`: The exchange species name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetExchangeSpeciesCount, RM_GetExchangeName.
"""
function RM_GetExchangeSpeciesName(id, num, name, l1)
    ccall((:RM_GetExchangeSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetFilePrefix(id, prefix, l)

Returns the reaction-module file prefix to the character argument (*prefix*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
char str[100], str1[200];
status = RM_GetFilePrefix(id, str, 100);
Utilities::strcpy_safe(str1, MAX_LENGTH, "File prefix: ");
Utilities::strcat_safe(str1, MAX_LENGTH, str);
Utilities::strcat_safe(str1, MAX_LENGTH, "\\n");
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `prefix`: Character string where the prefix is written.
* `l`: Maximum number of characters that can be written to the argument (*prefix*).
# See also
RM_SetFilePrefix.
"""
function RM_GetFilePrefix(id, prefix, l)
    ccall((:RM_GetFilePrefix, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, prefix, l)
end

"""
    RM_GetGasComponentsCount(id)

Returns the number of gas phase components in the initial-phreeqc module.RM_FindComponents must be called before RM_GetGasComponentsCount.This method may be useful when generating selected output definitions related togas phases.

\\retvalThe number of gas phase components in the initial-phreeqc module.

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -gases\\n");
for (i = 0; i < RM_GetGasComponentsCount(id); i++)
{
status = RM_GetGasComponentsName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetGasComponentsName.
"""
function RM_GetGasComponentsCount(id)
    ccall((:RM_GetGasComponentsCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetGasComponentsName(id, num, name, l1)

Retrieves an item from the gas components list.The list includes all gas components included in any GAS\\_PHASE definitions inthe initial-phreeqc module.RM_FindComponents must be called before RM_GetGasComponentsName.This method may be useful when generating selected output definitions related to gas phases.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -gases\\n");
for (i = 0; i < RM_GetGasComponentsCount(id); i++)
{
status = RM_GetGasComponentsName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the gas component name to be retrieved. (0 based index.)
* `name`: The gas component name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetGasComponentsCount.
"""
function RM_GetGasComponentsName(id, num, name, l1)
    ccall((:RM_GetGasComponentsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetGasCompMoles(id, gas_moles)

Transfer moles of gas components from each reaction cellto the vector given in the argument list (*gas_moles*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ngas_comps = RM_GetGasComponentsCount();
gas_moles = (double *) malloc((size_t) (ngas_comps * nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetGasCompMoles(id, gas_moles);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_moles`: Vector to receive the moles of gas components.Dimension of the vector must be *ngas_comps* times *nxyz*,where, *ngas_comps* is the result of RM_GetGasComponentsCount,and *nxyz* is the number of user grid cells (RM_GetGridCellCount).If a gas component is not defined for a cell, the number of moles is set to -1.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents, RM_GetGasComponentsCount, RM_GetGasCompPressures,RM_GetGasCompPhi,RM_GetGasPhaseVolume,RM_SetGasCompMoles,RM_SetGasPhaseVolume.
"""
function RM_GetGasCompMoles(id, gas_moles)
    ccall((:RM_GetGasCompMoles, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_moles)
end

"""
    RM_GetGasCompPressures(id, gas_pressure)

Transfer pressures of gas components from each reaction cellto the vector given in the argument list (*gas_pressure*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ngas_comps = RM_GetGasComponentsCount();
gas_pressure = (double *) malloc((size_t) (ngas_comps * nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetGasCompPressures(id, gas_pressure);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_pressure`: Vector to receive the pressures of gas components.Dimension of the vector must be *ngas_comps* times *nxyz*,where, *ngas_comps* is the result of RM_GetGasComponentsCount,and *nxyz* is the number of user grid cells (RM_GetGridCellCount).If a gas component is not defined for a cell, the pressure is set to -1.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetGasComponentsCount,RM_GetGasCompMoles,RM_GetGasCompPhi,RM_GetGasPhaseVolume,RM_SetGasCompMoles,RM_SetGasPhaseVolume.
"""
function RM_GetGasCompPressures(id, gas_pressure)
    ccall((:RM_GetGasCompPressures, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_pressure)
end

"""
    RM_GetGasCompPhi(id, gas_phi)

Transfer fugacity coefficients (phi) of gas components from each reaction cellto the vector given in the argument list (*gas_phi*). Fugacity of a gascomponent is equal to its pressure times the fugacity coefficient.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ngas_comps = RM_GetGasComponentsCount();
gas_phi = (double *) malloc((size_t) (ngas_comps * nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetGasCompPhi(id, gas_phi);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_phi`: Vector to receive the fugacity coefficients of gas components.Dimension of the vector must be *ngas_comps* times *nxyz*,where, *ngas_comps* is the result of RM_GetGasComponentsCount,and *nxyz* is the number of user grid cells (RM_GetGridCellCount).If a gas component is not defined for a cell, the fugacity coefficient is set to -1.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetGasComponentsCount,RM_GetGasCompMoles,RM_GetGasCompPressures,RM_GetGasPhaseVolume,RM_SetGasCompMoles,RM_SetGasPhaseVolume.
"""
function RM_GetGasCompPhi(id, gas_phi)
    ccall((:RM_GetGasCompPhi, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_phi)
end

"""
    RM_GetGasPhaseVolume(id, gas_volume)

Transfer volume of gas from each reaction cellto the vector given in the argument list (*gas_volume*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
gas_volume = (double *) malloc((size_t) (nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetGasPhaseVolume(id, gas_volume);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_volume`: Array to receive the gas phase volumes.Dimension of the vector must be *nxyz*,where, *nxyz* is the number of user grid cells (RM_GetGridCellCount).If a gas phase is not defined for a cell, the volume is set to -1.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetGasComponentsCount,RM_GetGasCompMoles,RM_GetGasCompPressures,RM_GetGasCompPhi,RM_SetGasCompMoles,RM_SetGasPhaseVolume.
"""
function RM_GetGasPhaseVolume(id, gas_volume)
    ccall((:RM_GetGasPhaseVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_volume)
end

"""
    RM_GetGfw(id, gfw)

Returns the gram formula weights (g/mol) for the components in the reaction-module component list.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ncomps = RM_FindComponents(id);
components = (char **) malloc((size_t) (ncomps * sizeof(char *)));
gfw = (double *) malloc((size_t) (ncomps * sizeof(double)));
status = RM_GetGfw(id, gfw);
for (i = 0; i < ncomps; i++)
{
  components[i] = (char *) malloc((size_t) (100 * sizeof(char *)));
  status = RM_GetComponent(id, i, components[i], 100);
  sprintf(str,"%10s    %10.3f\\n", components[i], gfw[i]);
  status = RM_OutputMessage(id, str);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance id returned from RM_Create.
* `gfw`: Array to receive the gram formula weights. Dimension of the array is *ncomps*,where *ncomps* is the number of components in the component list.
# See also
RM_FindComponents, RM_GetComponent,RM_GetComponentCount.
"""
function RM_GetGfw(id, gfw)
    ccall((:RM_GetGfw, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gfw)
end

"""
    RM_GetGridCellCount(id)

Returns the number of grid cells in the user's model, which is defined in the call to RM_Create.The mapping from grid cells to reaction cells is defined by RM_CreateMapping.The number of reaction cells may be less than the number of grid cells ifthere are inactive regions or symmetry in the model definition.

\\retvalNumber of grid cells in the user's model, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
nxyz = RM_GetGridCellCount(id);
sprintf(str1, "Number of grid cells in the user's model: %d\\n", nxyz);
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_Create, RM_CreateMapping.
"""
function RM_GetGridCellCount(id)
    ccall((:RM_GetGridCellCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetIPhreeqcId(id, i)

Returns an IPhreeqc id for the *ith* IPhreeqc instance in the reaction module.

For the threaded version, there are *nthreads* + 2 IPhreeqc instances, where*nthreads* is defined in the constructor (RM_Create).The number of threads can be determined by RM_GetThreadCount.The first *nthreads* (0 based) instances will be the workers, thenext (*nthreads*) is the InitialPhreeqc instance, and the next (*nthreads* + 1) is the Utility instance.Getting the IPhreeqc pointer for one of these instances allows the user to use any of the IPhreeqc methodson that instance.For MPI, each process has exactly three IPhreeqc instances, one worker (number 0),one InitialPhreeqc instance (number 1), and one Utility instance (number 2).

\\retvalIPhreeqc id for the *ith* IPhreeqc instance, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
// Utility pointer is worker number nthreads + 1
iphreeqc_id1 = RM_GetIPhreeqcId(id, RM_GetThreadCount(id) + 1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: The number of the IPhreeqc instance to be retrieved (0 based).
# See also
RM_Create, RM_GetThreadCount.See IPhreeqc documentation for descriptions of IPhreeqc methods.
"""
function RM_GetIPhreeqcId(id, i)
    ccall((:RM_GetIPhreeqcId, libPhreeqcRM), Cint, (Cint, Cint), id, i)
end

"""
    RM_GetKineticReactionsCount(id)

Returns the number of kinetic reactions in the initial-phreeqc module.RM_FindComponents must be called before RM_GetKineticReactionsCount.This method may be useful when generating selected output definitions related tokinetic reactions.

\\retvalThe number of kinetic reactions in the initial-phreeqc module.

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -kinetics\\n");
for (i = 0; i < RM_GetKineticReactionsCount(id); i++)
{
status = RM_GetKineticReactionsName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetKineticReactionsName.
"""
function RM_GetKineticReactionsCount(id)
    ccall((:RM_GetKineticReactionsCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetKineticReactionsName(id, num, name, l1)

Retrieves an item from the kinetic reactions list.The list includes all kinetic reactions included in any KINETICS definitions inthe initial-phreeqc module.RM_FindComponents must be called before RM_GetKineticReactionsName.This method may be useful when generating selected output definitions related to kinetic reactions.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -kinetics\\n");
for (i = 0; i < RM_GetKineticReactionsCount(id); i++)
{
status = RM_GetKineticReactionsName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the kinetic reaction name to be retrieved. (0 based index.)
* `name`: The kinetic reaction name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetKineticReactionsCount.
"""
function RM_GetKineticReactionsName(id, num, name, l1)
    ccall((:RM_GetKineticReactionsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetMpiMyself(id)

Returns the MPI task number. For the OPENMP version, the task number is alwayszero and the result of RM_GetMpiTasks is one. For the MPI version,the root task number is zero, and all workers have a task number greater than zero.The number of tasks can be obtained with RM_GetMpiTasks. The number oftasks and computer hosts are determined at run time by the mpiexec command, and thenumber of reaction-module processes is defined by the communicator used inconstructing the reaction modules (RM_Create).

\\retvalThe MPI task number for a process, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str1, "MPI task number:  %d\\n", RM_GetMpiMyself(id));
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetMpiTasks.
"""
function RM_GetMpiMyself(id)
    ccall((:RM_GetMpiMyself, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetMpiTasks(id)

Returns the number of MPI processes (tasks) assigned to the reaction module.For the OPENMP version, the number of tasks is alwaysone (although there may be multiple threads, RM_GetThreadCount),and the task number returned by RM_GetMpiMyself is zero. For the MPI version, the number oftasks and computer hosts are determined at run time by the mpiexec command. An MPI communicatoris used in constructing reaction modules for MPI. The communicator may define a subset of thetotal number of MPI processes.The root task number is zero, and all workers have a task number greater than zero.

\\retvalThe number of MPI processes assigned to the reaction module,negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
mpi_tasks = RM_GetMpiTasks(id);
sprintf(str1, "Number of MPI processes: %d\\n", mpi_tasks);
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_Create, RM_GetMpiMyself.
"""
function RM_GetMpiTasks(id)
    ccall((:RM_GetMpiTasks, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetNthSelectedOutputUserNumber(id, n)

Returns the user number for the *nth* selected-output definition.Definitions are sorted by user number. Phreeqc allows multiple selected-outputdefinitions, each of which is assigned a nonnegative integer identifier by theuser. The number of definitions can be obtained by RM_GetSelectedOutputCount.To cycle through all of the definitions, [`RM_GetNthSelectedOutputUserNumber`](@ref)can be used to identify the user number for each selected-output definitionin sequence. RM_SetCurrentSelectedOutputUserNumber is then used to selectthat user number for selected-output processing.

\\retvalThe user number of the *nth* selected-output definition, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  fprintf(stderr, "Selected output sequence number: %d\\n", isel);
  fprintf(stderr, "Selected output user number:     %d\\n", n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Process results here
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `n`: The sequence number of the selected-output definition for which the user number will be returned.C, 0 based.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetNthSelectedOutputUserNumber(id, n)
    ccall((:RM_GetNthSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint, Cint), id, n)
end

"""
    RM_GetPorosity(id, porosity)

Transfer current porosities to the array given in the argument list (*porosity*).Porosity is not changed by PhreeqcRM; the values are either the default valuesor the values set by the last call to RM_SetPorosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
porosity = (double*)malloc(nxyz*sizeof(double));
status = RM_GetPorosity(id, porosity);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `porosity`: Array to receive the porosities. Dimension of the arraymust be *nxyz*, where *nxyz* is the number of user grid cells(RM_GetGridCellCount). Values for inactive cells are set to 1e30.
"""
function RM_GetPorosity(id, porosity)
    ccall((:RM_GetPorosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, porosity)
end

"""
    RM_GetPressure(id, pressure)

Transfer current pressures to the array given in the argument list (*pressure*).Pressure is not usually calculated by PhreeqcRM; the values are either the default valuesor the values set by the last call to RM_SetPressure. Pressures can be calculatedby PhreeqcRM if a fixed-volume GAS\\_PHASE is used.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
pressure = (double*)malloc(nxyz*sizeof(double));
status = RM_GetPressure(id, pressure);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `pressure`: Array to receive the porosities. Dimension of the array must be*nxyz*, where *nxyz* is the number of user grid cells (RM_GetGridCellCount).Values for inactive cells are set to 1e30.
"""
function RM_GetPressure(id, pressure)
    ccall((:RM_GetPressure, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, pressure)
end

"""
    RM_GetSaturationCalculated(id, sat_calc)

Returns a vector of saturations (*sat*) as calculated by the reaction module.This method always returns solution\\_volume/(rv * porosity); the method RM_SetSaturationUser has no effect on the values returned.Reactions will change the volume of solution in a cell.The transport code must decide whether to ignore or account for this change in solution volume due to reactions. Following reactions, the cell saturation is calculated as solution volume (RM_GetSolutionVolume) divided by the product of representative volume (RM_SetRepresentativeVolume) and the porosity (RM_SetPorosity). The cell saturation returned by [`RM_GetSaturationCalculated`](@ref) may be less than or greater than the saturation set by the transport code (RM_SetSaturationUser and may be greater than or less than 1.0, even in fully saturated simulations. Only the following databases distributed with PhreeqcRM have molar volume information needed to accurately calculate solution volume and saturation: phreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sat_calc = (double *) malloc((size_t) (nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSaturationCalculated(id, sat_calc);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `sat_calc`: Vector to receive the saturations. Dimension of the array is set to *nxyz*,where *nxyz* is the number of user grid cells (RM_GetGridCellCount).Values for inactive cells are set to 1e30.
# See also
RM_GetSolutionVolume, RM_SetPorosity, RM_SetRepresentativeVolume, RM_SetSaturationUser.
"""
function RM_GetSaturationCalculated(id, sat_calc)
    ccall((:RM_GetSaturationCalculated, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat_calc)
end

"""
    RM_GetSaturation(id, sat_calc)

Deprecated equivalent of [`RM_GetSaturationCalculated`](@ref).
"""
function RM_GetSaturation(id, sat_calc)
    ccall((:RM_GetSaturation, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat_calc)
end

"""
    RM_GetSelectedOutput(id, so)

Populates an array with values from the current selected-output definition. RM_SetCurrentSelectedOutputUserNumberdetermines which of the selected-output definitions is used to populate the array.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Process results here
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `so`: An array to contain the selected-output values. Size of the array is *nxyz* x *col*,where *nxyz* is the number of grid cells in the user's model (RM_GetGridCellCount), and *col* is the number ofcolumns in the selected-output definition (RM_GetSelectedOutputColumnCount).
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetSelectedOutput(id, so)
    ccall((:RM_GetSelectedOutput, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, so)
end

"""
    RM_GetSelectedOutputColumnCount(id)

Returns the number of columns in the current selected-output definition. RM_SetCurrentSelectedOutputUserNumberdetermines which of the selected-output definitions is used.

\\retvalNumber of columns in the current selected-output definition, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Process results here
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetSelectedOutputColumnCount(id)
    ccall((:RM_GetSelectedOutputColumnCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSelectedOutputCount(id)

Returns the number of selected-output definitions. RM_SetCurrentSelectedOutputUserNumberdetermines which of the selected-output definitions is used.

\\retvalNumber of selected-output definitions, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Process results here
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetSelectedOutputCount(id)
    ccall((:RM_GetSelectedOutputCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSelectedOutputHeading(id, icol, heading, length)

Returns a selected output heading. The number of headings is determined by RM_GetSelectedOutputColumnCount.RM_SetCurrentSelectedOutputUserNumberdetermines which of the selected-output definitions is used.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
char heading[100];
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  for (j = 0; j < col; j++)
  {
	status = RM_GetSelectedOutputHeading(id, j, heading, 100);
	fprintf(stderr, "          %2d %10s\\n", j, heading);
  }
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `icol`: The sequence number of the heading to be retrieved. C, 0 based.
* `heading`: A string buffer to receive the heading.
* `length`: The maximum number of characters that can be written to the string buffer.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetSelectedOutputHeading(id, icol, heading, length)
    ccall((:RM_GetSelectedOutputHeading, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, icol, heading, length)
end

"""
    RM_GetSelectedOutputRowCount(id)

Returns the number of rows in the current selected-output definition. However, the methodis included only for convenience; the number of rows is always equal to the number ofgrid cells in the user's model, and is equal to RM_GetGridCellCount.

\\retvalNumber of rows in the current selected-output definition, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Print results
  for (i = 0; i < RM_GetSelectedOutputRowCount(id)/2; i++)
  {
    fprintf(stderr, "Cell number %d\\n", i);
    fprintf(stderr, "     Selected output: \\n");
    for (j = 0; j < col; j++)
    {
      status = RM_GetSelectedOutputHeading(id, j, heading, 100);
      fprintf(stderr, "          %2d %10s: %10.4f\\n", j, heading, selected_out[j*nxyz + i]);
    }
  }
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_GetSelectedOutputRowCount(id)
    ccall((:RM_GetSelectedOutputRowCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSICount(id)

Returns the number of phases in the initial-phreeqc module for which saturation indices can be calculated.RM_FindComponents must be called before RM_GetSICount.This method may be useful when generating selected output definitions related tosaturation indices.

\\retvalThe number of phases in the initial-phreeqc module for which saturation indicescould be calculated.

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -saturation_indices\\n");
for (i = 0; i < RM_GetSICount(id); i++)
{
status = RM_GetSIName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetSIName.
"""
function RM_GetSICount(id)
    ccall((:RM_GetSICount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSIName(id, num, name, l1)

Retrieves an item from the list of all phases for which saturation indices can be calculated.The list includes all phases that contain only elements included in the components inthe initial-phreeqc module.The list assumes that all components are present to be able to calculate the entire list of SIs;it may be that one or more components are missing in any specific cell.RM_FindComponents must be called before RM_GetSIName.This method may be useful when generating selected output definitions related to saturation indices.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -saturation_indices\\n");
for (i = 0; i < RM_GetSICount(id); i++)
{
status = RM_GetSIName(id, i, line1, 100);
sprintf(line, "%4s%20s\\n", "    ", line1);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the saturation-index-phase name to be retrieved. (0 based index.)
* `name`: The saturation-index-phase name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSICount.
"""
function RM_GetSIName(id, num, name, l1)
    ccall((:RM_GetSIName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetSolidSolutionComponentsCount(id)

Returns the number of solid solution components in the initial-phreeqc module. RM_FindComponents must be called before RM_GetSolidSolutionComponentsCount. This method may be useful when generating selected output definitions related to solid solutions.

\\retvalThe number of solid solution components in the initial-phreeqc module.

\\par C Example:

```c++
 <CODE>
 <PRE>
 Utilities::strcat_safe(input, MAX_LENGTH, "  -solid_solutions\\n");
 for (i = 0; i < RM_GetSolidSolutionComponentsCount(id); i++)
 {
 status = RM_GetSolidSolutionComponentsName(id, i, line1, 100);
 status = RM_GetSolidSolutionName(id, i, line2, 100);
 sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
 Utilities::strcat_safe(input, MAX_LENGTH, line);
 }
 </PRE>
 </CODE>
```

\\par MPI: Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents, RM_GetSolidSolutionComponentsName, RM_GetSolidSolutionName.
"""
function RM_GetSolidSolutionComponentsCount(id)
    ccall((:RM_GetSolidSolutionComponentsCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSolidSolutionComponentsName(id, num, name, l1)

Retrieves an item from the solid solution components list.The list includes all solid solution components included in any SOLID\\_SOLUTIONS definitions inthe initial-phreeqc module.RM_FindComponents must be called before RM_GetSolidSolutionComponentsName.This method may be useful when generating selected output definitions related to solid solutions.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -solid_solutions\\n");
for (i = 0; i < RM_GetSolidSolutionComponentsCount(id); i++)
{
status = RM_GetSolidSolutionComponentsName(id, i, line1, 100);
status = RM_GetSolidSolutionName(id, i, line2, 100);
sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the solid solution components name to be retrieved. (0 based index.)
* `name`: The solid solution compnent name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSolidSolutionComponentsCount, RM_GetSolidSolutionName.
"""
function RM_GetSolidSolutionComponentsName(id, num, name, l1)
    ccall((:RM_GetSolidSolutionComponentsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetSolidSolutionName(id, num, name, l1)

Retrieves an item from the solid solution names list.The list includes solid solution names included in SOLID\\_SOLUTIONS definitions inthe initial-phreeqc module.The solid solution names vector is the same length as the solid solution components vectorand provides the corresponding name of solid solution containing the component.RM_FindComponents must be called before RM_GetSolidSolutionName.This method may be useful when generating selected output definitions related to solid solutions.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcat_safe(input, MAX_LENGTH, "  -solid_solutions\\n");
for (i = 0; i < RM_GetSolidSolutionComponentsCount(id); i++)
{
status = RM_GetSolidSolutionComponentsName(id, i, line1, 100);
status = RM_GetSolidSolutionName(id, i, line2, 100);
sprintf(line, "%4s%20s%3s%20s\\n", "    ", line1, " # ", line2);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the solid solution name to be retrieved. (0 based index.)
* `name`: The solid solution name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSolidSolutionComponentsCount, RM_GetSolidSolutionComponentsName.
"""
function RM_GetSolidSolutionName(id, num, name, l1)
    ccall((:RM_GetSolidSolutionName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetSolutionVolume(id, vol)

Transfer solution volumes from the reaction cells to the array given in the argument list (*vol*).Solution volumes are those calculated by the reaction module.Only the following databases distributed with PhreeqcRM have molar volume informationneeded to accurately calculate solution volume:phreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
volume = (double *) malloc((size_t) (nxyz * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSolutionVolume(id, volume);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `vol`: Array to receive the solution volumes. Dimension of the array is (*nxyz*),where *nxyz* is the number of user grid cells. Values for inactive cells are set to 1e30.
# See also
RM_GetSaturationCalculated.
"""
function RM_GetSolutionVolume(id, vol)
    ccall((:RM_GetSolutionVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, vol)
end

"""
    RM_GetSpeciesConcentrations(id, species_conc)

Transfer concentrations of aqueous species to the array argument (*species_conc*)This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The list of aqueousspecies is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.Solution volumes used to calculate mol/L are calculated by the reaction module.Only the following databases distributed with PhreeqcRM have molar volume informationneeded to accurately calculate solution volume:phreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
nxyz = RM_GetGridCellCount(id);
species_c = (double *) malloc((size_t) (nxyz * nspecies * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSpeciesConcentrations(id, species_c);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `species_conc`: Array to receive the aqueous species concentrations.Dimension of the array is (*nxyz*, *nspecies*),where *nxyz* is the number of user grid cells (RM_GetGridCellCount),and *nspecies* is the number of aqueous species (RM_GetSpeciesCount).Concentrations are moles per liter.Values for inactive cells are set to 1e30.
# See also
RM_FindComponents, RM_GetSpeciesCount, RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName,RM_GetSpeciesSaveOn,RM_GetSpeciesZ, RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesConcentrations(id, species_conc)
    ccall((:RM_GetSpeciesConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_conc)
end

"""
    RM_GetSpeciesCount(id)

The number of aqueous species used in the reaction module.This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The list of aqueousspecies is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.

\\retvalIRM_RESULT The number of aqueous species, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
nxyz = RM_GetGridCellCount(id);
species_c = (double *) malloc((size_t) (nxyz * nspecies * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSpeciesConcentrations(id, species_c);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents, RM_GetSpeciesConcentrations,RM_GetSpeciesD25,RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName, RM_GetSpeciesSaveOn,RM_GetSpeciesZ, RM_SpeciesConcentrations2Module, RM_SetSpeciesSaveOn.
"""
function RM_GetSpeciesCount(id)
    ccall((:RM_GetSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSpeciesD25(id, diffc)

Transfers diffusion coefficients at 25C to the array argument (*diffc*).This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.Diffusion coefficients are defined in SOLUTION\\_SPECIES data blocks, normally in the database file.Databases distributed with the reaction module that have diffusion coefficients defined arephreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
diffc = (double *) malloc((size_t) (nspecies * sizeof(double)));
status = RM_GetSpeciesD25(id, diffc);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `diffc`: Array to receive the diffusion coefficients at 25 C, m^2/s.Dimension of the array is *nspecies*,where *nspecies* is is the number of aqueous species (RM_GetSpeciesCount).
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName, RM_GetSpeciesSaveOn, RM_GetSpeciesZ, RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesD25(id, diffc)
    ccall((:RM_GetSpeciesD25, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, diffc)
end

"""
    RM_GetSpeciesLog10Gammas(id, species_log10gammas)

Transfer aqueous-species log10 activity coefficients to the array argument (*species_log10gammas*)This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The list of aqueousspecies is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
nxyz = RM_GetGridCellCount(id);
species_log10gammas = (double *) malloc((size_t) (nxyz * nspecies * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSpeciesLog10Gammas(id, species_log10gammas);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `species_log10gammas`: Array to receive the aqueous species log10 activity coefficients.Dimension of the array is (*nxyz*, *nspecies*),where *nxyz* is the number of user grid cells (RM_GetGridCellCount),and *nspecies* is the number of aqueous species (RM_GetSpeciesCount).Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetSpeciesConcentrations,RM_GetSpeciesCount,RM_GetSpeciesD25,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName,RM_GetSpeciesSaveOn,RM_GetSpeciesZ,RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesLog10Gammas(id, species_log10gammas)
    ccall((:RM_GetSpeciesLog10Gammas, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_log10gammas)
end

"""
    RM_GetSpeciesLog10Molalities(id, species_log10molalities)

Transfer aqueous-species log10 molalities to the array argument (*species_log10molalities*)To use this method RM_SetSpeciesSaveOn must be set to *true*.The list of aqueousspecies is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
nxyz = RM_GetGridCellCount(id);
species_log10molalities = (double *) malloc((size_t) (nxyz * nspecies * sizeof(double)));
status = RM_RunCells(id);
status = RM_GetSpeciesLog10Molalities(id, species_log10molalities);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `species_log10molalities`: Array to receive the aqueous species log10 molalities.Dimension of the array is (*nxyz*, *nspecies*),where *nxyz* is the number of user grid cells (RM_GetGridCellCount),and *nspecies* is the number of aqueous species (RM_GetSpeciesCount).Values for inactive cells are set to 1e30.
# See also
RM_FindComponents,RM_GetSpeciesConcentrations,RM_GetSpeciesCount,RM_GetSpeciesD25,RM_GetSpeciesLog10Gammas,RM_GetSpeciesName,RM_GetSpeciesSaveOn,RM_GetSpeciesZ,RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesLog10Molalities(id, species_log10molalities)
    ccall((:RM_GetSpeciesLog10Molalities, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_log10molalities)
end

"""
    RM_GetSpeciesName(id, i, name, length)

Transfers the name of the *ith* aqueous species to the character argument (*name*).This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The list of aqueousspecies is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
char name[100];
...
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
for (i = 0; i < nspecies; i++)
{
  status = RM_GetSpeciesName(id, i, name, 100);
  fprintf(stderr, "%s\\n", name);
}
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `i`: Sequence number of the species in the species list. C, 0 based.
* `name`: Character array to receive the species name.
* `length`: Maximum length of string that can be stored in the character array.
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesSaveOn,RM_GetSpeciesZ,RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesName(id, i, name, length)
    ccall((:RM_GetSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, length)
end

"""
    RM_GetSpeciesSaveOn(id)

Returns the value of the species-save property.By default, concentrations of aqueous species are not saved. Setting the species-save property to true allowsaqueous species concentrations to be retrievedwith RM_GetSpeciesConcentrations, and solution compositions to be set withRM_SpeciesConcentrations2Module.

\\retvalIRM_RESULT 0, species are not saved; 1, species are saved; negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
save_on = RM_GetSpeciesSaveOn(id);
if (save_on .ne. 0)
{
  fprintf(stderr, "Reaction module is saving species concentrations\\n");
}
else
{
  fprintf(stderr, "Reaction module is not saving species concentrations\\n");
}
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName,RM_GetSpeciesZ, RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesSaveOn(id)
    ccall((:RM_GetSpeciesSaveOn, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSpeciesZ(id, z)

Transfers the charge of each aqueous species to the array argument (*z*).This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
z = (double *) malloc((size_t) (nspecies * sizeof(double)));
status = RM_GetSpeciesZ(id, z);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `z`: Array that receives the charge for each aqueous species.Dimension of the array is *nspecies*,where *nspecies* is is the number of aqueous species (RM_GetSpeciesCount).
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName, RM_GetSpeciesSaveOn,RM_SetSpeciesSaveOn,RM_SpeciesConcentrations2Module.
"""
function RM_GetSpeciesZ(id, z)
    ccall((:RM_GetSpeciesZ, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, z)
end

"""
    RM_GetStartCell(id, sc)

Returns an array with the starting cell numbers from the range of cell numbers assigned to each worker.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
n = RM_GetThreadCount(id) * RM_GetMpiTasks(id);
sc = (int *) malloc((size_t) (n * sizeof(int)));
status = RM_GetStartCell(id, sc);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `sc`: Array to receive the starting cell numbers. Dimension of the array is  the number of threads (OpenMP) or the number of processes (MPI).
# See also
RM_Create, RM_GetEndCell, RM_GetMpiTasks, RM_GetThreadCount.
"""
function RM_GetStartCell(id, sc)
    ccall((:RM_GetStartCell, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, sc)
end

"""
    RM_GetTemperature(id, temperature)

Returns an array of temperatures (*temperature*) from the reaction module.Reactions do not change the temperature, so the temperatures are either thetemperatures at initialization, or the values set with the last call toRM_SetTemperature.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
temperature = (double*)malloc(nxyz*sizeof(double));
status = RM_GetTemperature(id, temperature);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `temperature`: Allocatable array to receive the temperatures.Dimension of the array must be *nxyz*, where *nxyz* is the number ofuser grid cells (RM_GetGridCellCount). Values for inactive cells areset to 1e30.
# See also
RM_SetTemperature.
"""
function RM_GetTemperature(id, temperature)
    ccall((:RM_GetTemperature, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, temperature)
end

"""
    RM_GetSurfaceName(id, num, name, l1)

Retrieves the surface name (such as "Hfo") that corresponds withthe surface species name.The lists of surface species names and surface names are the same length.RM_FindComponents must be called before RM_GetSurfaceName.This method may be useful when generating selected output definitions related to surfaces.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetSurfaceSpeciesCount(id); i++)
{
status = RM_GetSurfaceSpeciesName(id, i, line1, 100);
status = RM_GetSurfaceType(id, i, line2, 100);
status = RM_GetSurfaceName(id, i, line3, 100);
sprintf(line, "%4s%20s%3s%20s%20s\\n", "    ", line1, " # ", line2, line3);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the surface name to be retrieved. (0 based index.)
* `name`: The surface name associated with surface species *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSurfaceSpeciesCount, RM_GetSurfaceSpeciesName, RM_GetSurfaceType.
"""
function RM_GetSurfaceName(id, num, name, l1)
    ccall((:RM_GetSurfaceName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetSurfaceSpeciesCount(id)

Returns the number of surface species (such as "Hfo\\_wOH") in the initial-phreeqc module.RM_FindComponents must be called before RM_GetSurfaceSpeciesCount.This method may be useful when generating selected output definitions related to surfaces.

\\retvalThe number of surface species in the initial-phreeqc module.

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetSurfaceSpeciesCount(id); i++)
{
status = RM_GetSurfaceSpeciesName(id, i, line1, 100);
status = RM_GetSurfaceType(id, i, line2, 100);
status = RM_GetSurfaceName(id, i, line3, 100);
sprintf(line, "%4s%20s%3s%20s%20s\\n", "    ", line1, " # ", line2, line3);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_FindComponents,RM_GetSurfaceSpeciesName, RM_GetSurfaceType, RM_GetSurfaceName.
"""
function RM_GetSurfaceSpeciesCount(id)
    ccall((:RM_GetSurfaceSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetSurfaceSpeciesName(id, num, name, l1)

Retrieves an item from the surface species list.The list of surface species (for example, "Hfo\\_wOH") is derived from the list of components(RM_FindComponents) and the list of all surface types (such as "Hfo\\_w")that are included in SURFACE definitions in the initial-phreeqc module.RM_FindComponents must be called before RM_GetSurfaceSpeciesName.This method may be useful when generating selected output definitions related to surfaces.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetSurfaceSpeciesCount(id); i++)
{
status = RM_GetSurfaceSpeciesName(id, i, line1, 100);
status = RM_GetSurfaceType(id, i, line2, 100);
status = RM_GetSurfaceName(id, i, line3, 100);
sprintf(line, "%4s%20s%3s%20s%20s\\n", "    ", line1, " # ", line2, line3);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the surface type to be retrieved. (0 based index.)
* `name`: The surface species name at number *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSurfaceSpeciesCount, RM_GetSurfaceType, RM_GetSurfaceName.
"""
function RM_GetSurfaceSpeciesName(id, num, name, l1)
    ccall((:RM_GetSurfaceSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetSurfaceType(id, num, name, l1)

Retrieves the surface site type (such as "Hfo\\_w") that corresponds withthe surface species name.The lists of surface species names and surface species types are the same length.RM_FindComponents must be called before RM_GetSurfaceType.This method may be useful when generating selected output definitions related to surfaces.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (i = 0; i < RM_GetSurfaceSpeciesCount(id); i++)
{
status = RM_GetSurfaceSpeciesName(id, i, line1, 100);
status = RM_GetSurfaceType(id, i, line2, 100);
status = RM_GetSurfaceName(id, i, line3, 100);
sprintf(line, "%4s%20s%3s%20s%20s\\n", "    ", line1, " # ", line2, line3);
Utilities::strcat_safe(input, MAX_LENGTH, line);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `num`: The number of the surface type to be retrieved. (0 based index.)
* `name`: The surface type associated with surface species *num*.
* `l1`: The length of the maximum number of characters for *name*.
# See also
RM_FindComponents,RM_GetSurfaceSpeciesCount, RM_GetSurfaceSpeciesName, RM_GetSurfaceName.
"""
function RM_GetSurfaceType(id, num, name, l1)
    ccall((:RM_GetSurfaceType, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

"""
    RM_GetThreadCount(id)

Returns the number of threads, which is equal to the number of workers used to run in parallel with OPENMP.For the OPENMP version, the number of threads is set implicitly or explicitly with RM_Create. For theMPI version, the number of threads is always one for each process.

\\retvalThe number of threads, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str1, "Number of threads: %d\\n", RM_GetThreadCount(id));
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers; result is always 1.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetMpiTasks.
"""
function RM_GetThreadCount(id)
    ccall((:RM_GetThreadCount, libPhreeqcRM), Cint, (Cint,), id)
end

"""
    RM_GetTime(id)

Returns the current simulation time in seconds. The reaction module does not change the time value, so thereturned value is equal to the default (0.0) or the last time set by RM_SetTime.

\\retvalThe current simulation time in seconds.

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str, "%s%10.1f%s", "Beginning reaction calculation ",
        RM_GetTime(id) * RM_GetTimeConversion(id), " days\\n");
status = RM_LogMessage(id, str);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetTimeConversion, RM_GetTimeStep, RM_SetTime,RM_SetTimeConversion, RM_SetTimeStep.
"""
function RM_GetTime(id)
    ccall((:RM_GetTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_GetTimeConversion(id)

Returns a multiplier to convert time from seconds to another unit, as specified by the user.The reaction module uses seconds as the time unit. The user can set a conversionfactor (RM_SetTimeConversion) and retrieve it with [`RM_GetTimeConversion`](@ref). Thereaction module only uses the conversion factor when printing the long versionof cell chemistry (RM_SetPrintChemistryOn), which is rare. Default conversion factor is 1.0.

\\retvalMultiplier to convert seconds to another time unit.

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str, "%s%10.1f%s", "Beginning reaction calculation ",
        RM_GetTime(id) * RM_GetTimeConversion(id), " days\\n");
status = RM_LogMessage(id, str);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetTime, RM_GetTimeStep, RM_SetTime, RM_SetTimeConversion, RM_SetTimeStep.
"""
function RM_GetTimeConversion(id)
    ccall((:RM_GetTimeConversion, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_GetTimeStep(id)

Returns the current simulation time step in seconds.This is the time over which kinetic reactions are integrated in a call to RM_RunCells.The reaction module does not change the time step value, so thereturned value is equal to the default (0.0) or the last time step set by RM_SetTimeStep.

\\retvalThe current simulation time step in seconds.

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str, "%s%10.1f%s", "          Time step                  ",
        RM_GetTimeStep(id) * RM_GetTimeConversion(id), " days\\n");
status = RM_LogMessage(id, str);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_GetTime, RM_GetTimeConversion, RM_SetTime,RM_SetTimeConversion, RM_SetTimeStep.
"""
function RM_GetTimeStep(id)
    ccall((:RM_GetTimeStep, libPhreeqcRM), Cdouble, (Cint,), id)
end

"""
    RM_GetViscosity(id, viscosity)

Transfer current viscosities to the array given in the argument list (*viscosity*).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
viscosity = (double*)malloc(nxyz*sizeof(double));
status = RM_GetViscosity(id, viscosity);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `viscosity`: Allocated array to receive the viscosities. Dimension ofthe array must be *nxyz*, where *nxyz* is the number of user grid cells(RM_GetGridCellCount). Values for inactive cells are set to 1e30.
"""
function RM_GetViscosity(id, viscosity)
    ccall((:RM_GetViscosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, viscosity)
end

"""
    RM_InitialPhreeqc2Concentrations(id, c, n_boundary, boundary_solution1, boundary_solution2, fraction1)

Fills an array (*c*) with concentrations from solutions in the InitialPhreeqc instance.The method is used to obtain concentrations for boundary conditions. If a negative valueis used for a cell in *boundary_solution1*, then the highest numbered solution in the InitialPhreeqc instancewill be used for that cell. Concentrations may be a mixture of twosolutions, *boundary_solution1* and *boundary_solution2*, with a mixing fraction for *boundary_solution1* 1 of*fraction1* and mixing fraction for *boundary_solution2* of (1 - *fraction1*).A negative value for *boundary_solution2* implies no mixing, and the associated value for *fraction1* is ignored.If *boundary_solution2* and fraction1 are NULL,no mixing is used; concentrations are derived from *boundary_solution1* only.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
nbound = 1;
bc1 = (int *) malloc((size_t) (nbound * sizeof(int)));
bc2 = (int *) malloc((size_t) (nbound * sizeof(int)));
bc_f1 = (double *) malloc((size_t) (nbound * sizeof(double)));
bc_conc = (double *) malloc((size_t) (ncomps * nbound * sizeof(double)));
for (i = 0; i < nbound; i++)
{
  bc1[i]          = 0;       // Solution 0 from InitialPhreeqc instance
  bc2[i]          = -1;      // no bc2 solution for mixing
  bc_f1[i]        = 1.0;     // mixing fraction for bc1
}
status = RM_InitialPhreeqc2Concentrations(id, bc_conc, nbound, bc1, bc2, bc_f1);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `c`: Array of concentrations extracted from the InitialPhreeqc instance.The dimension of *c* is e*n_boundary* * *ncomp*,where *ncomp* is the number of components returned from RM_FindComponents or RM_GetComponentCount.
* `n_boundary`: The number of boundary condition solutions that need to be filled.
* `boundary_solution1`: Array of solution index numbers that refer to solutions in the InitialPhreeqc instance.Size is *n_boundary*.
* `boundary_solution2`: Array of solution index numbers that that refer to solutions in the InitialPhreeqc instanceand are defined to mix with *boundary_solution1*.Size is *n_boundary*. May be NULL in C.
* `fraction1`: Fraction of *boundary_solution1* that mixes with (1-*fraction1*) of *boundary_solution2*.Size is (n\\_boundary). May be NULL in C.
# See also
RM_FindComponents, RM_GetComponentCount.
"""
function RM_InitialPhreeqc2Concentrations(id, c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
    ccall((:RM_InitialPhreeqc2Concentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
end

"""
    RM_InitialSolutions2Module(id, solutions)

Transfer SOLUTION definitions from the InitialPhreeqc instance to the reaction-module workers.*solutions* is used to select SOLUTION definitions for eachcell of the model. *solutions* is dimensioned *nxyz*, where *nxyz* is thenumber of grid cells in the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
solutions = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) solutions[i] = 1;
status = RM_InitialSolutions2Module(id, solutions);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `solutions`: Array of SOLUTION index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative valuesare ignored, resulting in no transfer of a SOLUTION definition for that cell.(Note that all cells must have a SOLUTION definition, which could be definedby other calls to [`RM_InitialSolutions2Module`](@ref), RM_InitialPhreeqc2Module,or RM_InitialPhreeqcCell2Module.)
# See also
RM_InitialEquilibriumPhases2Module,RM_InitialExchanges2Module,RM_InitialGasPhases2Module,RM_InitialKinetics2Module,RM_InitialSolidSolutions2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialSolutions2Module(id, solutions)
    ccall((:RM_InitialSolutions2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, solutions)
end

"""
    RM_InitialEquilibriumPhases2Module(id, equilibrium_phases)

Transfer EQUILIBRIUM\\_PHASES definitions from the InitialPhreeqc instance to thereaction-module workers.*equilibrium_phases* is used to select EQUILIBRIUM\\_PHASES definitions for eachcell of the model. *equilibrium_phases* is dimensioned *nxyz*, where *nxyz* isthe number of grid cells in the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
equilibrium_phases = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) equilibrium_phases[i] = 1;
status = RM_InitialEquilibriumPhases2Module(id, equilibrium_phases);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `equilibrium_phases`: Array of EQUILIBRIUM\\_PHASES index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative values areignored, resulting in no transfer of an EQUILIBRIUM\\_PHASES definition for that cell.(Note that an EQUILIBRIUM\\_PHASES definition for a cell could be defined by othercalls to [`RM_InitialEquilibriumPhases2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialExchanges2Module,RM_InitialGasPhases2Module,RM_InitialKinetics2Module,RM_InitialSolidSolutions2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialEquilibriumPhases2Module(id, equilibrium_phases)
    ccall((:RM_InitialEquilibriumPhases2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, equilibrium_phases)
end

"""
    RM_InitialExchanges2Module(id, exchanges)

Transfer EXCHANGE definitions from the InitialPhreeqc instance to thereaction-module workers.*exchanges* is used to select EXCHANGE definitions for each cell of the model.*exchanges* is dimensioned *nxyz*, where *nxyz* is the number of grid cellsin the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
exchanges = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) exchanges[i] = 1;
status = RM_InitialExchanges2Module(id, exchanges);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `exchanges`: Vector of EXCHANGE index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative valuesare ignored, resulting in no transfer of an EXCHANGE definition for that cell.(Note that an EXCHANGE definition for a cell could be defined by othercalls to [`RM_InitialExchanges2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialEquilibriumPhases2Module,RM_InitialGasPhases2Module,RM_InitialKinetics2Module,RM_InitialSolidSolutions2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialExchanges2Module(id, exchanges)
    ccall((:RM_InitialExchanges2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, exchanges)
end

"""
    RM_InitialSurfaces2Module(id, surfaces)

Transfer SURFACE definitions from the InitialPhreeqc instance to thereaction-module workers.*surfaces* is used to select SURFACE definitions for each cell of the model.*surfaces* is dimensioned *nxyz*, where *nxyz* is the number of grid cellsin the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
surfaces = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) surfaces[i] = 1;
status = RM_InitialSurfaces2Module(id, surfaces);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `surfaces`: Array of SURFACE index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative valuesare ignored, resulting in no transfer of a SURFACE definition for that cell.(Note that an SURFACE definition for a cell could be defined by othercalls to [`RM_InitialSurfaces2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialEquilibriumPhases2Module,RM_InitialExchanges2Module,RM_InitialGasPhases2Module,RM_InitialKinetics2Module,RM_InitialSolidSolutions2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialSurfaces2Module(id, surfaces)
    ccall((:RM_InitialSurfaces2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, surfaces)
end

"""
    RM_InitialGasPhases2Module(id, gas_phases)

Transfer GAS\\_PHASE definitions from the InitialPhreeqc instance to thereaction-module workers.*gas_phases* is used to select GAS\\_PHASE definitions for each cell of the model.*gas_phases* is dimensioned *nxyz*, where *nxyz* is the number of grid cellsin the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
gas_phases = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) gas_phases[i] = 1;
status = RM_InitialGasPhases2Module(id, gas_phases);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_phases`: Vector of GAS\\_PHASE index numbers that refer todefinitions in the InitialPhreeqc instance.Size is *nxyz*. Negative values areignored, resulting in no transfer of a GAS\\_PHASE definition for that cell.(Note that an GAS\\_PHASE definition for a cell could be defined by othercalls to [`RM_InitialGasPhases2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialEquilibriumPhases2Module,RM_InitialExchanges2Module,RM_InitialKinetics2Module,RM_InitialSolidSolutions2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialGasPhases2Module(id, gas_phases)
    ccall((:RM_InitialGasPhases2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, gas_phases)
end

"""
    RM_InitialSolidSolutions2Module(id, solid_solutions)

Transfer SOLID\\_SOLUTIONS definitions from the InitialPhreeqc instance to thereaction-module workers.*solid_solutions* is used to select SOLID\\_SOLUTIONS definitions for each cellof the model. *solid_solutions* is dimensioned *nxyz*, where *nxyz* is thenumber of grid cells in the user's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
solid_solutions = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) solid_solutions[i] = 1;
status = RM_InitialSolidSolutions2Module(id, solid_solutions);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `solid_solutions`: Array of SOLID\\_SOLUTIONS index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative valuesare ignored, resulting in no transfer of a SOLID\\_SOLUTIONS definition for that cell.(Note that an SOLID\\_SOLUTIONS definition for a cell could be defined by othercalls to [`RM_InitialSolidSolutions2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialEquilibriumPhases2Module,RM_InitialExchanges2Module,RM_InitialGasPhases2Module,RM_InitialKinetics2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialSolidSolutions2Module(id, solid_solutions)
    ccall((:RM_InitialSolidSolutions2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, solid_solutions)
end

"""
    RM_InitialKinetics2Module(id, kinetics)

Transfer KINETICS definitions from the InitialPhreeqc instance to thereaction-module workers.*kinetics* is used to select KINETICS definitions for each cell of the model.*kinetics* is dimensioned *nxyz*, where *nxyz* is the number of grid cells in theuser's model (RM_GetGridCellCount).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
kinetics = (double*)malloc(nxyz*sizeof(double));
for (i=0; i < nxyz; i++) kinetics[i] = 1;
status = RM_InitialKinetics2Module(id, kinetics);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `kinetics`: Array of KINETICS index numbers that refer todefinitions in the InitialPhreeqc instance. Size is *nxyz*. Negative values areignored, resulting in no transfer of a KINETICS definition for that cell.(Note that an KINETICS definition for a cell could be defined by othercalls to [`RM_InitialKinetics2Module`](@ref), RM_InitialPhreeqc2Module, orRM_InitialPhreeqcCell2Module.)
# See also
RM_InitialSolutions2Module,RM_InitialEquilibriumPhases2Module,RM_InitialExchanges2Module,RM_InitialGasPhases2Module,RM_InitialSolidSolutions2Module,RM_InitialSurfaces2Module,RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module.
"""
function RM_InitialKinetics2Module(id, kinetics)
    ccall((:RM_InitialKinetics2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, kinetics)
end

"""
    RM_InitialPhreeqc2Module(id, initial_conditions1, initial_conditions2, fraction1)

Transfer solutions and reactants from the InitialPhreeqc instance to the reaction-module workers, possibly with mixing.In its simplest form, *initial_conditions1* is used to select initial conditions, including solutions and reactants,for each cell of the model, without mixing.*Initial_conditions1* is dimensioned (*nxyz*, 7), where *nxyz* is the number of grid cells in the user's model(RM_GetGridCellCount). The dimension of 7 refers to solutions and reactants in the following order:(1) SOLUTIONS, (2) EQUILIBRIUM\\_PHASES, (3) EXCHANGE, (4) SURFACE, (5) GAS\\_PHASE,(6) SOLID\\_SOLUTIONS, and (7) KINETICS. In C, initial\\_solution1[3*nxyz + 99] = 2, indicates thatcell 99 (0 based) contains the SURFACE definition with user number 2 that has been defined in theInitialPhreeqc instance (either by RM_RunFile or RM_RunString).It is also possible to mix solutions and reactants to obtain the initial conditions for cells. For mixing,*initials_conditions2* contains numbers for a second entity that mixes with the entity defined in *initial_conditions1*.*Fraction1* contains the mixing fraction for *initial_conditions1*, whereas (1 - *fraction1*) is the mixing fraction for*initial_conditions2*.In C, initial\\_solution1[3*nxyz + 99] = 2, initial\\_solution2[3*nxyz + 99] = 3,fraction1[3*nxyz + 99] = 0.25 indicates thatcell 99 (0 based) contains a mixture of 0.25 SURFACE 2 and 0.75 SURFACE 3, where the surface compositions have been defined in theInitialPhreeqc instance. If the user number in *initial_conditions2* is negative, no mixing occurs.If *initials_conditions2* and *fraction1* are NULL,no mixing is used, and initial conditions are derived solely from *initials_conditions1*.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ic1 = (int *) malloc((size_t) (7 * nxyz * sizeof(int)));
ic2 = (int *) malloc((size_t) (7 * nxyz * sizeof(int)));
f1 = (double *) malloc((size_t) (7 * nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++)
{
  ic1[i]          = 1;       // Solution 1
  ic1[nxyz + i]   = -1;      // Equilibrium phases none
  ic1[2*nxyz + i] = 1;       // Exchange 1
  ic1[3*nxyz + i] = -1;      // Surface none
  ic1[4*nxyz + i] = -1;      // Gas phase none
  ic1[5*nxyz + i] = -1;      // Solid solutions none
  ic1[6*nxyz + i] = -1;      // Kinetics none
  ic2[i]          = -1;      // Solution none
  ic2[nxyz + i]   = -1;      // Equilibrium phases none
  ic2[2*nxyz + i] = -1;      // Exchange none
  ic2[3*nxyz + i] = -1;      // Surface none
  ic2[4*nxyz + i] = -1;      // Gas phase none
  ic2[5*nxyz + i] = -1;      // Solid solutions none
  ic2[6*nxyz + i] = -1;      // Kinetics none
  f1[i]          = 1.0;      // Mixing fraction ic1 Solution
  f1[nxyz + i]   = 1.0;      // Mixing fraction ic1 Equilibrium phases
  f1[2*nxyz + i] = 1.0;      // Mixing fraction ic1 Exchange 1
  f1[3*nxyz + i] = 1.0;      // Mixing fraction ic1 Surface
  f1[4*nxyz + i] = 1.0;      // Mixing fraction ic1 Gas phase
  f1[5*nxyz + i] = 1.0;      // Mixing fraction ic1 Solid solutions
  f1[6*nxyz + i] = 1.0;      // Mixing fraction ic1 Kinetics
}
status = RM_InitialPhreeqc2Module(id, ic1, ic2, f1);
// No mixing is defined, so the following is equivalent
status = RM_InitialPhreeqc2Module(id, ic1, NULL, NULL);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `initial_conditions1`: Array of solution and reactant index numbers that refer to definitions in the InitialPhreeqc instance.Size is (*nxyz*,7). The order of definitions is given above.Negative values are ignored, resulting in no definition of that entity for that cell.
* `initial_conditions2`: Array of solution and reactant index numbers that refer to definitions in the InitialPhreeqc instance.Nonnegative values of *initial_conditions2* result in mixing with the entities defined in *initial_conditions1*.Negative values result in no mixing.Size is (*nxyz*,7). The order of definitions is given above.May be NULL in C; setting to NULL results in no mixing.
* `fraction1`: Fraction of initial\\_conditions1 that mixes with (1-*fraction1*) of initial\\_conditions2.Size is (nxyz,7). The order of definitions is given above.May be NULL in C; setting to NULL results in no mixing.
# See also
RM_InitialPhreeqcCell2Module.
"""
function RM_InitialPhreeqc2Module(id, initial_conditions1, initial_conditions2, fraction1)
    ccall((:RM_InitialPhreeqc2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, initial_conditions1, initial_conditions2, fraction1)
end

"""
    RM_InitialPhreeqc2SpeciesConcentrations(id, species_c, n_boundary, boundary_solution1, boundary_solution2, fraction1)

Fills an array (*species_c*) with aqueous species concentrations from solutions in the InitialPhreeqc instance.This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The method is used to obtain aqueous species concentrations for boundary conditions. If a negative valueis used for a cell in *boundary_solution1*, then the highest numbered solution in the InitialPhreeqc instancewill be used for that cell.Concentrations may be a mixture of twosolutions, *boundary_solution1* and *boundary_solution2*, with a mixing fraction for *boundary_solution1* 1 of*fraction1* and mixing fraction for *boundary_solution2* of (1 - *fraction1*).A negative value for *boundary_solution2* implies no mixing, and the associated value for *fraction1* is ignored.If *boundary_solution2* and *fraction1* are NULL,no mixing is used; concentrations are derived from *boundary_solution1* only.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
nbound = 1;
nspecies = RM_GetSpeciesCount(id);
bc1 = (int *) malloc((size_t) (nbound * sizeof(int)));
bc2 = (int *) malloc((size_t) (nbound * sizeof(int)));
bc_f1 = (double *) malloc((size_t) (nbound * sizeof(double)));
bc_conc = (double *) malloc((size_t) (nspecies * nbound * sizeof(double)));
for (i = 0; i < nbound; i++)
{
  bc1[i]          = 0;       // Solution 0 from InitialPhreeqc instance
  bc2[i]          = -1;      // no bc2 solution for mixing
  bc_f1[i]        = 1.0;     // mixing fraction for bc1
}
status = RM_InitialPhreeqc2SpeciesConcentrations(id, bc_conc, nbound, bc1, bc2, bc_f1);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `species_c`: Array of aqueous concentrations extracted from the InitialPhreeqc instance.The dimension of *species_c* is *n_boundary* * *nspecies*,where *nspecies* is the number of aqueous species returned from RM_GetSpeciesCount.
* `n_boundary`: The number of boundary condition solutions that need to be filled.
* `boundary_solution1`: Array of solution index numbers that refer to solutions in the InitialPhreeqc instance.Size is *n_boundary*.
* `boundary_solution2`: Array of solution index numbers that that refer to solutions in the InitialPhreeqc instanceand are defined to mix with *boundary_solution1*.Size is *n_boundary*. May be NULL in C.
* `fraction1`: Fraction of *boundary_solution1* that mixes with (1-*fraction1*) of *boundary_solution2*.Size is *n_boundary*. May be NULL in C.
# See also
RM_FindComponents, RM_GetSpeciesCount, RM_SetSpeciesSaveOn.
"""
function RM_InitialPhreeqc2SpeciesConcentrations(id, species_c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
    ccall((:RM_InitialPhreeqc2SpeciesConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, species_c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
end

"""
    RM_InitialPhreeqcCell2Module(id, n, module_numbers, dim_module_numbers)

A cell numbered *n* in the InitialPhreeqc instance is selected to populate a series of cells.All reactants with the number *n* are transferred along with the solution.If MIX *n* exists, it is used for the definition of the solution.If *n* is negative, *n* is redefined to be the largest solution or MIX number in the InitialPhreeqc instance.All reactants for each cell in the list *module_numbers* are removed before the celldefinition is copied from the InitialPhreeqc instance to the workers.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
module_cells = (int *) malloc((size_t) (2 * sizeof(int)));
module_cells[0] = 18;
module_cells[1] = 19;
// n will be the largest SOLUTION number in InitialPhreeqc instance
// copies solution and reactants to cells 18 and 19
status = RM_InitialPhreeqcCell2Module(id, -1, module_cells, 2);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `n`: Cell number refers to a solution or MIX and associated reactants in the InitialPhreeqc instance.A negative number indicates the largest solution or MIX number in the InitialPhreeqc instance will be used.
* `module_numbers`: A list of cell numbers in the user's grid-cell numbering system that will be populated withcell *n* from the InitialPhreeqc instance.
* `dim_module_numbers`: The number of cell numbers in the *module_numbers* list.
# See also
RM_InitialPhreeqc2Module.
"""
function RM_InitialPhreeqcCell2Module(id, n, module_numbers, dim_module_numbers)
    ccall((:RM_InitialPhreeqcCell2Module, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cint}, Cint), id, n, module_numbers, dim_module_numbers)
end

"""
    RM_LoadDatabase(id, db_name)

Load a database for all IPhreeqc instances--workers, InitialPhreeqc, and Utility. All definitionsof the reaction module are cleared (SOLUTION\\_SPECIES, PHASES, SOLUTIONs, etc.), and the database is read.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_LoadDatabase(id, "phreeqc.dat");
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `db_name`: String containing the database name.
# See also
RM_Create.
"""
function RM_LoadDatabase(id, db_name)
    ccall((:RM_LoadDatabase, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, db_name)
end

"""
    RM_LogMessage(id, str)

Print a message to the log file.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str, "%s%10.1f%s", "Beginning transport calculation      ",
        RM_GetTime(id) * RM_GetTimeConversion(id), " days\\n");
status = RM_LogMessage(id, str);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `str`: String to be printed.
# See also
RM_ErrorMessage, RM_OpenFiles, RM_OutputMessage, RM_ScreenMessage, RM_WarningMessage.
"""
function RM_LogMessage(id, str)
    ccall((:RM_LogMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

"""
    RM_MpiWorker(id)

MPI only. Workers (processes with RM_GetMpiMyself > 0) must call [`RM_MpiWorker`](@ref) to be able torespond to messages from the root to accept data, perform calculations, and(or) return data. [`RM_MpiWorker`](@ref) contains a loop that reads a message from root, performs atask, and waits for another message from root. RM_SetConcentrations, RM_RunCells, and RM_GetConcentrationsare examples of methods that send a message from root to get the workers to perform a task. The workers willrespond to all methods that are designated "workers must be in the loop of [`RM_MpiWorker`](@ref)" in theMPI section of the method documentation.The workers will continue to respond to messages from root until root callsRM_MpiWorkerBreak.(Advanced) The list of tasks that the workers perform can be extended by using RM_SetMpiWorkerCallback.It is then possible to use the MPI processes to perform other developer-defined tasks, such as transport calculations, withoutexiting from the [`RM_MpiWorker`](@ref) loop. Alternatively, root calls RM_MpiWorkerBreak to allow the workers to continuepast a call to [`RM_MpiWorker`](@ref). The workers perform developer-defined calculations, and then [`RM_MpiWorker`](@ref) is called again to respond torequests from root to perform reaction-module tasks.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError). [`RM_MpiWorker`](@ref) returns a value only whenRM_MpiWorkerBreak is called by root.

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_MpiWorker(id);
</PRE>
</CODE>
```

\\par MPI:Called by all workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_MpiWorkerBreak, RM_SetMpiWorkerCallback, RM_SetMpiWorkerCallbackCookie.
"""
function RM_MpiWorker(id)
    ccall((:RM_MpiWorker, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_MpiWorkerBreak(id)

MPI only. This method is called by root to force workers (processes with RM_GetMpiMyself > 0)to return from a call to RM_MpiWorker.RM_MpiWorker contains a loop that reads a message from root, performs atask, and waits for another message from root. The workers respond to all methods that are designated"workers must be in the loop of [`RM_MpiWorker`](@ref)" in theMPI section of the method documentation.The workers will continue to respond to messages from root until root calls [`RM_MpiWorkerBreak`](@ref).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_MpiWorkerBreak(id);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_MpiWorker, RM_SetMpiWorkerCallback, RM_SetMpiWorkerCallbackCookie.
"""
function RM_MpiWorkerBreak(id)
    ccall((:RM_MpiWorkerBreak, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_OpenFiles(id)

Opens the output and log files. Files are named prefix.chem.txt and prefix.log.txtbased on the prefix defined by RM_SetFilePrefix.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetFilePrefix(id, "Advect_c");
status = RM_OpenFiles(id);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_CloseFiles, RM_ErrorMessage, RM_GetFilePrefix, RM_LogMessage, RM_OutputMessage, RM_SetFilePrefix, RM_WarningMessage.
"""
function RM_OpenFiles(id)
    ccall((:RM_OpenFiles, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_OutputMessage(id, str)

Print a message to the output file.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str1, "Number of threads:                                %d\\n", RM_GetThreadCount(id));
status = RM_OutputMessage(id, str1);
sprintf(str1, "Number of MPI processes:                          %d\\n", RM_GetMpiTasks(id));
status = RM_OutputMessage(id, str1);
sprintf(str1, "MPI task number:                                  %d\\n", RM_GetMpiMyself(id));
status = RM_OutputMessage(id, str1);
status = RM_GetFilePrefix(id, str, 100);
sprintf(str1, "File prefix:                                      %s\\n", str);
status = RM_OutputMessage(id, str1);
sprintf(str1, "Number of grid cells in the user's model:         %d\\n", RM_GetGridCellCount(id));
status = RM_OutputMessage(id, str1);
sprintf(str1, "Number of chemistry cells in the reaction module: %d\\n", RM_GetChemistryCellCount(id));
status = RM_OutputMessage(id, str1);
sprintf(str1, "Number of components for transport:               %d\\n", RM_GetComponentCount(id));
status = RM_OutputMessage(id, str1);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `str`: String to be printed.
# See also
RM_ErrorMessage, RM_LogMessage, RM_ScreenMessage, RM_WarningMessage.
"""
function RM_OutputMessage(id, str)
    ccall((:RM_OutputMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

"""
    RM_RunCells(id)

Runs a reaction step for all of the cells in the reaction module.Normally, tranport concentrations are transferred to the reaction cells (RM_SetConcentrations) beforereaction calculations are run. The length of time over which kinetic reactions are integrated is setby RM_SetTimeStep. Other properties that may need to be updated as a result of the transportcalculations include porosity (RM_SetPorosity), saturation (RM_SetSaturationUser),temperature (RM_SetTemperature), and pressure (RM_SetPressure).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetPorosity(id, por);              // If porosity changes
status = RM_SetSaturationUser(id, sat);            // If saturation changes
status = RM_SetTemperature(id, temperature);   // If temperature changes
status = RM_SetPressure(id, pressure);         // If pressure changes
status = RM_SetConcentrations(id, c);          // Transported concentrations
status = RM_SetTimeStep(id, time_step);        // Time step for kinetic reactions
status = RM_RunCells(id);
status = RM_GetConcentrations(id, c);          // Concentrations after reaction
status = RM_GetDensityCalculated(id, density);           // Density after reaction
status = RM_GetSolutionVolume(id, volume);     // Solution volume after reaction
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
# See also
RM_SetConcentrations, RM_SetPorosity,RM_SetPressure, RM_SetSaturationUser, RM_SetTemperature, RM_SetTimeStep.
"""
function RM_RunCells(id)
    ccall((:RM_RunCells, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

"""
    RM_RunFile(id, workers, initial_phreeqc, utility, chem_name)

Run a PHREEQC input file. The first three arguments determine which IPhreeqc instances will runthe file--the workers, the InitialPhreeqc instance, and (or) the Utility instance. Inputfiles that modify the thermodynamic database should be run by all three sets of instances.Files with SELECTED\\_OUTPUT definitions that will be used during the time-stepping loop need tobe run by the workers. Files that contain initial conditions or boundary conditions shouldbe run by the InitialPhreeqc instance.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_RunFile(id, 1, 1, 1, "advect.pqi");
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `workers`: 1, the workers will run the file; 0, the workers will not run the file.
* `initial_phreeqc`: 1, the InitialPhreeqc instance will run the file; 0, the InitialPhreeqc will not run the file.
* `utility`: 1, the Utility instance will run the file; 0, the Utility instance will not run the file.
* `chem_name`: Name of the file to run.
# See also
RM_RunString.
"""
function RM_RunFile(id, workers, initial_phreeqc, utility, chem_name)
    ccall((:RM_RunFile, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint, Ptr{Cchar}), id, workers, initial_phreeqc, utility, chem_name)
end

"""
    RM_RunString(id, workers, initial_phreeqc, utility, input_string)

Run a PHREEQC input string. The first three arguments determine whichIPhreeqc instances will runthe string--the workers, the InitialPhreeqc instance, and (or) the Utility instance. Inputstrings that modify the thermodynamic database should be run by all three sets of instances.Strings with SELECTED\\_OUTPUT definitions that will be used during the time-stepping loop need tobe run by the workers. Strings that contain initial conditions or boundary conditions shouldbe run by the InitialPhreeqc instance.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Utilities::strcpy_safe(str, MAX_LENGTH, "DELETE; -all");
status = RM_RunString(id, 1, 0, 1, str);	// workers, initial_phreeqc, utility
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `workers`: 1, the workers will run the string; 0, the workers will not run the string.
* `initial_phreeqc`: 1, the InitialPhreeqc instance will run the string; 0, the InitialPhreeqc will not run the string.
* `utility`: 1, the Utility instance will run the string; 0, the Utility instance will not run the string.
* `input_string`: String containing PHREEQC input.
# See also
RM_RunFile.
"""
function RM_RunString(id, workers, initial_phreeqc, utility, input_string)
    ccall((:RM_RunString, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint, Ptr{Cchar}), id, workers, initial_phreeqc, utility, input_string)
end

"""
    RM_ScreenMessage(id, str)

Print message to the screen.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sprintf(str, "%s%10.1f%s", "Beginning transport calculation      ",
        time * RM_GetTimeConversion(id), " days\\n");
status = RM_ScreenMessage(id, str);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `str`: String to be printed.
# See also
RM_ErrorMessage, RM_LogMessage, RM_OutputMessage, RM_WarningMessage.
"""
function RM_ScreenMessage(id, str)
    ccall((:RM_ScreenMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

"""
    RM_SetComponentH2O(id, tf)

Select whether to include H2O in the component list.The concentrations of H and O must be knownaccurately (8 to 10 significant digits) for the numerical method ofPHREEQC to produce accurate pH and pe values.Because most of the H and O are in the water species,it may be more robust (require less accuracy in transport) totransport the excess H and O (the H and O not in water) and water.The default setting (*true*) is to include water, excess H, and excess O as components.A setting of *false* will include total H and total O as components.[`RM_SetComponentH2O`](@ref) must be called before RM_FindComponents.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetComponentH2O(id, 0);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance id returned from RM_Create.
* `tf`: 0, total H and O are included in the component list; 1, excess H, excess O, and waterare included in the component list.
# See also
RM_FindComponents.
"""
function RM_SetComponentH2O(id, tf)
    ccall((:RM_SetComponentH2O, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

"""
    RM_SetConcentrations(id, c)

Use the vector of concentrations (*c*) to set the moles of components in each reaction cell.The volume of water in a cell is the product of porosity (RM_SetPorosity), saturation (RM_SetSaturationUser), and reference volume (RM_SetRepresentativeVolume).The moles of each component are determined by the volume of water and per liter concentrations.If concentration units (RM_SetUnitsSolution) are mass fraction, thedensity (as specified by RM_SetDensityUser) is used to convert from mass fraction to per mass per liter.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
c = (double *) malloc((size_t) (ncomps * nxyz * sizeof(double)));
...
advect_c(c, bc_conc, ncomps, nxyz, nbound);
status = RM_SetPorsity(id, por);               // If porosity changes
status = RM_SetSaturationUser(id, sat);            // If saturation changes
status = RM_SetTemperature(id, temperature);   // If temperature changes
status = RM_SetPressure(id, pressure);         // If pressure changes
status = RM_SetConcentrations(id, c);          // Transported concentrations
status = RM_SetTimeStep(id, time_step);        // Time step for kinetic reactions
status = RM_SetTime(id, time);                 // Current time
status = RM_RunCells(id);
status = RM_GetConcentrations(id, c);          // Concentrations after reaction
status = RM_GetDensityCalculated(id, density);           // Density after reaction
status = RM_GetSolutionVolume(id, volume);     // Solution volume after reaction
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `c`: Array of component concentrations. Size of array is *nxyz* * *ncomps*,where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount), and *ncomps* is the number of components as determinedby RM_FindComponents or RM_GetComponentCount.
# See also
RM_SetDensityUser, RM_SetPorosity, RM_SetRepresentativeVolume,RM_SetSaturationUser, RM_SetUnitsSolution.
"""
function RM_SetConcentrations(id, c)
    ccall((:RM_SetConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, c)
end

"""
    RM_SetCurrentSelectedOutputUserNumber(id, n_user)

Select the current selected output by user number. The user may define multiple SELECTED\\_OUTPUTdata blocks for the workers. A user number is specified for each data block. The value ofthe argument *n_user* selects which of the SELECTED\\_OUTPUT definitions will be usedfor selected-output operations.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
{
  n_user = RM_GetNthSelectedOutputUserNumber(id, isel);
  status = RM_SetCurrentSelectedOutputUserNumber(id, n_user);
  col = RM_GetSelectedOutputColumnCount(id);
  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
  status = RM_GetSelectedOutput(id, selected_out);
  // Process results here
  free(selected_out);
}
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `n_user`: User number of the SELECTED\\_OUTPUT data block that is to be used.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetNthSelectedOutput,RM_SetSelectedOutputOn.
"""
function RM_SetCurrentSelectedOutputUserNumber(id, n_user)
    ccall((:RM_SetCurrentSelectedOutputUserNumber, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, n_user)
end

"""
    RM_SetDensityUser(id, density)

Set the density for each reaction cell. These density values are usedwhen converting from transported mass fraction concentrations (RM_SetUnitsSolution) toproduce per liter concentrations during a call to RM_SetConcentrations.They are also used when converting from module concentrations to transport concentrationsof mass fraction (RM_GetConcentrations), if RM_UseSolutionDensityVolume is set to *false*.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
density = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++)
{
	density[i] = 1.0;
}
status = RM_SetDensityUser(id, density);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `density`: Array of densities. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_GetConcentrations, RM_SetConcentrations,RM_SetUnitsSolution, RM_UseSolutionDensityVolume.
"""
function RM_SetDensityUser(id, density)
    ccall((:RM_SetDensityUser, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

"""
    RM_SetDensity(id, density)

Deprecated equivalent of [`RM_SetDensityUser`](@ref).
"""
function RM_SetDensity(id, density)
    ccall((:RM_SetDensity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

"""
    RM_SetDumpFileName(id, dump_name)

Set the name of the dump file. It is the name used by RM_DumpModule.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetDumpFileName(id, "advection_c.dmp");
dump_on = 1;
append = 0;
status = RM_DumpModule(id, dump_on, append);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `dump_name`: Name of dump file.
# See also
RM_DumpModule.
"""
function RM_SetDumpFileName(id, dump_name)
    ccall((:RM_SetDumpFileName, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, dump_name)
end

"""
    RM_SetErrorHandlerMode(id, mode)

Set the action to be taken when the reaction module encounters an error.Options are 0, return to calling program with an error return code (default);1, throw an exception, in C++, the exception can be caught, for C and Fortran, the program will exit; or2, attempt to exit gracefully.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
id = RM_Create(nxyz, nthreads);
status = RM_SetErrorHandlerMode(id, 2);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance id returned from RM_Create.
* `mode`: Error handling mode: 0, 1, or 2.
"""
function RM_SetErrorHandlerMode(id, mode)
    ccall((:RM_SetErrorHandlerMode, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, mode)
end

"""
    RM_SetErrorOn(id, tf)

Set the property that controls whether error messages are generated and displayed.Messages include PHREEQC "ERROR" messages, andany messages written with RM_ErrorMessage.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetErrorOn(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `tf`: *1*, enable error messages; *0*, disable error messages. Default is 1.
# See also
RM_ErrorMessage,RM_ScreenMessage.
"""
function RM_SetErrorOn(id, tf)
    ccall((:RM_SetErrorOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

"""
    RM_SetFilePrefix(id, prefix)

Set the prefix for the output (prefix.chem.txt) and log (prefix.log.txt) files.These files are opened by RM_OpenFiles.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetFilePrefix(id, "Advect_c");
status = RM_OpenFiles(id);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `prefix`: Prefix used when opening the output and log files.
# See also
RM_CloseFiles, RM_OpenFiles.
"""
function RM_SetFilePrefix(id, prefix)
    ccall((:RM_SetFilePrefix, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, prefix)
end

"""
    RM_SetGasCompMoles(id, gas_moles)

Transfer moles of gas components fromthe vector given in the argument list (*gas_moles*) to each reaction cell.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
ngas_comps = RM_GetGasComponentsCount();
gas_moles = (double *) malloc((size_t) (ngas_comps * nxyz * sizeof(double)));
...
status = RM_SetGasCompMoles(id, gas_moles);
status = RM_RunCells(id)
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_moles`: Vector of moles of gas components.Dimension of the vector must be *ngas_comps* times *nxyz*,where, *ngas_comps* is the result of RM_GetGasComponentsCount,and *nxyz* is the number of user grid cells (RM_GetGridCellCount).If the number of moles is set to a negative number, the gas component willnot be defined for the GAS\\_PHASE of the reaction cell.
# See also
RM_FindComponents, RM_GetGasComponentsCount, RM_GetGasCompMoles, RM_GetGasCompPressures,RM_GetGasPhaseVolume,RM_GetGasCompPhi,RM_SetGasPhaseVolume.
"""
function RM_SetGasCompMoles(id, gas_moles)
    ccall((:RM_SetGasCompMoles, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_moles)
end

"""
    RM_SetGasPhaseVolume(id, gas_volume)

Transfer volumes of gas phases fromthe array given in the argument list (*gas_volume*) to each reaction cell.The gas-phase volume affects the pressures calculated for fixed-volumegas phases. If a gas-phase volume is defined with this method for a GAS\\_PHASE in a cell, the gas phase is forced to be a fixed-volume gas phase.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
gas_volume = (double *) malloc((size_t) (nxyz * sizeof(double)));
...
status = RM_SetGasPhaseVolume(id, gas_moles);
status = RM_RunCells(id)
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `gas_volume`: Vector of volumes for each gas phase.Dimension of the vector must be *nxyz*,where, *nxyz* is the number of user grid cells (RM_GetGridCellCount).If the volume is set to a negative number for a cell, the gas-phase volume for that cell isnot changed.
# See also
RM_FindComponents,RM_GetGasComponentsCount,RM_GetGasCompMoles,RM_GetGasCompPressures,RM_GetGasPhaseVolume,RM_GetGasCompPhi,RM_SetGasCompMoles.
"""
function RM_SetGasPhaseVolume(id, gas_volume)
    ccall((:RM_SetGasPhaseVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_volume)
end

"""
    RM_SetMpiWorkerCallback(id, fcn)

MPI only. Defines a callback function that allows additional tasks to be doneby the workers. The method RM_MpiWorker contains a loop,where the workers receive a message (an integer),run a function corresponding to that integer,and then wait for another message.[`RM_SetMpiWorkerCallback`](@ref) allows the developer to add another functionthat responds to additional integer messages by calling developer-defined functionscorresponding to those integers.RM_MpiWorker calls the callback function when the message numberis not one of the PhreeqcRM message numbers.Messages are unique integer numbers. PhreeqcRM uses integers in a rangebeginning at 0. It is suggested that developers use message numbers startingat 1000 or higher for their tasks.The callback function calls a developer-defined function specifiedby the message number and then returns to RM_MpiWorker to wait foranother message.In C, an additional pointer can be supplied to find the data necessary to do the task.A void pointer may be set with RM_SetMpiWorkerCallbackCookie. This pointeris passed to the callback function through a void pointer argument in additionto the integer message argument. The void pointer may be a pointer to a struct thatcontains pointers to additional data. RM_SetMpiWorkerCallbackCookiemust be called by each worker before RM_MpiWorker is called.The motivation for this method is to allow the workers to perform othertasks, for instance, parallel transport calculations, within the structureof RM_MpiWorker. The callback functioncan be used to allow the workers to receive data, perform transport calculations,and (or) send results, without leaving the loop of RM_MpiWorker. Alternatively,it is possible for the workers to return from RM_MpiWorkerby a call to RM_MpiWorkerBreak by root. The workers could then callsubroutines to receive data, calculate transport, and send data,and then resume processing PhreeqcRM messages from root with anothercall to RM_MpiWorker.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Code executed by root:
// root calls a function that will involve the workers
status = do_something(&comm);
Code executed by workers:
status = RM_SetMpiWorkerCallback(id, worker_tasks_c);
status = RM_SetMpiWorkerCallbackCookie(id, &comm);
status = RM_MpiWorker(id);
Code executed by root and workers:
int do_something(void *cookie)
{
	MPI_Status status;
	MPI_Comm *comm = (MPI_Comm *) cookie;
	int i, method_number, mpi_myself, mpi_tasks, worker_number;
	method_number = 1000;
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_tasks);
	MPI_Comm_rank(MPI_COMM_WORLD, &mpi_myself);
	if (mpi_myself == 0)
	{
		MPI_Bcast(&method_number, 1, MPI_INT, 0, *comm);
		fprintf(stderr, "I am root.\\n");
		for (i = 1; i < mpi_tasks; i++)
		{
			MPI_Recv(&worker_number, 1, MPI_INT, i, 0, *comm, &status);
			fprintf(stderr, "Recieved data from worker number %d.\\n", worker_number);
		}
	}
	else
	{
		MPI_Send(&mpi_myself, 1, MPI_INT, 0, 0, *comm);
	}
	return 0;
}
Code called by workers from method MpiWorker:
int worker_tasks_c(int *method_number, void * cookie)
{
	if (*method_number == 1000)
	{
		do_something(cookie);
	}
	return 0;
}
</PRE>
</CODE>
```

\\par MPI:Called by workers, before call to RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `fcn`: A function that returns an integer and has an integer argument.C has an additional void * argument.
# See also
RM_MpiWorker, RM_MpiWorkerBreak,RM_SetMpiWorkerCallbackCookie.
"""
function RM_SetMpiWorkerCallback(id, fcn)
    ccall((:RM_SetMpiWorkerCallback, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cvoid}), id, fcn)
end

"""
    RM_SetMpiWorkerCallbackCookie(id, cookie)

MPI and C only. Defines a void pointer that can be used byC functions called from the callback function (RM_SetMpiWorkerCallback)to locate data for a task. The C callback functionthat is registered with RM_SetMpiWorkerCallback hastwo arguments, an integer message to identify a task, and a voidpointer. [`RM_SetMpiWorkerCallbackCookie`](@ref) sets the value of thevoid pointer that is passed to the callback function.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
Code executed by root:
// root calls a function that will involve the workers
status = do_something(&comm);
Code executed by workers:
status = RM_SetMpiWorkerCallback(id, worker_tasks_c);
status = RM_SetMpiWorkerCallbackCookie(id, &comm);
status = RM_MpiWorker(id);
Code executed by root and workers:
int do_something(void *cookie)
{
	MPI_Status status;
	MPI_Comm *comm = (MPI_Comm *) cookie;
	int i, method_number, mpi_myself, mpi_tasks, worker_number;
	method_number = 1000;
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_tasks);
	MPI_Comm_rank(MPI_COMM_WORLD, &mpi_myself);
	if (mpi_myself == 0)
	{
		MPI_Bcast(&method_number, 1, MPI_INT, 0, *comm);
		fprintf(stderr, "I am root.\\n");
		for (i = 1; i < mpi_tasks; i++)
		{
			MPI_Recv(&worker_number, 1, MPI_INT, i, 0, *comm, &status);
			fprintf(stderr, "Recieved data from worker number %d.\\n", worker_number);
		}
	}
	else
	{
		MPI_Send(&mpi_myself, 1, MPI_INT, 0, 0, *comm);
	}
	return 0;
}
Code called by workers from method MpiWorker:
int worker_tasks_c(int *method_number, void * cookie)
{
	if (*method_number == 1000)
	{
		do_something(cookie);
	}
	return 0;
}
</PRE>
</CODE>
```

\\par MPI:Called by workers, before call to RM_MpiWorker.

# Arguments
* `id`: The instance id returned from RM_Create.
* `cookie`: Void pointer that can be used by subroutines called from the callback functionto locate data needed to perform a task.
# See also
RM_MpiWorker, RM_MpiWorkerBreak,RM_SetMpiWorkerCallback.
"""
function RM_SetMpiWorkerCallbackCookie(id, cookie)
    ccall((:RM_SetMpiWorkerCallbackCookie, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cvoid}), id, cookie)
end

"""
    RM_SetNthSelectedOutput(id, n)

Specify the current selected output by sequence number. The user may define multiple SELECTED\\_OUTPUTdata blocks for the workers. A user number is specified for each data block, and the blocks arestored in user-number order. The value ofthe argument *n* selects the sequence number of the SELECTED\\_OUTPUT definition that will be usedfor selected-output operations.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
	<CODE>
	<PRE>
	for (isel = 0; isel < RM_GetSelectedOutputCount(id); isel++)
	{
	  status = RM_SetNthSelectedOutputUser(id, isel);
	  n_user = RM_GetCurrentSelectedOutputUserNumber(id);
	  col = RM_GetSelectedOutputColumnCount(id);
	  selected_out = (double *) malloc((size_t) (col * nxyz * sizeof(double)));
	  status = RM_GetSelectedOutput(id, selected_out);
	  // Process results here
	  free(selected_out);
	}
	</PRE>
	</CODE>
```

\\par MPI:	Called by root.

# Arguments
* `id`: The instance id returned from RM_Create.
* `n`: Sequence number of the SELECTED\\_OUTPUT data block that is to be used.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetSelectedOutputOn.
"""
function RM_SetNthSelectedOutput(id, n)
    ccall((:RM_SetNthSelectedOutput, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, n)
end

"""
    RM_SetPartitionUZSolids(id, tf)

Sets the property for partitioning solids between the saturated and unsaturatedparts of a partially saturated cell.

The option is intended to be used by saturated-onlyflow codes that allow a variable water table.The value has meaning only when saturationsless than 1.0 are encountered. The partially saturated cellsmay have a small water-to-rock ratio that causesreactions to proceed differently relative to fully saturated cells.By setting [`RM_SetPartitionUZSolids`](@ref) to true, theamounts of solids and gases are partioned according to the saturation.If a cell has a saturation of 0.5, thenthe water interacts with only half of the solids and gases; the other half is unreactiveuntil the water table rises. As the saturation in a cell varies,solids and gases are transferred between thesaturated and unsaturated (unreactive) reservoirs of the cell.Unsaturated-zone flow and transport codes will probably use the default (false),which assumes all gases and solids are reactive regardless of saturation.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetPartitionUZSolids(id, 0);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `tf`: *True*, the fraction of solids and gases available forreaction is equal to the saturation;*False* (default), all solids and gases are reactive regardless of saturation.
"""
function RM_SetPartitionUZSolids(id, tf)
    ccall((:RM_SetPartitionUZSolids, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

"""
    RM_SetPorosity(id, por)

Set the porosity for each reaction cell.The volume of water in a reaction cell is the product of the porosity, the saturation(RM_SetSaturationUser), and the representative volume (RM_SetRepresentativeVolume).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
por = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++) por[i] = 0.2;
status = RM_SetPorosity(id, por);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `por`: Array of porosities, unitless. Default is 0.1. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_GetSaturationCalculated, RM_SetRepresentativeVolume, RM_SetSaturationUser.
"""
function RM_SetPorosity(id, por)
    ccall((:RM_SetPorosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, por)
end

"""
    RM_SetPressure(id, p)

Set the pressure for each reaction cell. Pressure effects are considered only in three of thedatabases distributed with PhreeqcRM: phreeqc.dat, Amm.dat, and pitzer.dat.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
pressure = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++) pressure[i] = 2.0;
status = RM_SetPressure(id, pressure);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `p`: Array of pressures, in atm. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_SetTemperature.
"""
function RM_SetPressure(id, p)
    ccall((:RM_SetPressure, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, p)
end

"""
    RM_SetPrintChemistryMask(id, cell_mask)

Enable or disable detailed output for each reaction cell.Printing for a cell will occur only when theprinting is enabled with RM_SetPrintChemistryOn and the *cell_mask* value is 1.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
print_chemistry_mask = (int *) malloc((size_t) (nxyz * sizeof(int)));
for (i = 0; i < nxyz/2; i++)
{
  print_chemistry_mask[i] = 1;
  print_chemistry_mask[i + nxyz/2] = 0;
}
status = RM_SetPrintChemistryMask(id, print_chemistry_mask);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `cell_mask`: Array of integers. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount). A value of 0 willdisable printing detailed output for the cell; a value of 1 will enable printing detailed output for a cell.
# See also
RM_SetPrintChemistryOn.
"""
function RM_SetPrintChemistryMask(id, cell_mask)
    ccall((:RM_SetPrintChemistryMask, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, cell_mask)
end

"""
    RM_SetPrintChemistryOn(id, workers, initial_phreeqc, utility)

Setting to enable or disable printing detailed output from reaction calculations to the output file for a set ofcells defined by RM_SetPrintChemistryMask. The detailed output prints all of the outputtypical of a PHREEQC reaction calculation, which includes solution descriptions and the compositions ofall other reactants. The output can be several hundred lines per cell, which can lead to a verylarge output file (prefix.chem.txt, RM_OpenFiles). For the worker instances, the output can be limited to a set of cells(RM_SetPrintChemistryMask) and, in general, theamount of information printed can be limited by use of options in the PRINT data block of PHREEQC(applied by using RM_RunFile or RM_RunString).Printing the detailed output for the workers is generally used only for debugging, and PhreeqcRM will runsignificantly faster when printing detailed output for the workers is disabled.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetPrintChemistryOn(id, 0, 1, 0); // workers, initial_phreeqc, utility
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `workers`: 0, disable detailed printing in the worker instances, 1, enable detailed printingin the worker instances.
* `initial_phreeqc`: 0, disable detailed printing in the InitialPhreeqc instance, 1, enable detailed printingin the InitialPhreeqc instances.
* `utility`: 0, disable detailed printing in the Utility instance, 1, enable detailed printingin the Utility instance.
# See also
RM_SetPrintChemistryMask.
"""
function RM_SetPrintChemistryOn(id, workers, initial_phreeqc, utility)
    ccall((:RM_SetPrintChemistryOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint), id, workers, initial_phreeqc, utility)
end

"""
    RM_SetRebalanceByCell(id, method)

Set the load-balancing algorithm.PhreeqcRM attempts to rebalance the load of each thread or process such that eachthread or process takes the same amount of time to run its part of a RM_RunCellscalculation. Two algorithms are available; one uses individual times for each cell andaccounts for cells that were not run becausesaturation was zero (default), andthe other assigns an average time to all cells.The methods are similar, but limited testing indicates the default method performs better.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetRebalanceByCell(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `method`: 0, indicates average times are used in rebalancing; 1 indicates individualcell times are used in rebalancing (default).
# See also
RM_SetRebalanceFraction.
"""
function RM_SetRebalanceByCell(id, method)
    ccall((:RM_SetRebalanceByCell, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, method)
end

"""
    RM_SetRebalanceFraction(id, f)

Sets the fraction of cells that are transferred among threads or processes when rebalancing.PhreeqcRM attempts to rebalance the load of each thread or process such that eachthread or process takes the same amount of time to run its part of a RM_RunCellscalculation. The rebalancing transfers cell calculations among threads or processes totry to achieve an optimum balance. *RM_SetRebalanceFractionadjusts* the calculated optimum number of cell transfers by a fraction from 0 to 1.0 todetermine the actual number of cell transfers. A value of zero eliminatesload rebalancing. A value less than 1.0 is suggested to slow the approach to the optimum celldistribution and avoid possible oscillationswhen too many cells are transferred at one iteration, requiring reverse transfers at the next iteration.Default is 0.5.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetRebalanceFraction(id, 0.5);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `f`: Fraction from 0.0 to 1.0.
# See also
RM_SetRebalanceByCell.
"""
function RM_SetRebalanceFraction(id, f)
    ccall((:RM_SetRebalanceFraction, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, f)
end

"""
    RM_SetRepresentativeVolume(id, rv)

Set the representative volume of each reaction cell.By default the representative volume of each reaction cell is 1 liter.The volume of water in a reaction cell is determined by the procuct of the representative volume,the porosity (RM_SetPorosity), and the saturation (RM_SetSaturationUser).The numerical method of PHREEQC is more robust if the water volume for a reaction cell iswithin a couple orders of magnitude of 1.0.Small water volumes caused by small porosities and (or) small saturations (and (or) small representative volumes)may cause non-convergence of the numerical method.In these cases, a larger representative volume may help. Notethat increasing the representative volume also increasesthe number of moles of the reactants in the reaction cell (minerals, surfaces, exchangers,and others), which are defined as moles per representative volume.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
double * rv;
rv = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++) rv[i] = 1.0;
status = RM_SetRepresentativeVolume(id, rv);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `rv`: Vector of representative volumes, in liters. Default is 1.0 liter.Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_SetPorosity, RM_SetSaturationUser.
"""
function RM_SetRepresentativeVolume(id, rv)
    ccall((:RM_SetRepresentativeVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, rv)
end

"""
    RM_SetSaturationUser(id, sat)

Set the saturation of each reaction cell. Saturation is a fraction ranging from 0 to 1.The volume of water in a cell is the product of porosity (RM_SetPorosity), saturation ([`RM_SetSaturationUser`](@ref)),and representative volume (RM_SetRepresentativeVolume). As a result of a reaction calculation, solution properties (density and volume) will change; the databases phreeqc.dat, Amm.dat, and pitzer.dat have the molar volume data to calculate these changes. The methods RM_GetDensityCalculated, RM_GetSolutionVolume, and RM_GetSaturationCalculatedcan be used to account for these changes in the succeeding transport calculation.[`RM_SetRepresentativeVolume`](@ref) should be called before initial conditions are defined for the reaction cells.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
sat = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++) sat[i] = 1.0;
status = RM_SetSaturationUser(id, sat);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `sat`: Array of saturations, unitless. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_GetDensityCalculated, RM_GetSaturationCalculated, RM_GetSolutionVolume,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetSaturationUser(id, sat)
    ccall((:RM_SetSaturationUser, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat)
end

"""
    RM_SetSaturation(id, sat)

Deprecated equivalent of [`RM_SetSaturationUser`](@ref).
"""
function RM_SetSaturation(id, sat)
    ccall((:RM_SetSaturation, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat)
end

"""
    RM_SetScreenOn(id, tf)

Set the property that controls whether messages are written to the screen.Messages include information about rebalancing during RM_RunCells, andany messages written with RM_ScreenMessage.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetScreenOn(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `tf`: *1*, enable screen messages; *0*, disable screen messages. Default is 1.
# See also
RM_RunCells, RM_ScreenMessage.
"""
function RM_SetScreenOn(id, tf)
    ccall((:RM_SetScreenOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

"""
    RM_SetSelectedOutputOn(id, selected_output)

Setting determines whether selected-output results are available to be retrievedwith RM_GetSelectedOutput. *1* indicates that selected-output resultswill be accumulated during RM_RunCells and can be retrieved with RM_GetSelectedOutput;*0* indicates that selected-output results will notbe accumulated during RM_RunCells.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSelectedOutputOn(id, 1);       // enable selected output
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `selected_output`: 0, disable selected output; 1, enable selected output.
# See also
RM_GetCurrentSelectedOutputUserNumber,RM_GetNthSelectedOutputUserNumber,RM_GetSelectedOutput,RM_GetSelectedOutputColumnCount,RM_GetSelectedOutputCount,RM_GetSelectedOutputHeading,RM_GetSelectedOutputRowCount,RM_SetCurrentSelectedOutputUserNumber,RM_SetNthSelectedOutput.
"""
function RM_SetSelectedOutputOn(id, selected_output)
    ccall((:RM_SetSelectedOutputOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, selected_output)
end

"""
    RM_SetSpeciesSaveOn(id, save_on)

Sets the value of the species-save property.This method enables use of PhreeqcRM with multicomponent-diffusion transport calculations.By default, concentrations of aqueous species are not saved. Setting the species-save property to 1 allowsaqueous species concentrations to be retrievedwith RM_GetSpeciesConcentrations, and solution compositions to be set withRM_SpeciesConcentrations2Module.RM_SetSpeciesSaveOn must be called before calls to RM_FindComponents.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `save_on`: 0, indicates species concentrations are not saved; 1, indicates species concentrations aresaved.
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName,RM_GetSpeciesSaveOn, RM_GetSpeciesZ, RM_SpeciesConcentrations2Module.
"""
function RM_SetSpeciesSaveOn(id, save_on)
    ccall((:RM_SetSpeciesSaveOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, save_on)
end

"""
    RM_SetTemperature(id, t)

Set the temperature for each reaction cell. If [`RM_SetTemperature`](@ref) is not called,worker solutions will have temperatures as defined by initial conditions(RM_InitialPhreeqc2Module and RM_InitialPhreeqcCell2Module).

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
temperature = (double *) malloc((size_t) (nxyz * sizeof(double)));
for (i = 0; i < nxyz; i++)
{
  temperature[i] = 20.0;
}
status = RM_SetTemperature(id, temperature);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `t`: Array of temperatures, in degrees C. Size of array is *nxyz*, where *nxyz* is the numberof grid cells in the user's model (RM_GetGridCellCount).
# See also
RM_InitialPhreeqc2Module,RM_InitialPhreeqcCell2Module, RM_SetPressure.
"""
function RM_SetTemperature(id, t)
    ccall((:RM_SetTemperature, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, t)
end

"""
    RM_SetTime(id, time)

Set current simulation time for the reaction module.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetTime(id, time);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `time`: Current simulation time, in seconds.
# See also
RM_SetTimeConversion, RM_SetTimeStep.
"""
function RM_SetTime(id, time)
    ccall((:RM_SetTime, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, time)
end

"""
    RM_SetTimeConversion(id, conv_factor)

Set a factor to convert to user time units. Factor times seconds produces user time units.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetTimeConversion(id, 1.0 / 86400.0); // days
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `conv_factor`: Factor to convert seconds to user time units.
# See also
RM_SetTime, RM_SetTimeStep.
"""
function RM_SetTimeConversion(id, conv_factor)
    ccall((:RM_SetTimeConversion, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, conv_factor)
end

"""
    RM_SetTimeStep(id, time_step)

Set current time step for the reaction module. This is the lengthof time over which kinetic reactions are integrated.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
time_step = 86400.0;
status = RM_SetTimeStep(id, time_step);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `time_step`: Current time step, in seconds.
# See also
RM_SetTime, RM_SetTimeConversion.
"""
function RM_SetTimeStep(id, time_step)
    ccall((:RM_SetTimeStep, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, time_step)
end

"""
    RM_SetUnitsExchange(id, option)

Sets input units for exchangers.In PHREEQC input, exchangers are defined by moles of exchange sites (*Mp*).[`RM_SetUnitsExchange`](@ref) specifies how the number of moles of exchange sites in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-P)*RV.

If a single EXCHANGE definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of exchangers will be the same regardless of porosity. For option 1, the number of moles of exchangers will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of exchangers will vary directly with rock volume and inversely with porosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsExchange(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for exchangers: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetUnitsExchange(id, option)
    ccall((:RM_SetUnitsExchange, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsGasPhase(id, option)

Set input units for gas phases.In PHREEQC input, gas phases are defined by moles of component gases (*Mp*).[`RM_SetUnitsGasPhase`](@ref) specifies how the number of moles of component gases in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-*P*)*RV.

If a single GAS\\_PHASE definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of a gas component will be the same regardless of porosity. For option 1, the number of moles of a gas component will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of a gas component will vary directly with rock volume and inversely with porosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsGasPhase(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for gas phases: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetUnitsGasPhase(id, option)
    ccall((:RM_SetUnitsGasPhase, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsKinetics(id, option)

Set input units for kinetic reactants.

In PHREEQC input, kinetics are defined by moles of kinetic reactants (*Mp*).[`RM_SetUnitsKinetics`](@ref) specifies how the number of moles of kinetic reactants in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-*P*)*RV.

If a single KINETICS definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of kinetic reactants will be the same regardless of porosity. For option 1, the number of moles of kinetic reactants will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of kinetic reactants will vary directly with rock volume and inversely with porosity.

Note that the volume of water in a cell in the reaction module is equal to the product ofporosity (RM_SetPorosity), the saturation (RM_SetSaturationUser), and representative volume (RM_SetRepresentativeVolume), which is usually less than 1 liter. It is important to write the RATESdefinitions for homogeneous (aqueous) kinetic reactions to account for the current volume ofwater, often by calculating the rate of reaction per liter of water and multiplying by the volumeof water (Basic function SOLN\\_VOL).

Rates that depend on surface area of solids, are not dependenton the volume of water. However, it is important to get the correct surface area for the kineticreaction. To scale the surface area with the number of moles, the specific area (m^2 per mole of reactant) can be defined as a parameter (KINETICS; -parm), which is multiplied by the number of moles of reactant (Basic function M) in RATES to obtain the surface area.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsKinetics(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for kinetic reactants: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume, RM_SetSaturationUser.
"""
function RM_SetUnitsKinetics(id, option)
    ccall((:RM_SetUnitsKinetics, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsPPassemblage(id, option)

Set input units for pure phase assemblages (equilibrium phases).In PHREEQC input, equilibrium phases are defined by moles of each phase (*Mp*).[`RM_SetUnitsPPassemblage`](@ref) specifies how the number of moles of phases in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-*P*)*RV.

If a single EQUILIBRIUM\\_PHASES definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of a mineral will be the same regardless of porosity. For option 1, the number of moles of a mineral will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of a mineral will vary directly with rock volume and inversely with porosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsPPassemblage(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for equilibrium phases: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetUnitsPPassemblage(id, option)
    ccall((:RM_SetUnitsPPassemblage, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsSolution(id, option)

Solution concentration units used by the transport model.Options are 1, mg/L; 2 mol/L; or 3, mass fraction, kg/kgs.PHREEQC defines solutions by the number of moles of eachelement in the solution.

To convert from mg/L to molesof element in the representative volume of a reaction cell, mg/L is converted to mol/L andmultiplied by the solution volume,which is the product of porosity (RM_SetPorosity), saturation (RM_SetSaturationUser),and representative volume (RM_SetRepresentativeVolume).To convert from mol/L to molesof element in the representative volume of a reaction cell, mol/L ismultiplied by the solution volume.To convert from mass fraction to molesof element in the representative volume of a reaction cell, kg/kgs is converted to mol/kgs, multiplied by density(RM_SetDensityUser) andmultiplied by the solution volume.

To convert from molesof element in the representative volume of a reaction cell to mg/L, the number of moles of an element is divided by thesolution volume resulting in mol/L, and then converted to mg/L.To convert from molesof element in a cell to mol/L, the number of moles of an element is divided by thesolution volume resulting in mol/L.To convert from molesof element in a cell to mass fraction, the number of moles of an element is converted to kg and dividedby the total mass of the solution.Two options are available for the volume and mass of solutionthat are used in converting to transport concentrations: (1) the volume and mass of solution arecalculated by PHREEQC, or (2) the volume of solution is the product of porosity (RM_SetPorosity),saturation (RM_SetSaturationUser), and representative volume (RM_SetRepresentativeVolume),and the mass of solution is volume times density as defined by RM_SetDensityUser.Which option is used is determined by RM_UseSolutionDensityVolume.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsSolution(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for solutions: 1, 2, or 3, default is 1, mg/L.
# See also
RM_SetDensityUser, RM_SetPorosity, RM_SetRepresentativeVolume, RM_SetSaturationUser,RM_UseSolutionDensityVolume.
"""
function RM_SetUnitsSolution(id, option)
    ccall((:RM_SetUnitsSolution, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsSSassemblage(id, option)

Set input units for solid-solution assemblages.In PHREEQC, solid solutions are defined by moles of each component (*Mp*).[`RM_SetUnitsSSassemblage`](@ref) specifies how the number of moles of solid-solution components in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-*P*)*RV.

If a single SOLID\\_SOLUTION definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of a solid-solution component will be the same regardless of porosity. For option 1, the number of moles of a solid-solution component will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of a solid-solution component will vary directly with rock volume and inversely with porosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsSSassemblage(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for solid solutions: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetUnitsSSassemblage(id, option)
    ccall((:RM_SetUnitsSSassemblage, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SetUnitsSurface(id, option)

Set input units for surfaces.In PHREEQC input, surfaces are defined by moles of surface sites (*Mp*).[`RM_SetUnitsSurface`](@ref) specifies how the number of moles of surface sites in a reaction cell (*Mc*)is calculated from the input value (*Mp*).

Options are0, *Mp* is mol/L of RV (default), *Mc* = *Mp**RV, where RV is the representative volume (RM_SetRepresentativeVolume);1, *Mp* is mol/L of water in the RV, *Mc* = *Mp**P*RV, where *P* is porosity (RM_SetPorosity); or2, *Mp* is mol/L of rock in the RV, *Mc* = *Mp**(1-*P*)*RV.

If a single SURFACE definition is used for cells with different initial porosity,  the three options scale quite differently. For option 0, the number of moles of surface sites will be the same regardless of porosity. For option 1, the number of moles of surface sites will be vary directly with porosity and inversely with rock volume. For option 2, the number of moles of surface sites will vary directly with rock volume and inversely with porosity.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetUnitsSurface(id, 1);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `option`: Units option for surfaces: 0, 1, or 2.
# See also
RM_InitialPhreeqc2Module, RM_InitialPhreeqcCell2Module,RM_SetPorosity, RM_SetRepresentativeVolume.
"""
function RM_SetUnitsSurface(id, option)
    ccall((:RM_SetUnitsSurface, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

"""
    RM_SpeciesConcentrations2Module(id, species_conc)

Set solution concentrations in the reaction cellsbased on the vector of aqueous species concentrations (*species_conc*).This method is intended for use with multicomponent-diffusion transport calculations,and RM_SetSpeciesSaveOn must be set to *true*.The list of aqueous species is determined by RM_FindComponents and includes allaqueous species that can be made from the set of components.The method determines the total concentration of a componentby summing the molarities of the individual species times the stoichiometriccoefficient of the element in each species.Solution compositions in the reaction cells are updated with these component concentrations.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_SetSpeciesSaveOn(id, 1);
ncomps = RM_FindComponents(id);
nspecies = RM_GetSpeciesCount(id);
nxyz = RM_GetGridCellCount(id);
species_c = (double *) malloc((size_t) (nxyz * nspecies * sizeof(double)));
...
status = RM_SpeciesConcentrations2Module(id, species_c);
status = RM_RunCells(id);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `species_conc`: Array of aqueous species concentrations. Dimension of the array is (*nxyz*, *nspecies*),where *nxyz* is the number of user grid cells (RM_GetGridCellCount), and *nspecies* is the number of aqueous species (RM_GetSpeciesCount).Concentrations are moles per liter.
# See also
RM_FindComponents, RM_GetSpeciesConcentrations, RM_GetSpeciesCount,RM_GetSpeciesD25, RM_GetSpeciesLog10Gammas,RM_GetSpeciesLog10Molalities,RM_GetSpeciesName, RM_GetSpeciesSaveOn,RM_GetSpeciesZ, RM_SetSpeciesSaveOn.
"""
function RM_SpeciesConcentrations2Module(id, species_conc)
    ccall((:RM_SpeciesConcentrations2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_conc)
end

"""
    RM_StateSave(id, istate)

Save the state of the chemistry in all model cells, including SOLUTIONs,EQUILIBRIUM\\_PHASES, EXCHANGEs, GAS\\_PHASEs, KINETICS, SOLID\\_SOLUTIONs, and SURFACEs.Although not generally used, MIXes, REACTIONs, REACTION\\_PRESSUREs, and REACTION\\_TEMPERATUREswill be saved for each cell, if they have been defined in the worker IPhreeqc instances.The distribution of cells among the workersand the chemistry of fully or partiallyunsaturated cells are also saved.The state is saved in memory; use RM_DumpModule to save the stateto file.PhreeqcRM can be reset to this state by using RM_StateApply.A state is identified by an integer, and multiple states can be saved.

\\retvalIRM_RESULT 0 is success, negative is failure(See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_StateSave(id, 1);
...
status = RM_StateApply(id, 1);
status = RM_StateDelete(id, 1);
</PRE>
</CODE>
```

\\par MPI :Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `istate`: Integer identifying the state that is saved.
# See also
RM_DumpModule,RM_StateApply, andRM_StateDelete.
"""
function RM_StateSave(id, istate)
    ccall((:RM_StateSave, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

"""
    RM_StateApply(id, istate)

Reset the state of the module to a state previously saved with RM_StateSave.The chemistry of all model cells are reset, including SOLUTIONs,EQUILIBRIUM\\_PHASES, EXCHANGEs, GAS\\_PHASEs, KINETICS, SOLID\\_SOLUTIONs, and SURFACEs.MIXes, REACTIONs, REACTION\\_PRESSUREs, and REACTION\\_TEMPERATUREswill be reset for each cell, if they were defined in the worker IPhreeqc instancesat the time the state was saved.The distribution of cells among the workersand the chemistry of fully or partiallyunsaturated cells are also reset to the saved state.The state to be applied is identified by an integer.

\\retvalIRM_RESULT 0 is success, negative is failure(See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_StateSave(id, 1);
...
status = RM_StateApply(id, 1);
status = RM_StateDelete(id, 1);
</PRE>
</CODE>
```

\\par MPI :Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `istate`: Integer identifying the state that is to be applied.
# See also
RM_StateSave andRM_StateDelete.
"""
function RM_StateApply(id, istate)
    ccall((:RM_StateApply, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

"""
    RM_StateDelete(id, istate)

Delete a state previously saved with RM_StateSave.

\\retvalIRM_RESULT 0 is success, negative is failure(See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_StateSave(id, 1);
...
status = RM_StateApply(id, 1);
status = RM_StateDelete(id, 1);
</PRE>
</CODE>
```

\\par MPI :Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `istate`: Integer identifying the state that is to be deleted.
# See also
RM_StateSave andref [`RM_StateApply`](@ref).
"""
function RM_StateDelete(id, istate)
    ccall((:RM_StateDelete, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

"""
    RM_UseSolutionDensityVolume(id, tf)

Determines the volume and density to use when converting from the reaction-module concentrationsto transport concentrations (RM_GetConcentrations).Two options are available to convert concentration units:(1) the density and solution volume calculated by PHREEQC are used, or(2) the specified density (RM_SetDensityUser)and solution volume are defined by the product ofsaturation (RM_SetSaturationUser), porosity (RM_SetPorosity),and representative volume (RM_SetRepresentativeVolume).Transport models that consider density-dependent flow will probably use thePHREEQC-calculated density and solution volume (default),whereas transport models that assume constant-density flow will probably usespecified values of density and solution volume.Only the following databases distributed with PhreeqcRM have molar volume informationneeded to accurately calculate density and solution volume: phreeqc.dat, Amm.dat, and pitzer.dat.Density is only used when converting to transport units of mass fraction.

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_UseSolutionDensityVolume(id, 0);
</PRE>
</CODE>
```

\\par MPI:Called by root, workers must be in the loop of RM_MpiWorker.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `tf`: *True* indicates that the solution density and volume ascalculated by PHREEQC will be used to calculate concentrations.*False* indicates that the solution density set by RM_SetDensityUser and the volume determined by theproduct of RM_SetSaturationUser, RM_SetPorosity, and RM_SetRepresentativeVolume,will be used to calculate concentrations retrieved by RM_GetConcentrations.
# See also
RM_GetConcentrations, RM_SetDensityUser,RM_SetPorosity, RM_SetRepresentativeVolume, RM_SetSaturationUser.
"""
function RM_UseSolutionDensityVolume(id, tf)
    ccall((:RM_UseSolutionDensityVolume, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

"""
    RM_WarningMessage(id, warn_str)

Print a warning message to the screen and the log file.

\\retvalIRM_RESULT 0 is success, negative is failure (See RM_DecodeError).

\\par C Example:

```c++
<CODE>
<PRE>
status = RM_WarningMessage(id, "Parameter is out of range, using default");
</PRE>
</CODE>
```

\\par MPI:Called by root and (or) workers; only root writes to the log file.

# Arguments
* `id`: The instance *id* returned from RM_Create.
* `warn_str`: String to be printed.
# See also
RM_ErrorMessage, RM_LogMessage, RM_OpenFiles, RM_OutputMessage, RM_ScreenMessage.
"""
function RM_WarningMessage(id, warn_str)
    ccall((:RM_WarningMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, warn_str)
end

"""
    VAR_TYPE

Enumeration used to determine the type of data stored in a [`VAR`](@ref).
"""
@cenum VAR_TYPE::UInt32 begin
    TT_EMPTY = 0
    TT_ERROR = 1
    TT_LONG = 2
    TT_DOUBLE = 3
    TT_STRING = 4
end

"""
    VRESULT

Enumeration used to return error codes.
"""
@cenum VRESULT::Int32 begin
    VR_OK = 0
    VR_OUTOFMEMORY = -1
    VR_BADVARTYPE = -2
    VR_INVALIDARG = -3
    VR_INVALIDROW = -4
    VR_INVALIDCOL = -5
end

"""
    VAR

Datatype used to store SELECTED\\_OUTPUT values.
"""
struct VAR
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{VAR}, f::Symbol)
    f === :type && return Ptr{VAR_TYPE}(x + 0)
    f === :lVal && return Ptr{Clong}(x + 8)
    f === :dVal && return Ptr{Cdouble}(x + 8)
    f === :sVal && return Ptr{Ptr{Cchar}}(x + 8)
    f === :vresult && return Ptr{VRESULT}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::VAR, f::Symbol)
    r = Ref{VAR}(x)
    ptr = Base.unsafe_convert(Ptr{VAR}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{VAR}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

function VarAllocString(pSrc)
    ccall((:VarAllocString, libPhreeqcRM), Ptr{Cint}, (Ptr{Cchar},), pSrc)
end

function VarFreeString(pSrc)
    ccall((:VarFreeString, libPhreeqcRM), Cint, (Ptr{Cchar},), pSrc)
end

function VarInit(pvar)
    ccall((:VarInit, libPhreeqcRM), Cint, (Ptr{VAR},), pvar)
end

"""
    IPQ_RESULT

Enumeration used to return error codes.
"""
@cenum IPQ_RESULT::Int32 begin
    IPQ_OK = 0
    IPQ_OUTOFMEMORY = -1
    IPQ_BADVARTYPE = -2
    IPQ_INVALIDARG = -3
    IPQ_INVALIDROW = -4
    IPQ_INVALIDCOL = -5
    IPQ_BADINSTANCE = -6
end

function AddError(id, error_msg)
    ccall((:AddError, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, error_msg)
end

function AddWarning(id, warn_msg)
    ccall((:AddWarning, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, warn_msg)
end

function CreateIPhreeqc()
    ccall((:CreateIPhreeqc, libPhreeqcRM), Cint, ())
end

function GetComponent(id, n)
    ccall((:GetComponent, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetComponentCount(id)
    ccall((:GetComponentCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetCurrentSelectedOutputUserNumber(id)
    ccall((:GetCurrentSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint,), id)
end

function GetDumpFileName(id)
    ccall((:GetDumpFileName, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetDumpFileOn(id)
    ccall((:GetDumpFileOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetDumpString(id)
    ccall((:GetDumpString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetDumpStringLine(id, n)
    ccall((:GetDumpStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetDumpStringLineCount(id)
    ccall((:GetDumpStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetDumpStringOn(id)
    ccall((:GetDumpStringOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetErrorFileName(id)
    ccall((:GetErrorFileName, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetErrorFileOn(id)
    ccall((:GetErrorFileOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetErrorOn(id)
    ccall((:GetErrorOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetErrorString(id)
    ccall((:GetErrorString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetErrorStringLine(id, n)
    ccall((:GetErrorStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetErrorStringLineCount(id)
    ccall((:GetErrorStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetErrorStringOn(id)
    ccall((:GetErrorStringOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetLogFileName(id)
    ccall((:GetLogFileName, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetLogFileOn(id)
    ccall((:GetLogFileOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetLogString(id)
    ccall((:GetLogString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetLogStringLine(id, n)
    ccall((:GetLogStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetLogStringLineCount(id)
    ccall((:GetLogStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetLogStringOn(id)
    ccall((:GetLogStringOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetNthSelectedOutputUserNumber(id, n)
    ccall((:GetNthSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint, Cint), id, n)
end

function GetOutputFileName(id)
    ccall((:GetOutputFileName, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetOutputFileOn(id)
    ccall((:GetOutputFileOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetOutputString(id)
    ccall((:GetOutputString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetOutputStringLine(id, n)
    ccall((:GetOutputStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetOutputStringLineCount(id)
    ccall((:GetOutputStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetOutputStringOn(id)
    ccall((:GetOutputStringOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputColumnCount(id)
    ccall((:GetSelectedOutputColumnCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputCount(id)
    ccall((:GetSelectedOutputCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputFileName(id)
    ccall((:GetSelectedOutputFileName, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetSelectedOutputFileOn(id)
    ccall((:GetSelectedOutputFileOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputRowCount(id)
    ccall((:GetSelectedOutputRowCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputString(id)
    ccall((:GetSelectedOutputString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetSelectedOutputStringLine(id, n)
    ccall((:GetSelectedOutputStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetSelectedOutputStringLineCount(id)
    ccall((:GetSelectedOutputStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function GetSelectedOutputStringOn(id)
    ccall((:GetSelectedOutputStringOn, libPhreeqcRM), Cint, (Cint,), id)
end

function GetVersionString()
    ccall((:GetVersionString, libPhreeqcRM), Ptr{Cint}, ())
end

function GetWarningString(id)
    ccall((:GetWarningString, libPhreeqcRM), Ptr{Cint}, (Cint,), id)
end

function GetWarningStringLine(id, n)
    ccall((:GetWarningStringLine, libPhreeqcRM), Ptr{Cint}, (Cint, Cint), id, n)
end

function GetWarningStringLineCount(id)
    ccall((:GetWarningStringLineCount, libPhreeqcRM), Cint, (Cint,), id)
end

function LoadDatabase(id, filename)
    ccall((:LoadDatabase, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, filename)
end

function LoadDatabaseString(id, input)
    ccall((:LoadDatabaseString, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, input)
end

function OutputAccumulatedLines(id)
    ccall((:OutputAccumulatedLines, libPhreeqcRM), Cint, (Cint,), id)
end

function OutputErrorString(id)
    ccall((:OutputErrorString, libPhreeqcRM), Cint, (Cint,), id)
end

function OutputWarningString(id)
    ccall((:OutputWarningString, libPhreeqcRM), Cint, (Cint,), id)
end

function RunAccumulated(id)
    ccall((:RunAccumulated, libPhreeqcRM), Cint, (Cint,), id)
end

function RunFile(id, filename)
    ccall((:RunFile, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, filename)
end

function RunString(id, input)
    ccall((:RunString, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, input)
end

# Skipping MacroDefinition: IRM_DLL_EXPORT __attribute__ ( ( visibility ( "default" ) ) )

#
# START OF EPILOGUE
#


#
# END OF EPILOGUE
#

# exports
const PREFIXES = ["CX", "clang_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
