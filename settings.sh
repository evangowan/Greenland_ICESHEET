#! /bin/bash

######################################################
# choose the margin you want to use
######################################################

margin_folder=ice_margins

# Modern margin
margin=modern.gmt
margin_shp=modern.shp

# Last Glacial Maximum margin
#margin=LGM.gmt
#margin_shp=LGM.shp


######################################################
# Topography parameters
######################################################

topo_folder=topo

# Modern topography for Greenland
topo=Greenland.bin
topo_netcdf=Greenland.nc
topo_param=elev_parameters.txt


######################################################
# Basal Shear Stress parameters
######################################################

shear_stress_folder=shear_stress

# Shear stress from Gowan et al 2021
shear_stress=shear_stress.bin
shear_stress_netcdf=shear_stress.nc
shear_stress_param=ss_parameters.txt

# blank out this variable if you are not using domain polygons
domain_file=shear_stress_domains.shp

######################################################
# Settings for ICESHEET
######################################################

# In meters, minimum distance between flowlines in ICESHEET calculation.
# Recommended to be at maximum the grid spacing (which is 5 km in the example here)
icesheet_spacing=5000

# In m, the elevation contour interval used in ICESHEET
icesheet_interval=20

calc_ice_thickness=ice_thickness.nc

