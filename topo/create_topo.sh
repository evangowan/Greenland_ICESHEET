#! /bin/bash

# This creates the topography and header files that are needed by ICESHEET. This also creates a test plot.
# This needed to be re-run if the variables in projection_info.sh are changed

# put the path to ETOPO2022 in topo_path.txt
original_topo=$(cat topo_path.txt)


region=Greenland

source ../projection_info.sh


# cut out the region of interest to save time
topo=cut_topo.nc
gmt grdcut ${original_topo} -G${topo} -R-120/20/40/90


area_grid=${region}.nc



# projects the topography grid to the desired resolution
gmt grdproject ${topo}  ${R_options} ${J_options} -G${area_grid} -D${resolution}000+e -Fe  -r -V




x_min=$(gmt grdinfo -F ${area_grid} | grep x_min  | awk -F':' '{print int($3)}')
x_max=$(gmt grdinfo -F ${area_grid} | grep x_max  | awk -F':' '{print int($3)}')
y_min=$(gmt grdinfo -F ${area_grid} | grep y_min  | awk -F':' '{print int($3)}')
y_max=$(gmt grdinfo -F ${area_grid} | grep y_max  | awk -F':' '{print int($3)}')


# convert to gmt formatted binary file for use in ICESHEET and create header file

bin_file="${region}.bin"

gmt grdconvert ${area_grid} ${bin_file}=bf 

echo ${bin_file} > elev_parameters.txt
echo ${x_min} >> elev_parameters.txt
echo ${x_max} >> elev_parameters.txt
echo ${y_min} >> elev_parameters.txt
echo ${y_max} >> elev_parameters.txt
echo ${resolution}000 >> elev_parameters.txt



# test plot to ensure conversion was correct

gmt makecpt -Cglobe -T-5000/5000 > shades.cpt

gmt begin ${region}_elevation pdf

  gmt grdimage ${area_grid}   -Cshades.cpt -Q   ${J_cart} ${R_cart}
  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa2500f500+l"Elevation (m)"  -Cshades.cpt

gmt end

