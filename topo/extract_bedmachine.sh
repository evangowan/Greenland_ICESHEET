#! /bin/bash

# This script extracts the data from Bedmachine so that it can be used to compare against the modeled ice sheet.
# It can take a bit of time to run, but don't worry, the calculated NetCDF files are in the repository.

source ../projection_info.sh

bedmachine=$(cat bedmachine_path.txt)


# find grounded ice

gmt grdmath ${bedmachine}?mask 2 EQ ${bedmachine}?thickness MUL 0 DENAN = grounded_ice.nc

# switch the ice thickness to geographic coordinates

gmt grdproject grounded_ice.nc -Ggrounded_ice_ll.nc -JEPSG:3413 -R-120/20/40/90 -I -C


# projects the topography grid to the desired resolution

area_grid=bedmachine_ice_thickness.nc

gmt grdproject grounded_ice_ll.nc  ${R_options} ${J_options} -Gice_thickness_temp.nc -D${resolution}000+e -Fe  -r

gmt grdmath ice_thickness_temp.nc 0 DENAN = ${area_grid}

ice_mask=bedmachine_ice_mask.nc

gmt grdmath ${area_grid} 0 GT 0 NAN = ${ice_mask}

topo_grid=Greenland.nc
ice_surface=ice_surface.nc
ice_surface_masked=ice_surface_mask.nc

gmt grdmath ${topo_grid} ${area_grid} ADD = ${ice_surface}

gmt grdmath ${ice_surface} ${ice_mask} MUL = ${ice_surface_masked}

# Find sea level equivalent ice volume
	gmt grdmath ${area_grid} 1000 DIV ${resolution} MUL ${resolution} MUL SUM  = volume_sum.nc
	gmt grdtrack -Gvolume_sum.nc << END  | awk -v resolution=${resolution} '{print $3, $3  / 1e6, $3 * 0.917 / 361 / 1e6 * 1000}' > volume.txt
0 0
END

SLE=$(awk '{printf "%5.2f", $3}' volume.txt)

# Equation A2 from Fischer et al (1985), to solve for basal shear stress

shear_stress=bedmachine_shear_stress.nc

gmt grdmath ${ice_surface_masked} DDX SQR ${ice_surface_masked} DDY SQR ADD SQRT ${area_grid} MUL 917 MUL 9.8066 MUL = temp.nc
gmt grdmath temp.nc 5000 GT temp.nc MUL temp.nc 5000 LE 5000 MUL ADD = ${shear_stress}



# plots to check everything

# First, the ice thickness

gmt makecpt -CSCM/oslo -T0/5000/250 -I > shades.cpt
gmt begin bedmachine_ice_thickness pdf

  gmt grdimage ${area_grid} -Cshades.cpt -Q   ${J_cart} ${R_cart}

  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS

  gmt plot ../ice_margins/modern.shp ${R_options} ${J_options}  -Wthick,blue -BneWS

  gmt text << END_CAT ${J_cart} ${R_cart} -Gwhite -F+f12p+cBL -D0.15/0.15
Volume: ${SLE} m SLE
END_CAT

  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black



  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa1000f250+l"Ice thickness (m)"  -Cshades.cpt

gmt end

# Plot surface topography

gmt makecpt -Cglobe -T-5000/5000 > shades.cpt
gmt makecpt -CSCM/roma -T-4000/4000  > mask_shades.cpt

gmt begin Greenland_surface_elevation pdf,png

  gmt grdimage ${ice_surface}   -Cshades.cpt -Q   ${J_cart} ${R_cart}
  gmt grdimage ${ice_surface_masked}   -Cmask_shades.cpt -Q   ${J_cart} ${R_cart}
  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bxa2500f500+l"Elevation (m)"  -Cshades.cpt

  gmt colorbar -DJBC+w7c/0.5c+h+ -Y-2  -Bxa1000f500+l"Ice Surface Elevation (m)" -G0/4000 -Cmask_shades.cpt

gmt end

# plot shear stress


gmt makecpt -CSCM/lapaz -T0/200000/10000 -I > shades_shearstress.cpt

gmt begin bedmachine_shear_stress pdf,png

  gmt grdimage ${shear_stress}   -Cshades_shearstress.cpt -Q   ${J_cart} ${R_cart}

  gmt plot ../coastline/coastline.shp ${R_options} ${J_options}  -Wthin -BneWS
  gmt plot ../ice_margins/modern.shp ${R_options} ${J_options}  -Wthick,blue -BneWS
  gmt basemap  ${R_options} ${J_options} -Ln0.8/0.04+w500+c-43/73+f+l+ar -F+gwhite+p2p,black
  gmt colorbar -DJBC+w7c/0.5c+h+   -Bx100000f20000+l"Basal Shear Stress (Pa)"  -Cshades_shearstress.cpt

gmt end

