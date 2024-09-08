using PhreeqcRM
using PhreeqcRM_jll
import PhreeqcRM.LibPhreeqcRM as PC
using Printf

function PrintCells(gcomps::Vector{String}, gas_moles::Vector{Float64},
    gas_p::Vector{Float64}, gas_phi::Vector{Float64}, nxyz::Int,
    str::String)
    println(stderr, "\n$str\n")
    # print cells 0,1,2
    for j in 0:2 # cell
        println(stderr, "Cell: $j")
        println(stderr, "               Moles         P         Phi")
        for i in 0:2 # component
            k = i * nxyz + j
            @printf "%8s  %10.4f  %10.4f  %10.4f\n" gcomps[i+1] gas_moles[k+1] gas_p[k+1] gas_phi[k+1]

        end
    end
end

nxyz = 20;

id = PC.RM_Create(nxyz, 1);

status = PC.RM_SetFilePrefix(id, "Gas_c");

status = PC.RM_OpenFiles(id);  # Open error, log, and output files

# Set concentration units
status = PC.RM_SetUnitsSolution(id, 2);      # 1, mg/L; 2, mol/L; 3, kg/kgs
status = PC.RM_SetUnitsGasPhase(id, 0);      # 0, mol/L cell; 1, mol/L water; 2 mol/L rock

# Set initial porosity
por = fill(0.2, nxyz)
status = PC.RM_SetPorosity(id, por);

# Set initial saturation
sat = fill(0.5, nxyz)
status = PC.RM_SetSaturationUser(id, sat);

# Set printing of chemistry file
status = PC.RM_SetPrintChemistryOn(id, 0, 1, 0); # workers, initial_phreeqc, utility

nchem = PC.RM_GetChemistryCellCount(id);

# Set printing of chemistry file
status = PC.RM_LoadDatabase(id, joinpath(database_dir,"phreeqc.dat"));
if (status != 0)
	status = PC.RM_OutputMessage(id, "Unable to open database.");
end

# Run file to define solutions and gases for initial conditions
inputfile_dir = joinpath(PhreeqcRM_jll.artifact_dir,"test_input"); # the example input files are in the test_input directory
status = PC.RM_RunFile(id, 0, 1, 0, joinpath(inputfile_dir,"gas.pqi"));
if (status != 0)
    status = PC.RM_OutputMessage(id, "Unable to run input file.");
end

# Determine number of components and gas components
ncomps = PC.RM_FindComponents(id);
ngas = PC.RM_GetGasComponentsCount(id);

# Get gas component names
gas_comps = String[];
for i = 0:ngas-1
    name        = Vector{UInt8}(undef, 100)
    status1     = PC.RM_GetGasComponentsName(id, i, name, 100);
    name_string = String(name[findall(name .!= 0x00)])

    push!(gas_comps, name_string)
end

# Set array of initial conditions
ic1  = zeros(Int32,     7*nxyz)
ic2  = zeros(Int32,     7*nxyz)
f1   = zeros(Float64,   7*nxyz)
for i = 1:nxyz;

    ic1[i] = 1;                 # Solution 1
	ic1[nxyz + i] = -1;         # Equilibrium phases none
	ic1[2 * nxyz + i] = -1;     # Exchange 1
	ic1[3 * nxyz + i] = -1;     # Surface none
	ic1[4 * nxyz + i] = i % 3 + 1;      # Gas phase none
	ic1[5 * nxyz + i] = -1;     # Solid solutions none
	ic1[6 * nxyz + i] = -1;     # Kinetics none
	ic2[i] = -1;                # Solution none
	ic2[nxyz + i] = -1;         # Equilibrium phases none
	ic2[2 * nxyz + i] = -1;     # Exchange none
	ic2[3 * nxyz + i] = -1;     # Surface none
	ic2[4 * nxyz + i] = -1;     # Gas phase none
	ic2[5 * nxyz + i] = -1;     # Solid solutions none
	ic2[6 * nxyz + i] = -1;     # Kinetics none
	f1[i] = 1.0;                # Mixing fraction ic1 Solution
	f1[nxyz + i] = 1.0;         # Mixing fraction ic1 Equilibrium phases 
	f1[2 * nxyz + i] = 1.0;     # Mixing fraction ic1 Exchange 1
	f1[3 * nxyz + i] = 1.0;     # Mixing fraction ic1 Surface 
	f1[4 * nxyz + i] = 1.0;     # Mixing fraction ic1 Gas phase 
	f1[5 * nxyz + i] = 1.0;     # Mixing fraction ic1 Solid solutions 
	f1[6 * nxyz + i] = 1.0;     # Mixing fraction ic1 Kinetics
end
status = PC.RM_InitialPhreeqc2Module(id, ic1, ic2, f1);


# Get gases
gas_moles   = zeros(ngas * nxyz);
gas_p       = zeros(ngas * nxyz );
gas_phi     = zeros(ngas * nxyz );
status      = PC.RM_GetGasCompMoles(id, gas_moles);
status      = PC.RM_GetGasCompPressures(id, gas_p);
status      = PC.RM_GetGasCompPhi(id, gas_phi);
PrintCells(gas_comps, gas_moles, gas_p, gas_phi, nxyz, "Initial conditions");

# multiply by 2
gas_moles = gas_moles.*2
status = PC.RM_SetGasCompMoles(id, gas_moles);
status = PC.RM_GetGasCompMoles(id, gas_moles);
status = PC.RM_GetGasCompPressures(id, gas_p);
status = PC.RM_GetGasCompPhi(id, gas_phi);
PrintCells(gas_comps, gas_moles, gas_p, gas_phi, nxyz, "Initial conditions times 2");

# eliminate CH4 in cell 0
gas_moles[1] = -1.0;
# Gas phase is removed from cell 1
gas_moles[2] = gas_moles[nxyz + 2] = gas_moles[2 * nxyz + 2] = -1.0;
status = PC.RM_SetGasCompMoles(id, gas_moles);
status = PC.RM_RunCells(id);
status = PC.RM_GetGasCompMoles(id, gas_moles);
status = PC.RM_GetGasCompPressures(id, gas_p);
status = PC.RM_GetGasCompPhi(id, gas_phi);
PrintCells(gas_comps, gas_moles, gas_p, gas_phi, nxyz, "Remove some components");

# add CH4 in cell 0
gas_moles[1] = 0.02;
# Gas phase is added to cell 1; fixed pressure by default
gas_moles[2] = 0.01;
gas_moles[nxyz + 2] = 0.02;
gas_moles[2 * nxyz + 2] = 0.03;
status = PC.RM_SetGasCompMoles(id, gas_moles);
# Set volume for cell 1 and convert to fixed pressure gas phase
gas_volume = fill(-1.0, nxyz);
gas_volume[2] = 12.25;
status = PC.RM_SetGasPhaseVolume(id, gas_volume);
status = PC.RM_RunCells(id);
status = PC.RM_GetGasCompMoles(id, gas_moles);
status = PC.RM_GetGasCompPressures(id, gas_p);
status = PC.RM_GetGasCompPhi(id, gas_phi);
PrintCells(gas_comps, gas_moles, gas_p, gas_phi, nxyz, "Add components back");

# Finalize
status = PC.RM_MpiWorkerBreak(id);
status = PC.RM_CloseFiles(id);
status = PC.RM_Destroy(id);