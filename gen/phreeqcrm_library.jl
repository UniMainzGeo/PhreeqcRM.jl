module LibPhreeqcRM

using PhreeqcRM_jll
export PhreeqcRM_jll

using CEnum

#
# START OF PROLOGUE
#
using MAGEMin_C, PhreeqcRM_jll
const HASH_JEN = 0;


function __init__()
    global libPhreeqcRM = PhreeqcRM_jll.libPhreeqcRM
    println("Using libPhreeqcRM.dylib from PhreeqcRM_jll")
end

#
# END OF PROLOGUE
#

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

function RM_BmiCreate(nxyz, nthreads)
    ccall((:RM_BmiCreate, libPhreeqcRM), Cint, (Cint, Cint), nxyz, nthreads)
end

function RM_BmiDestroy(id)
    ccall((:RM_BmiDestroy, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_BmiAddOutputVars(id, option, def)
    ccall((:RM_BmiAddOutputVars, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}), id, option, def)
end

function RM_BmiFinalize(id)
    ccall((:RM_BmiFinalize, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_BmiGetComponentName(id, component_name, l)
    ccall((:RM_BmiGetComponentName, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, component_name, l)
end

function RM_BmiGetCurrentTime(id)
    ccall((:RM_BmiGetCurrentTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_BmiGetEndTime(id)
    ccall((:RM_BmiGetEndTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_BmiGetGridRank(id, grid)
    ccall((:RM_BmiGetGridRank, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

function RM_BmiGetGridSize(id, grid)
    ccall((:RM_BmiGetGridSize, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

function RM_BmiGetGridType(id, grid, str, l)
    ccall((:RM_BmiGetGridType, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, grid, str, l)
end

function RM_BmiGetInputItemCount(id)
    ccall((:RM_BmiGetInputItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_BmiGetInputVarName(id, i, name, l)
    ccall((:RM_BmiGetInputVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

function RM_BmiGetOutputItemCount(id)
    ccall((:RM_BmiGetOutputItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_BmiGetOutputVarName(id, i, name, l)
    ccall((:RM_BmiGetOutputVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

function RM_BmiGetPointableItemCount(id)
    ccall((:RM_BmiGetPointableItemCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_BmiGetPointableVarName(id, i, name, l)
    ccall((:RM_BmiGetPointableVarName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, l)
end

function RM_BmiGetStartTime(id)
    ccall((:RM_BmiGetStartTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_BmiGetTime(id)
    ccall((:RM_BmiGetTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_BmiGetTimeStep(id)
    ccall((:RM_BmiGetTimeStep, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_BmiGetTimeUnits(id, units, l)
    ccall((:RM_BmiGetTimeUnits, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, units, l)
end

function RM_BmiGetValueInt(id, var, dest)
    ccall((:RM_BmiGetValueInt, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cint}), id, var, dest)
end

function RM_BmiGetValueDouble(id, var, dest)
    ccall((:RM_BmiGetValueDouble, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cdouble}), id, var, dest)
end

function RM_BmiGetValueChar(id, var, dest, l)
    ccall((:RM_BmiGetValueChar, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, var, dest, l)
end

function RM_BmiGetValuePtr(id, var)
    ccall((:RM_BmiGetValuePtr, libPhreeqcRM), Ptr{Cvoid}, (Cint, Ptr{Cchar}), id, var)
end

function RM_BmiGetVarGrid(id, var)
    ccall((:RM_BmiGetVarGrid, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, var)
end

function RM_BmiGetVarItemsize(id, name)
    ccall((:RM_BmiGetVarItemsize, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, name)
end

function RM_BmiGetVarNbytes(id, name)
    ccall((:RM_BmiGetVarNbytes, libPhreeqcRM), Cint, (Cint, Ptr{Cchar}), id, name)
end

function RM_BmiGetVarType(id, name, vtype, l)
    ccall((:RM_BmiGetVarType, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, name, vtype, l)
end

function RM_BmiGetVarUnits(id, name, units, l)
    ccall((:RM_BmiGetVarUnits, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}, Cint), id, name, units, l)
end

function RM_BmiInitialize(id, config_file)
    ccall((:RM_BmiInitialize, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, config_file)
end

function RM_BmiSetValueChar(id, name, src)
    ccall((:RM_BmiSetValueChar, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cchar}), id, name, src)
end

function RM_BmiSetValueDouble(id, name, src)
    ccall((:RM_BmiSetValueDouble, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cdouble), id, name, src)
end

function RM_BmiSetValueDoubleArray(id, name, src)
    ccall((:RM_BmiSetValueDoubleArray, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Ptr{Cdouble}), id, name, src)
end

function RM_BmiSetValueInt(id, name, src)
    ccall((:RM_BmiSetValueInt, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, name, src)
end

function RM_BmiUpdate(id)
    ccall((:RM_BmiUpdate, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_BmiUpdateUntil(id, end_time)
    ccall((:RM_BmiUpdateUntil, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, end_time)
end

function RM_BmiGetValueAtIndices(id, name, dest, inds, count)
    ccall((:RM_BmiGetValueAtIndices, libPhreeqcRM), Cvoid, (Cint, Ptr{Cchar}, Ptr{Cvoid}, Ptr{Cint}, Cint), id, name, dest, inds, count)
end

function RM_BmiSetValueAtIndices(id, name, inds, count, src)
    ccall((:RM_BmiSetValueAtIndices, libPhreeqcRM), Cvoid, (Cint, Ptr{Cchar}, Ptr{Cint}, Cint, Ptr{Cvoid}), id, name, inds, count, src)
end

function RM_BmiGetGridShape(id, grid, shape)
    ccall((:RM_BmiGetGridShape, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, shape)
end

function RM_BmiGetGridSpacing(id, grid, spacing)
    ccall((:RM_BmiGetGridSpacing, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, spacing)
end

function RM_BmiGetGridOrigin(id, grid, origin)
    ccall((:RM_BmiGetGridOrigin, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, origin)
end

function RM_BmiGetGridX(id, grid, x)
    ccall((:RM_BmiGetGridX, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, x)
end

function RM_BmiGetGridY(id, grid, y)
    ccall((:RM_BmiGetGridY, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, y)
end

function RM_BmiGetGridZ(id, grid, z)
    ccall((:RM_BmiGetGridZ, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cdouble}), id, grid, z)
end

function RM_BmiGetGridNodeCount(id, grid)
    ccall((:RM_BmiGetGridNodeCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

function RM_BmiGetGridEdgeCount(id, grid)
    ccall((:RM_BmiGetGridEdgeCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

function RM_BmiGetGridFaceCount(id, grid)
    ccall((:RM_BmiGetGridFaceCount, libPhreeqcRM), Cint, (Cint, Cint), id, grid)
end

function RM_BmiGetGridEdgeNodes(id, grid, edge_nodes)
    ccall((:RM_BmiGetGridEdgeNodes, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, edge_nodes)
end

function RM_BmiGetGridFaceEdges(id, grid, face_edges)
    ccall((:RM_BmiGetGridFaceEdges, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, face_edges)
end

function RM_BmiGetGridFaceNodes(id, grid, face_nodes)
    ccall((:RM_BmiGetGridFaceNodes, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, face_nodes)
end

function RM_BmiGetGridNodesPerFace(id, grid, nodes_per_face)
    ccall((:RM_BmiGetGridNodesPerFace, libPhreeqcRM), Cvoid, (Cint, Cint, Ptr{Cint}), id, grid, nodes_per_face)
end

function RM_Abort(id, result, err_str)
    ccall((:RM_Abort, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}), id, result, err_str)
end

function RM_CloseFiles(id)
    ccall((:RM_CloseFiles, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_Concentrations2Utility(id, c, n, tc, p_atm)
    ccall((:RM_Concentrations2Utility, libPhreeqcRM), Cint, (Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cdouble}), id, c, n, tc, p_atm)
end

function RM_Create(nxyz, nthreads)
    ccall((:RM_Create, libPhreeqcRM), Cint, (Cint, Cint), nxyz, nthreads)
end

function RM_CreateMapping(id, grid2chem)
    ccall((:RM_CreateMapping, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, grid2chem)
end

function RM_DecodeError(id, e)
    ccall((:RM_DecodeError, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, e)
end

function RM_Destroy(id)
    ccall((:RM_Destroy, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_DumpModule(id, dump_on, append)
    ccall((:RM_DumpModule, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint), id, dump_on, append)
end

function RM_ErrorMessage(id, errstr)
    ccall((:RM_ErrorMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, errstr)
end

function RM_FindComponents(id)
    ccall((:RM_FindComponents, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetBackwardMapping(id, n, list, size)
    ccall((:RM_GetBackwardMapping, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cint}, Ptr{Cint}), id, n, list, size)
end

function RM_GetChemistryCellCount(id)
    ccall((:RM_GetChemistryCellCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetComponent(id, num, chem_name, l)
    ccall((:RM_GetComponent, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, chem_name, l)
end

function RM_GetComponentCount(id)
    ccall((:RM_GetComponentCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetConcentrations(id, c)
    ccall((:RM_GetConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, c)
end

function RM_GetIthConcentration(id, i, c)
    ccall((:RM_GetIthConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

function RM_GetIthSpeciesConcentration(id, i, c)
    ccall((:RM_GetIthSpeciesConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

function RM_SetIthConcentration(id, i, c)
    ccall((:RM_SetIthConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

function RM_SetIthSpeciesConcentration(id, i, c)
    ccall((:RM_SetIthSpeciesConcentration, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cdouble}), id, i, c)
end

function RM_GetCurrentSelectedOutputUserNumber(id)
    ccall((:RM_GetCurrentSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetDensityCalculated(id, density)
    ccall((:RM_GetDensityCalculated, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

function RM_GetDensity(id, density)
    ccall((:RM_GetDensity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

function RM_GetEndCell(id, ec)
    ccall((:RM_GetEndCell, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, ec)
end

function RM_GetEquilibriumPhasesCount(id)
    ccall((:RM_GetEquilibriumPhasesCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetEquilibriumPhasesName(id, num, name, l1)
    ccall((:RM_GetEquilibriumPhasesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetErrorString(id, errstr, l)
    ccall((:RM_GetErrorString, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, errstr, l)
end

function RM_GetErrorStringLength(id)
    ccall((:RM_GetErrorStringLength, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetExchangeName(id, num, name, l1)
    ccall((:RM_GetExchangeName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetExchangeSpeciesCount(id)
    ccall((:RM_GetExchangeSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetExchangeSpeciesName(id, num, name, l1)
    ccall((:RM_GetExchangeSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetFilePrefix(id, prefix, l)
    ccall((:RM_GetFilePrefix, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}, Cint), id, prefix, l)
end

function RM_GetGasComponentsCount(id)
    ccall((:RM_GetGasComponentsCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetGasComponentsName(id, num, name, l1)
    ccall((:RM_GetGasComponentsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetGasCompMoles(id, gas_moles)
    ccall((:RM_GetGasCompMoles, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_moles)
end

function RM_GetGasCompPressures(id, gas_pressure)
    ccall((:RM_GetGasCompPressures, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_pressure)
end

function RM_GetGasCompPhi(id, gas_phi)
    ccall((:RM_GetGasCompPhi, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_phi)
end

function RM_GetGasPhaseVolume(id, gas_volume)
    ccall((:RM_GetGasPhaseVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_volume)
end

function RM_GetGfw(id, gfw)
    ccall((:RM_GetGfw, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gfw)
end

function RM_GetGridCellCount(id)
    ccall((:RM_GetGridCellCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetIPhreeqcId(id, i)
    ccall((:RM_GetIPhreeqcId, libPhreeqcRM), Cint, (Cint, Cint), id, i)
end

function RM_GetKineticReactionsCount(id)
    ccall((:RM_GetKineticReactionsCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetKineticReactionsName(id, num, name, l1)
    ccall((:RM_GetKineticReactionsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetMpiMyself(id)
    ccall((:RM_GetMpiMyself, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetMpiTasks(id)
    ccall((:RM_GetMpiTasks, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetNthSelectedOutputUserNumber(id, n)
    ccall((:RM_GetNthSelectedOutputUserNumber, libPhreeqcRM), Cint, (Cint, Cint), id, n)
end

function RM_GetPorosity(id, porosity)
    ccall((:RM_GetPorosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, porosity)
end

function RM_GetPressure(id, pressure)
    ccall((:RM_GetPressure, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, pressure)
end

function RM_GetSaturationCalculated(id, sat_calc)
    ccall((:RM_GetSaturationCalculated, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat_calc)
end

function RM_GetSaturation(id, sat_calc)
    ccall((:RM_GetSaturation, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat_calc)
end

function RM_GetSelectedOutput(id, so)
    ccall((:RM_GetSelectedOutput, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, so)
end

function RM_GetSelectedOutputColumnCount(id)
    ccall((:RM_GetSelectedOutputColumnCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSelectedOutputCount(id)
    ccall((:RM_GetSelectedOutputCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSelectedOutputHeading(id, icol, heading, length)
    ccall((:RM_GetSelectedOutputHeading, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, icol, heading, length)
end

function RM_GetSelectedOutputRowCount(id)
    ccall((:RM_GetSelectedOutputRowCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSICount(id)
    ccall((:RM_GetSICount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSIName(id, num, name, l1)
    ccall((:RM_GetSIName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetSolidSolutionComponentsCount(id)
    ccall((:RM_GetSolidSolutionComponentsCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSolidSolutionComponentsName(id, num, name, l1)
    ccall((:RM_GetSolidSolutionComponentsName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetSolidSolutionName(id, num, name, l1)
    ccall((:RM_GetSolidSolutionName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetSolutionVolume(id, vol)
    ccall((:RM_GetSolutionVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, vol)
end

function RM_GetSpeciesConcentrations(id, species_conc)
    ccall((:RM_GetSpeciesConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_conc)
end

function RM_GetSpeciesCount(id)
    ccall((:RM_GetSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSpeciesD25(id, diffc)
    ccall((:RM_GetSpeciesD25, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, diffc)
end

function RM_GetSpeciesLog10Gammas(id, species_log10gammas)
    ccall((:RM_GetSpeciesLog10Gammas, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_log10gammas)
end

function RM_GetSpeciesLog10Molalities(id, species_log10molalities)
    ccall((:RM_GetSpeciesLog10Molalities, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_log10molalities)
end

function RM_GetSpeciesName(id, i, name, length)
    ccall((:RM_GetSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, i, name, length)
end

function RM_GetSpeciesSaveOn(id)
    ccall((:RM_GetSpeciesSaveOn, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSpeciesZ(id, z)
    ccall((:RM_GetSpeciesZ, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, z)
end

function RM_GetStartCell(id, sc)
    ccall((:RM_GetStartCell, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, sc)
end

function RM_GetTemperature(id, temperature)
    ccall((:RM_GetTemperature, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, temperature)
end

function RM_GetSurfaceName(id, num, name, l1)
    ccall((:RM_GetSurfaceName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetSurfaceSpeciesCount(id)
    ccall((:RM_GetSurfaceSpeciesCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetSurfaceSpeciesName(id, num, name, l1)
    ccall((:RM_GetSurfaceSpeciesName, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetSurfaceType(id, num, name, l1)
    ccall((:RM_GetSurfaceType, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cchar}, Cint), id, num, name, l1)
end

function RM_GetThreadCount(id)
    ccall((:RM_GetThreadCount, libPhreeqcRM), Cint, (Cint,), id)
end

function RM_GetTime(id)
    ccall((:RM_GetTime, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_GetTimeConversion(id)
    ccall((:RM_GetTimeConversion, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_GetTimeStep(id)
    ccall((:RM_GetTimeStep, libPhreeqcRM), Cdouble, (Cint,), id)
end

function RM_GetViscosity(id, viscosity)
    ccall((:RM_GetViscosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, viscosity)
end

function RM_InitialPhreeqc2Concentrations(id, c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
    ccall((:RM_InitialPhreeqc2Concentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
end

function RM_InitialSolutions2Module(id, solutions)
    ccall((:RM_InitialSolutions2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, solutions)
end

function RM_InitialEquilibriumPhases2Module(id, equilibrium_phases)
    ccall((:RM_InitialEquilibriumPhases2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, equilibrium_phases)
end

function RM_InitialExchanges2Module(id, exchanges)
    ccall((:RM_InitialExchanges2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, exchanges)
end

function RM_InitialSurfaces2Module(id, surfaces)
    ccall((:RM_InitialSurfaces2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, surfaces)
end

function RM_InitialGasPhases2Module(id, gas_phases)
    ccall((:RM_InitialGasPhases2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, gas_phases)
end

function RM_InitialSolidSolutions2Module(id, solid_solutions)
    ccall((:RM_InitialSolidSolutions2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, solid_solutions)
end

function RM_InitialKinetics2Module(id, kinetics)
    ccall((:RM_InitialKinetics2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, kinetics)
end

function RM_InitialPhreeqc2Module(id, initial_conditions1, initial_conditions2, fraction1)
    ccall((:RM_InitialPhreeqc2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, initial_conditions1, initial_conditions2, fraction1)
end

function RM_InitialPhreeqc2SpeciesConcentrations(id, species_c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
    ccall((:RM_InitialPhreeqc2SpeciesConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), id, species_c, n_boundary, boundary_solution1, boundary_solution2, fraction1)
end

function RM_InitialPhreeqcCell2Module(id, n, module_numbers, dim_module_numbers)
    ccall((:RM_InitialPhreeqcCell2Module, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Ptr{Cint}, Cint), id, n, module_numbers, dim_module_numbers)
end

function RM_LoadDatabase(id, db_name)
    ccall((:RM_LoadDatabase, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, db_name)
end

function RM_LogMessage(id, str)
    ccall((:RM_LogMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

function RM_MpiWorker(id)
    ccall((:RM_MpiWorker, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_MpiWorkerBreak(id)
    ccall((:RM_MpiWorkerBreak, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_OpenFiles(id)
    ccall((:RM_OpenFiles, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_OutputMessage(id, str)
    ccall((:RM_OutputMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

function RM_RunCells(id)
    ccall((:RM_RunCells, libPhreeqcRM), IRM_RESULT, (Cint,), id)
end

function RM_RunFile(id, workers, initial_phreeqc, utility, chem_name)
    ccall((:RM_RunFile, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint, Ptr{Cchar}), id, workers, initial_phreeqc, utility, chem_name)
end

function RM_RunString(id, workers, initial_phreeqc, utility, input_string)
    ccall((:RM_RunString, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint, Ptr{Cchar}), id, workers, initial_phreeqc, utility, input_string)
end

function RM_ScreenMessage(id, str)
    ccall((:RM_ScreenMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, str)
end

function RM_SetComponentH2O(id, tf)
    ccall((:RM_SetComponentH2O, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

function RM_SetConcentrations(id, c)
    ccall((:RM_SetConcentrations, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, c)
end

function RM_SetCurrentSelectedOutputUserNumber(id, n_user)
    ccall((:RM_SetCurrentSelectedOutputUserNumber, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, n_user)
end

function RM_SetDensityUser(id, density)
    ccall((:RM_SetDensityUser, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

function RM_SetDensity(id, density)
    ccall((:RM_SetDensity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, density)
end

function RM_SetDumpFileName(id, dump_name)
    ccall((:RM_SetDumpFileName, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, dump_name)
end

function RM_SetErrorHandlerMode(id, mode)
    ccall((:RM_SetErrorHandlerMode, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, mode)
end

function RM_SetErrorOn(id, tf)
    ccall((:RM_SetErrorOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

function RM_SetFilePrefix(id, prefix)
    ccall((:RM_SetFilePrefix, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, prefix)
end

function RM_SetGasCompMoles(id, gas_moles)
    ccall((:RM_SetGasCompMoles, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_moles)
end

function RM_SetGasPhaseVolume(id, gas_volume)
    ccall((:RM_SetGasPhaseVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, gas_volume)
end

function RM_SetMpiWorkerCallback(id, fcn)
    ccall((:RM_SetMpiWorkerCallback, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cvoid}), id, fcn)
end

function RM_SetMpiWorkerCallbackCookie(id, cookie)
    ccall((:RM_SetMpiWorkerCallbackCookie, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cvoid}), id, cookie)
end

function RM_SetNthSelectedOutput(id, n)
    ccall((:RM_SetNthSelectedOutput, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, n)
end

function RM_SetPartitionUZSolids(id, tf)
    ccall((:RM_SetPartitionUZSolids, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

function RM_SetPorosity(id, por)
    ccall((:RM_SetPorosity, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, por)
end

function RM_SetPressure(id, p)
    ccall((:RM_SetPressure, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, p)
end

function RM_SetPrintChemistryMask(id, cell_mask)
    ccall((:RM_SetPrintChemistryMask, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cint}), id, cell_mask)
end

function RM_SetPrintChemistryOn(id, workers, initial_phreeqc, utility)
    ccall((:RM_SetPrintChemistryOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint, Cint, Cint), id, workers, initial_phreeqc, utility)
end

function RM_SetRebalanceByCell(id, method)
    ccall((:RM_SetRebalanceByCell, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, method)
end

function RM_SetRebalanceFraction(id, f)
    ccall((:RM_SetRebalanceFraction, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, f)
end

function RM_SetRepresentativeVolume(id, rv)
    ccall((:RM_SetRepresentativeVolume, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, rv)
end

function RM_SetSaturationUser(id, sat)
    ccall((:RM_SetSaturationUser, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat)
end

function RM_SetSaturation(id, sat)
    ccall((:RM_SetSaturation, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, sat)
end

function RM_SetScreenOn(id, tf)
    ccall((:RM_SetScreenOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

function RM_SetSelectedOutputOn(id, selected_output)
    ccall((:RM_SetSelectedOutputOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, selected_output)
end

function RM_SetSpeciesSaveOn(id, save_on)
    ccall((:RM_SetSpeciesSaveOn, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, save_on)
end

function RM_SetTemperature(id, t)
    ccall((:RM_SetTemperature, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, t)
end

function RM_SetTime(id, time)
    ccall((:RM_SetTime, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, time)
end

function RM_SetTimeConversion(id, conv_factor)
    ccall((:RM_SetTimeConversion, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, conv_factor)
end

function RM_SetTimeStep(id, time_step)
    ccall((:RM_SetTimeStep, libPhreeqcRM), IRM_RESULT, (Cint, Cdouble), id, time_step)
end

function RM_SetUnitsExchange(id, option)
    ccall((:RM_SetUnitsExchange, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsGasPhase(id, option)
    ccall((:RM_SetUnitsGasPhase, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsKinetics(id, option)
    ccall((:RM_SetUnitsKinetics, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsPPassemblage(id, option)
    ccall((:RM_SetUnitsPPassemblage, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsSolution(id, option)
    ccall((:RM_SetUnitsSolution, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsSSassemblage(id, option)
    ccall((:RM_SetUnitsSSassemblage, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SetUnitsSurface(id, option)
    ccall((:RM_SetUnitsSurface, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, option)
end

function RM_SpeciesConcentrations2Module(id, species_conc)
    ccall((:RM_SpeciesConcentrations2Module, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cdouble}), id, species_conc)
end

function RM_StateSave(id, istate)
    ccall((:RM_StateSave, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

function RM_StateApply(id, istate)
    ccall((:RM_StateApply, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

function RM_StateDelete(id, istate)
    ccall((:RM_StateDelete, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, istate)
end

function RM_UseSolutionDensityVolume(id, tf)
    ccall((:RM_UseSolutionDensityVolume, libPhreeqcRM), IRM_RESULT, (Cint, Cint), id, tf)
end

function RM_WarningMessage(id, warn_str)
    ccall((:RM_WarningMessage, libPhreeqcRM), IRM_RESULT, (Cint, Ptr{Cchar}), id, warn_str)
end

@cenum VAR_TYPE::UInt32 begin
    TT_EMPTY = 0
    TT_ERROR = 1
    TT_LONG = 2
    TT_DOUBLE = 3
    TT_STRING = 4
end

@cenum VRESULT::Int32 begin
    VR_OK = 0
    VR_OUTOFMEMORY = -1
    VR_BADVARTYPE = -2
    VR_INVALIDARG = -3
    VR_INVALIDROW = -4
    VR_INVALIDCOL = -5
end

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
