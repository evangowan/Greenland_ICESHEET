FC = ifort

# If using gfortran, use this
FCFLAGS = -O2

# if compiling with the Intel Fortran compiler, you need to add an extra flag. Using the Intel fortran compiler is strongly recommended!
FCFLAGS = -O2 -assume byterecl

objfiles =  global_parameters.o grids.o read_icefile.o  find_flowline_fisher_adaptive_4.o flowline_location.o 



icesheet: icesheet.f90 $(objfiles)
	$(FC) -o icesheet $(FCFLAGS) icesheet.f90 $(objfiles)

global_parameters.o: global_parameters.f90
	$(FC) -o global_parameters.o $(FCFLAGS) -c global_parameters.f90

grids.o: grids.f90
	$(FC) -o grids.o $(FCFLAGS) -c grids.f90

read_icefile.o: read_icefile.f90
	$(FC) -o read_icefile.o $(FCFLAGS) -c read_icefile.f90

find_flowline_fisher_adaptive_4.o: find_flowline_fisher_adaptive_4.f90
	$(FC) -o find_flowline_fisher_adaptive_4.o $(FCFLAGS) -c find_flowline_fisher_adaptive_4.f90

flowline_location.o: flowline_location.f90
	$(FC) -o flowline_location.o $(FCFLAGS) -c flowline_location.f90


