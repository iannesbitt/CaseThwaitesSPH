# CaseThwaitesSPH

![Image of dynamics in model output](animations/00_vel_type_id.0900.png)

## What

This repository contains the inputs, parameters, and outputs of a three-phase [DualSPHysics](https://github.com/DualSPHysics/DualSPHysics) model looking at the dynamics and interaction of forces beneath and outboard of the floating portion of Thwaites Glacier, West Antarctica. It was produced by Ian Nesbitt with assistance from the participants of the 2019 Earth and Climate Science Fluid Dynamics class at the University of Maine.

## Why

The goal of this project is to understand the forces and dynamic physics that act on Thwaites and contribute to the behavior of the floating and grounded portions of the ice sheet. Thwaites sits at the margin of one of the largest and most vulnerable major ice sheets in the world, the West Antarctic Ice Sheet (WAIS), much of which drains via Thwaites. Thwaites itself is understood to be a major keyhole to the WAIS; i.e. a collapse of Thwaites glacier could lead to a subsequent collapse of the entire WAIS, an ice body that contains approximately 3.3 meters' worth of global sea level.

## How

DualSPHysics is free and open-source code to model free-surface flow phenomena and calculate forces acting on a per-particle basis, where Eulerian and continuum models struggle. Models are constructed of particles, rather than meshes, which allows for computation of fluid interaction without the need to recompute mesh extent at each time step. Each particle has a bell curve-like "smoothing kernel" which defines the strength of its interaction with neighboring particles. Because so many interactions can happen over the course of a model run, DualSPHysics uses [CUDA](https://developer.nvidia.com/cuda-zone) to interface with graphics processing unit (GPU) computing power. Since GPUs contain many smaller cores whereas central processing units (CPUs) contain a few more powerful ones, GPUs can calculate interactions between many particles much more efficiently. For this reason, if you intend to run this code, we highly recommend running it with a CUDA-capable GPU. *Be warned: outputs from this model are huge, as it calculates particle information at thousands of time steps in each model run.*


### Code projects used to run the model and create outputs

All code used to create this project is proudly free and open-source. All observational data used to create seafloor and ice sheet geometry is released through the British Antarctic Survey's BEDMAP2 dataset and is freely available through Quantarctica 3.1.

- Ice sheet geometry: [BEDMAP2](https://www.bas.ac.uk/project/bedmap-2/) data from [Quantarctica](http://quantarctica.npolar.no/) 3.1 (queried using [QGIS](https://github.com/qgis/QGIS) 3.6)
- Conversion of XYZ to STL surfaces: [xyz2stl](https://github.com/NWRichmond/xyz2stl) v. Sept 2017 by [Nick Richmond](https://github.com/NWRichmond)
- Physics solver: [DualSPHysics](https://github.com/DualSPHysics/DualSPHysics) 4.2
- Visualization: [Paraview](https://github.com/Kitware/ParaView) 5.4.1
- Animations: [ffmpeg](https://github.com/FFmpeg/FFmpeg) 4.1.2


# Model runs

More details of model initialization parameters for each model run can be found in the `xx_CaseThwaites_Def.xml` files that reside in the root directory.

## Run 00 - 2019-04-01
### Geometry

![Run 00 geometry](animations/00_geometry.png)

We created bed and ice sheet geometry by loading four STL files representing bed, ice bottom, ice surface, and meltwater layers, and filling the space between them with either boundary (fixed) or fluid particles of densities listed below. This run was a test, and as such the STL files used to initialize are primitive.

### Initialization

#### Viscosity

We used equal artificial viscosities for all fluids in the model (CDW, meltwater, and atmosphere) because the DualSPHysics template used to create the parameters of this model, `CaseSloshingAcc_LiquidGas` (available with version 4.2 and described on page 96 of [this document](http://dual.sphysics.org/index.php/download_file/view/252/)), used equal values for its gas-water viscosity.

#### Density

- Air: 1.18 kg/m^{3}

#### Atmospheric forcing

This model generates five wind paddles, which each travel at 3 model-meters per model-second over the surface. This is meant to simulate the transition between laminar flow in the upper atmosphere and boundary layer mixing near the surface.

#### Runtime

This run was 5 model-seconds long and consists of 1000 samples (sample rate 0.005 model-seconds).

## Run 01 - 2019-04-02
### Geometry

![Run 01 geometry](animations/01_geometry.png)

We refined STL files and decreased meltwater volume by thinning the meltwater parcel between ice and ocean water. Meltwater in model 00 was too buoyant. Too correct this we also decreased the density gradient in order to reduce some effects that cannot be found in nature, for example meltwater lenses boiling up past the elevation of the toe of the floating ice sheet.


### Initialization

#### Viscosity

We increased viscosity of water in order to slow particle migration across the water surface and attempt to more closely adhere to the atmosphere/water viscosity gradient observed in nature.

#### Density

We decreased CDW density from 1030 kg/m<sup>3</sup> to 1028 kg/m<sup>3</sup> to more accurately reflect the density of CDW at measured salinity and temperature values.

#### Atmospheric forcing

We re-initialized with the same wind paddle geometry and velocity.

#### Runtime

This run was 20 model-seconds long and consists of 4000 samples (sample rate 0.005 model-seconds).

## Run 02 - 2019-04-04
### Geometry

![Run 02 geometry](animations/02_geometry.png)

After run 01 we determined that the volume of meltwater was unsatisfactory. We calculated the expected meltwater flux for the floating portion of Thwaites using the method described by M. Dryak in her Master's thesis which follows from Enderlin and Hamilton (2014). We then calculated the expected volume of meltwater given this flux and given the subglacial melt discharge modeled by De Brocq et al. (2013).

### Initialization

#### Viscosity

Viscosity is the same as run 01.

#### Density

Meltwater density observed in the eastern Amundsen Sea only differs from CDW in density by approximately 0.7 kg/m<sup>3</sup> (P. Dutrieux, pers. comm.). For the purposes of this model, we initialized with a slightly higher density gradient in order to speed up the processes in model-time, in order to simulate 

#### Atmospheric forcing

We re-initialized with the same wind paddle geometry and velocity.

#### Runtime

This run was 20 model-seconds long and consists of 4000 samples (sample rate 0.005 model-seconds).

## Description of project contents

### File organization

Files that specifically pertain to one model run are prefaced with the number of that model run. For example, the files used for or output by run 0 will be named `00_FILENAME`, those related specifically to run 1 will be named `01_FILENAME`, etc. Thus the inputs and outputs can remain in the state they were at runtime for future reference.

### File structure

The following is a directory tree describing the contents of the repository and their function.

```
.
├── animations                                  # folder for paraview output and ffmpeg rendering
│   ├── 00_vel_type_id.0900.png                 # image showing a model time step from run 00.
│   ├── 00_geometry.png                         # image of run 00 geometry
│   ├── 01_geometry.png                         # image of run 01 geometry
│   └── 02_geometry.png                         # image of run 02 geometry
├── bin                                         # non-SPH scripts
│   ├── timelapse10                             # 10 fps ffmpeg timelapse bash script (linux/unix)
│   └── timelapse20                             # 20 fps ffmpeg timelapse bash script (linux/unix)
├── casedata.dsphdata                           # SPH synthesis of case data described by case description XML
├── CaseThwaites01_Def.xml                      # case description XML
├── DSPH_Case.FCStd                             # DesignSPHysics file used to create the initial geometry
├── DSPH_Case.FCStd1                            # DesignSPHysics file used to create the initial geometry
├── GenCase4_linux64.bi4                        # GenCase output binary file
├── GenCase4_linux64__Dp.vtk                    # GenCase output of boundary particle limits (use Paraview to display)
├── GenCase4_linux64_MkCells.vtk                # GenCase output of particle generation cells
├── GenCase4_linux64.out                        # command line output of GenCase
├── GenCase4_linux64.xml                        # GenCase synthesis xml
├── xCaseThwaites_threephase_linux64_GPU.sh     # bash script used to run all model processing steps (linux/unix version)
├── 00_*.xyz                                    # earlier versions of geometry definition files
├── z_ice_bed.xyz                               # bed and seafloor geometry XYZ-CSV from BEDMAP2
├── z_ice_bott.xyz                              # ice bottom geometry XYZ-CSV from BEDMAP2
├── z_ice_sfc.xyz                               # ice surface geometry XYZ-CSV from BEDMAP2
├── z_mw.xyz                                    # meltwater geometry XYZ-CSV
└── README.md                                   # this file
```

## References

Enderlin, E. M., & Hamilton, G. S. (2014). *Estimates of iceberg submarine melting from high-resolution digital elevation models: application to Sermilik Fjord, East Greenland*. Journal of Glaciology v. 60 no. 224. pp. 1084-1092.

Le Brocq, A. M., Le Brocq, A. M., Ross, N., Griggs, J. A., & Bingham, R. G. (2013). *Evidence from ice shelves for channelized meltwater flow beneath the antarctic ice sheet*. Nature Geoscience. 6, pages 945–948 doi:10.1038/ngeo1977
