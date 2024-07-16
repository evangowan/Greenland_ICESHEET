#! /bin/bash

# The WKT string for this projection is:
# +proj=stere +lat_0=90 +lon_0=-45 +k=0.9996 +x_0=1106820.27582 +y_0=3620245.99735 +a=6378137 +rf=298.257220143428 +units=m +no_defs +type=crs

# I am using a polar stereographic projection, which has been used in many Greenland related things.
center_longitude=-45
center_latitude=90

 # grid resolution, in km!.

resolution=5

# ICESHEET needs this in meters.
spacing=${resolution}000

# corner points of the grid (if we don't use this, gmt assumes a global grid, which will be huge!
# west corresponds to the bottom left corner, east corresponds to the top right corner


west_latitude=57
west_longitude=-62
east_latitude=79
east_longitude=24

map_width=11c

shift_up="-Y5"

scale_x_shift="-X-4"

J_options="-JS${center_longitude}/${center_latitude}/${map_width}"
R_options="-R${west_longitude}/${west_latitude}/${east_longitude}/${east_latitude}r"


# shear stress domain file







gmt mapproject << END    ${R_options} ${J_options} -F  > corners.txt
${west_longitude} ${west_latitude}
${east_longitude} ${east_latitude}
END

# I needed this to calculate the offset from center, since the zero point is not at the center but rather at the bottom left corner
#gmt mapproject << END    ${R_options} ${J_options} -F -C > corners_C.txt
#${west_longitude} ${west_latitude}
#${east_longitude} ${east_latitude}
#END



r1=$(awk '{if (NR==1) print $1}' corners.txt)
r2=$(awk '{if (NR==2) print $1}' corners.txt)
r3=$(awk '{if (NR==1) print $2}' corners.txt)
r4=$(awk '{if (NR==2) print $2}' corners.txt)

# round the numbers, should only need to do this for the top left corner, really


x_min_temp=$(printf '%.0f\n' $(echo "scale=2; ${r1} / ${spacing}" | bc ) )
x_min=$(echo "${x_min_temp} * ${spacing}" | bc)
y_min_temp=$(printf '%.0f\n' $(echo "scale=2; ${r3} / ${spacing}" | bc ) )
y_min=$(echo "${y_min_temp} * ${spacing}" | bc)

x_max_temp=$(printf '%.0f\n' $(echo "scale=2; ${r2} / ${spacing}" | bc ) )
x_max=$(echo "${x_max_temp} * ${spacing}" | bc)
y_max_temp=$(printf '%.0f\n' $(echo "scale=2; ${r4} / ${spacing}" | bc ) )
y_max=$(echo "${y_max_temp} * ${spacing}" | bc)

J_cart="-JX${map_width}/0"
R_cart="-R${x_min}/${x_max}/${y_min}/${y_max}"
