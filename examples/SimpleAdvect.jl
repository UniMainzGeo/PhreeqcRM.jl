# Based on PHREEQC Example 11
using PhreeqcRM
import PhreeqcRM.LibPhreeqcRM as PC

function simpleadvection_c(c::Vector{Float64}, bc_conc::Vector{Float64}, ncomps, nxyz, dim)
    # Advect
    for i in (nxyz - 1):-1:1
        for j in 1:ncomps
            c[(j - 1) * nxyz + i + 1] = c[(j - 1) * nxyz + i]
        end
    end
    # Cell 0 gets boundary condition
    for j in 1:ncomps
        c[(j - 1) * nxyz + 1] = bc_conc[(j - 1) * dim + 1]
    end
end

nxyz = 20;
id = PC.RM_Create(nxyz, 1);

# Set properties
status = PC.RM_SetComponentH2O(id, 0);
status = PC.RM_UseSolutionDensityVolume(id, 0);
# Open error, log, and output files
status = PC.RM_SetFilePrefix(id, "SimpleAdvect_c");
status = PC.RM_OpenFiles(id);
# Set concentration units
status = PC.RM_SetUnitsSolution(id, 2);      # 1, mg/L; 2, mol/L; 3, kg/kgs
status = PC.RM_SetUnitsExchange(id, 1);      # 0, mol/L cell; 1, mol/L water; 2 mol/L rock
# Set conversion from seconds to days
status = PC.RM_SetTimeConversion(id, 1.0 / 86400.0);
# Set initial porosity
por = fill(0.2, nxyz)
status = PC.RM_SetPorosity(id, por);
# Set cells to print chemistry when print chemistry is turned on
print_chemistry_mask = zeros(Int32, nxyz);
for i = 1:nxyz
    print_chemistry_mask[i] = 1;
end
status = PC.RM_SetPrintChemistryMask(id, print_chemistry_mask);
nchem = PC.RM_GetChemistryCellCount(id);
# --------------------------------------------------------------------------
# Set initial conditions
# --------------------------------------------------------------------------
# Set printing of chemistry file
status = PC.RM_SetPrintChemistryOn(id, 0, 1, 0); # workers, initial_phreeqc, utility
# Set printing of chemistry file
status = PC.RM_LoadDatabase(id, joinpath(database_dir,"phreeqc.dat"));
# Run file to define solutions and reactants for initial conditions, selected output
# There are three types of IPhreeqc instances in PhreeqcRM
# Argument 1 refers to the workers for doing reaction calculations for transport
# Argument 2 refers to the InitialPhreeqc instance for accumulating initial and boundary conditions
# Argument 3 refers to the Utility instance
status = PC.RM_RunFile(id, 1, 1, 1, joinpath(testfile_dir,"advect.pqi"));
# Clear contents of workers and utility
str = " ";
status = PC.RM_RunString(id, 1, 0, 1, str);	# workers, initial_phreeqc, utility 
# Determine number of components to transport
ncomps = PC.RM_FindComponents(id);
# Get component information
components = String[];
for i = 0:ncomps-1
    name        = Vector{UInt8}(undef, 100)
    status1     = PC.RM_GetComponent(id, i, name, 100);
    name_string = String(name[findall(name .!= 0x00)])
    status = PC.RM_OutputMessage(id, str);

    push!(components, name_string)
end
status = PC.RM_OutputMessage(id, "\n");
# Set array of initial conditions
ic1  = zeros(Int32,  7*nxyz)
ic2  = zeros(Int32,  7*nxyz)
f1   = zeros(Float64,7*nxyz)
for i = 1:nxyz;
    ic1[i] = 1;       # Solution 1
    ic1[nxyz + i] = -1;      # Equilibrium phases none
    ic1[2 * nxyz + i] = 1;       # Exchange 1
    ic1[3 * nxyz + i] = -1;      # Surface none
    ic1[4 * nxyz + i] = -1;      # Gas phase none
    ic1[5 * nxyz + i] = -1;      # Solid solutions none
    ic1[6 * nxyz + i] = -1;      # Kinetics none
    ic2[i] = -1;      # Solution none
    ic2[nxyz + i] = -1;      # Equilibrium phases none
    ic2[2 * nxyz + i] = -1;      # Exchange none
    ic2[3 * nxyz + i] = -1;      # Surface none
    ic2[4 * nxyz + i] = -1;      # Gas phase none
    ic2[5 * nxyz + i] = -1;      # Solid solutions none
    ic2[6 * nxyz + i] = -1;      # Kinetics none
    f1[i] = 1.0;      # Mixing fraction ic1 Solution
    f1[nxyz + i] = 1.0;      # Mixing fraction ic1 Equilibrium phases 
    f1[2 * nxyz + i] = 1.0;      # Mixing fraction ic1 Exchange 1
    f1[3 * nxyz + i] = 1.0;      # Mixing fraction ic1 Surface 
    f1[4 * nxyz + i] = 1.0;      # Mixing fraction ic1 Gas phase 
    f1[5 * nxyz + i] = 1.0;      # Mixing fraction ic1 Solid solutions 
    f1[6 * nxyz + i] = 1.0;      # Mixing fraction ic1 Kinetics end
end
status = PC.RM_InitialPhreeqc2Module(id, ic1, ic2, f1);

# Initial equilibration of cells
time_ = 0.0;
time_step = 0.0;
c = zeros(ncomps * nxyz);
status = PC.RM_SetTime(id, time_);
status = PC.RM_SetTimeStep(id, time_step);
status = PC.RM_RunCells(id);
status = PC.RM_GetConcentrations(id, c);
# --------------------------------------------------------------------------
# Set boundary condition
# --------------------------------------------------------------------------
nbound = 1;
bc1 = zeros(Int32,nbound);
bc2 = zeros(Int32,nbound);
bc_f1 = zeros(nbound );
bc_conc = zeros(ncomps * nbound );
for i = 1:nbound
	bc1[i] = 0;       # Solution 0 from Initial IPhreeqc instance
	bc2[i] = -1;      # no bc2 solution for mixing
	bc_f1[i] = 1.0;   # mixing fraction for bc1
end
status = PC.RM_InitialPhreeqc2Concentrations(id, bc_conc, nbound, bc1, bc2, bc_f1);
# --------------------------------------------------------------------------
# Transient loop
# --------------------------------------------------------------------------
nsteps = 10;
pressure = zeros(nxyz );
temperature = zeros(nxyz );
for i = 1:nxyz
	pressure[i] = 2.0;
	temperature[i] = 20.0;
end
status = PC.RM_SetPressure(id, pressure);
status = PC.RM_SetTemperature(id, temperature);
time_step = 86400;
status = PC.RM_SetTimeStep(id, time_step);
for isteps = 1:nsteps
    global time_, c
    # Advection calculation
    println("Beginning transport calculation      $(PC.RM_GetTime(id) * PC.RM_GetTimeConversion(id)) days")
	status = PC.RM_LogMessage(id, str);
	status = PC.RM_SetScreenOn(id, 1);
	status = PC.RM_ScreenMessage(id, str);

    println("          Time step                  $(PC.RM_GetTimeStep(id) * PC.RM_GetTimeConversion(id)) days")
    status = PC.RM_LogMessage(id, str);
    status = PC.RM_ScreenMessage(id, str);

    # Advect one step
	simpleadvection_c(c, bc_conc, ncomps, nxyz, nbound);

    # Transfer data to PhreeqcRM for reactions
    status = PC.RM_SetConcentrations(id, c);          # Transported concentrations
    status = PC.RM_SetTimeStep(id, time_step);        # Time step for kinetic reactions
    time_ = time_ + time_step;
    status = PC.RM_SetTime(id, time_);                 # Current time
    # Set print flag
	if (isteps == nsteps - 1)
		status = PC.RM_SetSelectedOutputOn(id, 1);       # enable selected output
		status = PC.RM_SetPrintChemistryOn(id, 1, 0, 0); # print at last time step, workers, initial_phreeqc, utility
	else
		status = PC.RM_SetSelectedOutputOn(id, 0);       # disable selected output
		status = PC.RM_SetPrintChemistryOn(id, 0, 0, 0); # workers, initial_phreeqc, utility
    end
    # Run cells with transported conditions
    println("Beginning reaction calculation       $(PC.RM_GetTime(id) * PC.RM_GetTimeConversion(id)) days")
	status = PC.RM_LogMessage(id, str);
	status = PC.RM_ScreenMessage(id, str);
	status = PC.RM_RunCells(id);
end
# Finalize
status = PC.RM_CloseFiles(id);
status = PC.RM_MpiWorkerBreak(id);
status = PC.RM_Destroy(id);