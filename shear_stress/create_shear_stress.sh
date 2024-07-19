#! /bin/bash

source ../projection_info.sh


shear_stress_grid=shear_stress.nc
gmt grdmask shear_stress_domains.shp  ${R_cart} -G${shear_stress_grid} -I${spacing} -aZ=shear_stre  -Nz



x_min=$(gmt grdinfo -F ${shear_stress_grid} | grep x_min  | awk -F':' '{print int($3)}')
x_max=$(gmt grdinfo -F ${shear_stress_grid} | grep x_max  | awk -F':' '{print int($3)}')
y_min=$(gmt grdinfo -F ${shear_stress_grid} | grep y_min  | awk -F':' '{print int($3)}')
y_max=$(gmt grdinfo -F ${shear_stress_grid} | grep y_max  | awk -F':' '{print int($3)}')


# convert to gmt formatted binary file for use in ICESHEET and create header file

bin_file="shear_stress.bin"

gmt grdconvert ${shear_stress_grid} ${bin_file}=bf 

echo ${bin_file} > ss_parameters.txt
echo ${x_min} >> ss_parameters.txt
echo ${x_max} >> ss_parameters.txt
echo ${y_min} >> ss_parameters.txt
echo ${y_max} >> ss_parameters.txt
echo ${resolution}000 >> ss_parameters.txt


# test plot to ensure conversion was correct

gmt makecpt -CSCM/lapaz -T0/200000/10000 -I > shades_shearstress.cpt

gmt begin shear_stress pdf

  gmt grdimage shear_stress.nc   -Cshades_shearstress.cpt -Q   ${J_cart} ${R_cart}
  gmt plot shear_stress_domains.shp ${J_cart} ${R_cart}  -Wthin,grey -BneWS
  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ../ice_margins/modern.shp ${R_options} ${J_options}  -Wthick,blue -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bx100000f20000+l"Basal Shear Stress (Pa)"  -Cshades_shearstress.cpt

gmt end

# create shear stress from Bedmachine values

bedmachine=../topo/bedmachine_shear_stress.nc
bedmachine_smooth=../topo/smoothed_bedmachine_shear_stress.nc

gmt grdmath ${bedmachine} ${shear_stress_grid} DENAN = bedmachine_shear_stress.nc



bin_file="bedmachine_shear_stress.bin"

gmt grdconvert bedmachine_shear_stress.nc ${bin_file}=bf 

param_file=bedmachine_ss_parameters.txt

echo ${bin_file} > ${param_file}
echo ${x_min} >> ${param_file}
echo ${x_max} >> ${param_file}
echo ${y_min} >> ${param_file}
echo ${y_max} >> ${param_file}
echo ${resolution}000 >> ${param_file}





gmt begin bedmachine_shear_stress pdf

  gmt grdimage bedmachine_shear_stress.nc   -Cshades_shearstress.cpt -Q   ${J_cart} ${R_cart}
  gmt plot shear_stress_domains.shp ${J_cart} ${R_cart}  -Wthin,grey -BneWS
  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ../ice_margins/modern.shp ${R_options} ${J_options}  -Wthick,blue -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bx100000f20000+l"Basal Shear Stress (Pa)"  -Cshades_shearstress.cpt

gmt end


