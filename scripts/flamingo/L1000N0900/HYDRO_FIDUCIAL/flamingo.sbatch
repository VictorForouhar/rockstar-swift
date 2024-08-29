#!/bin/bash -l
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --job-name ROCKSTAR_L1000N1800_HYDRO
#SBATCH --partition cosma8
#SBATCH --output ./logs/%x.%j
#SBATCH --account dp004
#SBATCH -t 01:00:00

module purge
module load intel_comp/2024.2.0 compiler-rt tbb compiler mpi
module load hdf5

outbase="/snap8/scratch/dp004/dc-foro1/halo_comparison/L1000N0900/HYDRO_FIDUCIAL/ROCKSTAR"

mkdir -p $outbase
if [ -f "${outbase}/auto-rockstar.cfg" ]; then
    echo "Directory already exists. Is this a restart?"
    exit
fi

ROCKSTAR_EXE=../../../../rockstar-galaxiess

# Starting master process
$ROCKSTAR_EXE -c flamingo.cfg &

# If restarting use the following instead
#$rockstar -c "${outbase}restart.cfg" &d

# Wait until master process is running
until [ -f "${outbase}/auto-rockstar.cfg" ]; do
    sleep 5
done

# Launch writer processes
# Reader processes will be spawned automatically
mpirun -np $SLURM_NTASKS $ROCKSTAR_EXE -c "${outbase}/auto-rockstar.cfg"

wait
