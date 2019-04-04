#!/bin/bash

# "name" and "dirout" are named according to the testcase

name=CaseThwaites01
dirout=${name}_out

# "executables" are renamed and called from their directory

dirbin=../../../../bin/linux
gencase="${dirbin}/GenCase4_linux64"
dsphliquidgascpu="${dirbin}/DualSPHysics4.0_LiquidGasCPU_linux64"
dsphliquidgasgpu="${dirbin}/DualSPHysics4.0_LiquidGas_linux64"
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
cd ${dirbin}
path_so=$(pwd)
cd $current
export LD_LIBRARY_PATH=$path_so                        

# "dirout" is created to store results or it is #oved if it already exists

if [ -e $dirout ]; then
    rm -f -r $dirout
fi
mkdir $dirout

# a copy of CaseSloshingAccData.csv must exist in dirout

cp ${name}_Data.csv $dirout

# CODES are executed according the selected parameters of execution in this testcase
errcode=0

if [ $errcode -eq 0 ]; then
  $gencase ${name}_Def $dirout/$name -save:all
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $dsphliquidgasgpu -gpu $dirout/$name $dirout -svres
  errcode=$?
fi

dirout2=${dirout}/particles; mkdir $dirout2
if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout2/PartFluid -onlytype:-all,+fluid -vars:+press,+mk
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout2/PartTank -onlytype:-all,bound
  errcode=$?
fi

if [ $errcode -eq 0 ]; then   
  $partvtkout -dirin $dirout -savevtk $dirout2/PartFluidOut -SaveResume $dirout2/_ResumeFluidOut
  errcode=$?
fi

dirout2=${dirout}/velocity; mkdir $dirout2
if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points ${name}_PointsPressure.txt -onlytype:-all,+fluid -vars:-all,+press -savevtk $dirout2/PointsPressure_Water -savecsv $dirout2/_PointsPressure_Water -onlymk:1
  errcode=$?
fi

dirout2=${dirout}/pressure; mkdir $dirout2
if [ $errcode -eq 0 ]; then
  $measuretool -dirin $dirout -points ${name}_PointsPressure.txt -onlytype:-all,+fluid -vars:-all,+press -savevtk $dirout2/PointsPressure_Air -savecsv $dirout2/_PointsPressure_Air -onlymk:2
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
    echo All done
else
    echo Execution aborted
fi
read -n1 -r -p "Press any key to continue..." key
echo
