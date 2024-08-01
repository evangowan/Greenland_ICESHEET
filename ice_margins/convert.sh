#! /bin/bash

# rerun this script if you change the projection

source ../projection_info.sh

for margin in LGM modern_mod modern
do

     ogr2ogr -f "GMT" -t_srs "${wkt_string}" ${margin}.gmt ${margin}.shp

done
