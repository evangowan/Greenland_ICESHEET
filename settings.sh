#! /bin/bash

######################################################
# choose the margin you want to use
######################################################

margin_folder=ice_margins

# Modern margin
scenario=modern

# Modified modern margin
#scenario=modern_mod

# Last Glacial Maximum margin
scenario=LGM

margin=${scenario}.gmt
margin_shp=${scenario}.shp



######################################################
# Topography parameters
######################################################

topo_folder=topo

# Modern topography for Greenland
topo=Greenland.bin
topo_netcdf=Greenland.nc
topo_param=elev_parameters.txt

#Bedmachine ice thickness

bedmachine_thickness=bedmachine_ice_thickness.nc

######################################################
# Basal Shear Stress parameters
######################################################

shear_stress_folder=shear_stress

# Shear stress from Gowan et al 2021
shear_stress=shear_stress.bin
shear_stress_netcdf=shear_stress.nc
shear_stress_param=ss_parameters.txt
domain_file=shear_stress_domains.shp 

# bedmachine derived shear stress
#shear_stress=bedmachine_shear_stress.bin
#shear_stress_netcdf=bedmachine_shear_stress.nc
#shear_stress_param=bedmachine_ss_parameters.txt
#domain_file=""

######################################################
# Settings for ICESHEET
######################################################

# In meters, minimum distance between flowlines in ICESHEET calculation.
# Recommended to be at maximum the grid spacing (which is 5 km in the example here)
icesheet_spacing=5000

# In m, the elevation contour interval used in ICESHEET
icesheet_interval=20

calc_ice_thickness=ice_thickness.nc

