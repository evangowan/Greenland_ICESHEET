#! /bin/bash

# if ICESHEET is not in a place visible by ${PATH}, add it here
icesheet_path=$(pwd)/code
PATH=${PATH}:${icesheet_path}

source settings.sh

# Split the margin into individual polygons for ICESHEET
# make temp folder
temp_margin_folder=margins
rm -R -f ${temp_margin_folder}
mkdir ${temp_margin_folder}

# strip out the attributes
awk '{if ($1!="#") print $0 }' ${margin_folder}/${margin} > ${temp_margin_folder}/temp.gmt


awk -v margin_folder=${temp_margin_folder} '/>/{x=++i;next}{print > margin_folder"/split_margin."x;}' ${temp_margin_folder}/temp.gmt
rm ${temp_margin_folder}/temp.gmt


# Copy the elevation and shear stress files here, will be deleted later
cp ${topo_folder}/${topo} .
cp ${topo_folder}/${topo_param} .

cp ${shear_stress_folder}/${shear_stress} .
cp ${shear_stress_folder}/${shear_stress_param} .


# Create temporary folder to create the calculated ice elevation contours
reconstruction_folder=contours
rm -R -f ${reconstruction_folder}
mkdir ${reconstruction_folder}



log_file="icesheet_run.log"
rm -f ${log_file}
thickness_dump_file=ice_thickness.txt
rm -f ${thickness_dump_file}

counter=0

for margin_file in $( ls margins/split_margin.* )
do

	counter=$( echo "${counter} + 1" | bc )

	cat << END_params > params.txt
${margin_file}
${topo_param}
${shear_stress_param}
${icesheet_interval}
${icesheet_spacing}
END_params

	# run ICSHEET
	echo "start time" >> ${log_file}
	date >> ${log_file}

	icesheet >> ${log_file}

	echo "end time" >> ${log_file}
	date >> ${log_file}

	if [ ! -e contours.txt ]
	then
		pwd
		echo "icesheet failed to run"
		exit 0
	fi

	cp contours.txt ${reconstruction_folder}/${counter}.contours
	rm contours-rejected.txt 

	gawk '{ if ($1 == ">" ){ } else {print $1, $2, $4}}' ${reconstruction_folder}/${counter}.contours >> ${thickness_dump_file}

	echo "finished: ${margin_file}"

done

# now create the Netcdf files for plotting and analysis

# load projection information
source projection_info.sh

# mask for the ice sheet
gmt grdmask ${margin_folder}/${margin} -I${spacing} -R${x_min}/${x_max}/${y_min}/${y_max} -Gmask.nc

# creates the ice thickness from the ICESHEET output
gmt blockmedian ${thickness_dump_file} ${R_cart} -I${spacing}=   -C  > reconstruction_thickness.txt
gmt surface reconstruction_thickness.txt -Gice_thickness_raw.nc -I${spacing} ${R_cart} -T0.25  

# masks out spurious output from the surface program
gmt grdmath ice_thickness_raw.nc mask.nc MUL = ${calc_ice_thickness}


