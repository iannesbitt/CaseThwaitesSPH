#!/bin/bash

# "name" and "dirout" are named according to the testcase

name=CaseThwaites01
dirout=03_${name}_out
diroutdata=${dirout} #/data

# "executables" are renamed and called from their directory

dirbin=../../../../bin/linux
gencase="${dirbin}/GenCase4_linux64"
dualsphysicscpu="${dirbin}/DualSPHysics4.2CPU_linux64"
dualsphysicsgpu="${dirbin}/DualSPHysics4.2_linux64"
boundaryvtk="${dirbin}/BoundaryVTK4_linux64"
partvtk="${dirbin}/PartVTK4_linux64"
partvtkout="${dirbin}/PartVTKOut4_linux64"
measuretool="${dirbin}/MeasureTool4_linux64"
computeforces="${dirbin}/ComputeForces4_linux64"
isosurface="${dirbin}/IsoSurface4_linux64"
flowtool="${dirbin}/FlowTool4_linux64"
floatinginfo="${dirbin}/FloatingInfo4_linux64"

# Library path must be indicated properly

current=$(pwd)
cd $dirbin
path_so=$(pwd)
cd $current
export LD_LIBRARY_PATH=$path_so

# CODES are executed according the selected parameters of execution in this testcase
errcode=0

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/particles/PartIce -onlymk:12 -vars:+press,+mk
  errcode=$?
fi

#errcode=1

mkdir forces
# Executes ComputeForces to create a CSV file with force at each simulation time.
if [ $errcode -eq 0 ]; then
  $computeforces -dirin $diroutdata -onlymk:12 -savecsv $dirout/forces -savevtk $dirout/IceForces
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  echo All done
else
  echo Execution aborted
fi
read -n1 -r -p "Press any key to continue..." key
echo
