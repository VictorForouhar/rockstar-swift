#!/bin/bash -l

# Compiles rockstar-swift for use in COSMA
cd ../../

module load gnu_comp/13.1.0 hdf5/1.12.2 openmpi/4.1.4
make with_hdf5
make parents
