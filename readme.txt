An easy-to-use setup to run ICESHEET with the Greenland Ice Sheet, for educational purposes.


Main version of ICESHEET:

https://github.com/evangowan/icesheet

Dependencies:

To run this using the default settings (i.e. using the given projection):

- FORTRAN compiler (the Intel compiler ifort is prefered)
- Generic Mapping Tools (version >= 6.4)


If the projection or shear stress files are changed:

- ogr2ogr (this is likely required by Generic Mapping Tools anyways)

-----------------

code/ - this contains the code for ICESHEET. It must be compiled before using any of the scripts. Right now it is set up to run using the Intel fortran compiler "ifort", which is strongly recommended. Just type "make icesheet" to compile. If you want to use gfortran, you must comment out the compilation flags in the makefile. The gfortran compiled version of icesheet will run slower.

coastline/ - this contains a shapefile with the modern Greenland coastline (defined as the grounding line for marine terminating glaciers). See https://github.com/evangowan/paleo_sea_level/tree/master/GIS/Greenland_Coastline

topo/ - The script will create the topography grid file needed for ICESHEET. The files needed are already included in the repository, so the only reason to re-run it is if the topography is changed (change the file path in "topo_path.txt"), or if the projection is changed.

ice_margins/ - This contains the ice sheet margins for the maximal scneario Last Glacial Maximum (LGM) from Leger et al (2024) and the present day margin taken from Bedmachine version 5 from Morlighem, M. et al (2022 - https://doi.org/10.5067/GMEVBWFLWA7X).

shear_stress/ - The shear stress shapefile is already projected to what is in projection_info.sh to make editing easier. The script will take the values of the shear stress from the shapefile and make the grid file used by ICESHEET. The default shear stress values are tuned to fit the modern Greenland Ice Sheet, as described in Gowan et al (2021).
