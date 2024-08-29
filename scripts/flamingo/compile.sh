#!/bin/bash -l

# Compiles rockstar-swift for use in COSMA
cd ../../

module purge
module load intel_comp/2024.2.0 compiler-rt tbb compiler mpi
module load hdf5

make with_hdf5
make parents
