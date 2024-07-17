#! /bin/bash

# Load settings
source settings.sh

# load projection information
source projection_info.sh

plot_folder=plots
mkdir -p ${plot_folder}


# Plot the shear stress

gmt makecpt -CSCM/lapaz -T0/200000/10000 -I > shades_shearstress.cpt

gmt begin ${plot_folder}/shear_stress pdf

  gmt grdimage ${shear_stress_folder}/${shear_stress_netcdf}   -Cshades_shearstress.cpt -Q   ${J_cart} ${R_cart}
  if [ -n "${domain_file}" ]
  then
    gmt plot ${shear_stress_folder}/${domain_file} ${J_cart} ${R_cart}  -Wthin,grey -BneWS
  fi
  gmt plot coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ${margin_folder}/${margin_shp} ${R_options} ${J_options}  -Wthick,blue -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bx100000f20000+l"Basal Shear Stress (Pa)"  -Cshades_shearstress.cpt

gmt end


# Plot the base topography

gmt makecpt -Cglobe -T-5000/5000 > shades.cpt

gmt begin ${plot_folder}/base_topography pdf

  gmt grdimage ${topo_folder}/${topo_netcdf}   -Cshades.cpt -Q   ${J_cart} ${R_cart}
  gmt plot coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa2500f500+l"Elevation (m)"  -Cshades.cpt

gmt end

# Plot the calculated ice thickness

# Find sea level equivalent ice volume
	gmt grdmath ${calc_ice_thickness} 1000 DIV ${resolution} MUL ${resolution} MUL SUM  = volume_sum.nc
	gmt grdtrack -Gvolume_sum.nc << END  | awk -v resolution=${resolution} '{print $3, $3  / 1e6, $3 * 0.91 / 361 / 1e6 * 1000}' > volume.txt
0 0
END

SLE=$(awk '{printf "%5.2f", $3}' volume.txt)



gmt makecpt -CSCM/oslo -T0/5000/250 -I > shades.cpt

gmt begin ${plot_folder}/calculated_ice_thickness pdf

  gmt grdimage ${calc_ice_thickness} -Cshades.cpt -Q   ${J_cart} ${R_cart}

  gmt plot coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ${margin_folder}/${margin_shp} ${R_options} ${J_options}  -Wthick,blue -BneWS

  gmt text << END_CAT ${J_cart} ${R_cart} -Gwhite -F+f12p+cBL -D0.15/0.15
Volume: ${SLE} m SLE
END_CAT

  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black



  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa1000f250+l"Ice thickness (m)"  -Cshades.cpt

gmt end



# smoothed ice thickness plot with contours

gmt makecpt -CSCM/oslo -T0/5000/250 -I > shades.cpt

gmt grdfilter ${calc_ice_thickness} -Fc50000 -D0 -Gice_thickness_smooth.nc

gmt begin ${plot_folder}/calculated_ice_thickness_smooth pdf

  gmt grdimage ice_thickness_smooth.nc -Cshades.cpt -Q   ${J_cart} ${R_cart}
  gmt grdcontour ice_thickness_smooth.nc ${J_cart} ${R_cart} -Cshades_coarse.cpt -A+f5p+gwhite+fblack -W0.5p,green 
  gmt plot coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ${margin_folder}/${margin_shp} ${R_options} ${J_options}  -Wthick,blue -BneWS

  gmt text << END_CAT ${J_cart} ${R_cart} -Gwhite -F+f12p+cBL -D0.15/0.15
Volume: ${SLE} m SLE
END_CAT

  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa1000f250+l"Ice thickness (m)"  -Cshades.cpt

gmt end
