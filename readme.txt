An easy-to-use setup to run ICESHEET with the Greenland Ice Sheet, for educational purposes.

It should be possible to run everything without re-running the scripts in the topo and shear_stress folders. The workflow then is:

- compile ICESHEET
- change the values in the "settings.sh" file to use the desired files.
- run "run_icesheet.sh"
- run "plot.sh"

At the moment, there are options to use the ice sheet margins for the present day and LGM Greenland Ice Sheet. There are also options to use the basal shear stress calculated from the Bedmachine version 5 surface topography, or the model shear stress from Gowan et al (2021). Just uncomment the scenarios you want to run.


Main version of ICESHEET:

https://github.com/evangowan/icesheet

-----------------

Dependencies:

To run this using the default settings (i.e. using the given projection):

- FORTRAN compiler (the Intel compiler ifort is prefered)
- Generic Mapping Tools (version >= 6.4)


If the projection or shear stress files are changed:

- ogr2ogr (this is likely required by Generic Mapping Tools anyways)

-----------------

settings.sh - This contains the variables that you can edit to change the ice margin, topography and shear stress files, as well as the settings for ICESHEET.

run_icesheet.sh - This is the script to run ICESHEET and create the calculated ice thickness. 

plot.sh - This creates the plots after running the "run_icesheet.sh" script. It currently only plots as PDF files, so if you want PNG (or other file type) files, you have to add that option.

projection_info.sh - This contains the projection information that is shared with all of the scripts.


code/ - this contains the code for ICESHEET. It must be compiled before using the "run_icesheet.sh" script. Right now it is set up to run using the Intel fortran compiler "ifort", which is strongly recommended. Just type "make icesheet" to compile. If you want to use gfortran, you must comment out the compilation flags in the makefile. The gfortran compiled version of icesheet will run slower.

coastline/ - this contains a shapefile with the modern Greenland coastline (defined as the grounding line for marine terminating glaciers). Extracted from Bedmachine version 5. Gowan (2023) discusses why it is necessary to use this rather than the default coastline in GMT. See https://github.com/evangowan/paleo_sea_level/tree/master/GIS/Greenland_Coastline

topo/ - The script will create the topography grid file needed for ICESHEET. The files needed are already included in the repository, so the only reason to re-run it is if the topography is changed (change the file path in "topo_path.txt"), or if the projection is changed. The topography by default is ETOPO 2022. Run "create_topo.sh" to create the files. There is also a script here "extract_bedmachine.sh" that extracts the ice thickness and basal shear stress from Bedmachine (version 5). This needs to be run before running the script in the shear_stress folder if the projection or Bedmachine version is changed.

shear_stress/ - The shear stress shapefile is already projected to what is in projection_info.sh to make editing easier. This will obviously need to be reprojected should the projection be changed. The script "create_shear_stress.sh" will take the values of the shear stress from the shapefile and make the grid file used by ICESHEET. The default shear stress values are tuned to fit the modern Greenland Ice Sheet, as described in Gowan et al (2021). It will also create a file with the shear stress values calculated from Bedmachine (see the topo folder), and use the shapefile to fill in any gaps.

ice_margins/ - This contains the ice sheet margins for the maximal scneario Last Glacial Maximum (LGM) from Leger et al (2024) and the present day margin taken from Bedmachine version 5.

-----------------

References:

Bedmachine version 5 - Morlighem, M. et al (2022): https://doi.org/10.5067/GMEVBWFLWA7X
ICESHEET - Gowan et al (2016): https://doi.org/10.5194/gmd-9-1673-2016
Shear stress values from Gowan et al (2021): https://doi.org/10.1038/s41467-021-21469-w
Some info on the modelled Greenland ice sheet from Gowan (2023): https://doi.org/10.34194/geusb.v53.8355
