#!/bin/bash -l
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --job-name ROCKSTAR_L1000N0900_DMO
#SBATCH --partition cosma8
#SBATCH --output ./logs/%x.%j
#SBATCH --account dp004
#SBATCH -t 01:00:00

module purge
module load gnu_comp/13.1.0 hdf5/1.12.2 openmpi/4.1.4

outbase="/snap8/scratch/dp004/dc-foro1/halo_comparison/L1000N0900/DMO_FIDUCIAL/Rockstar_exclusive"

mkdir -p $outbase
if [ -f "${outbase}/auto-rockstar.cfg" ]; then
    echo "Directory already exists. Is this a restart?"
    exit
fi

ROCKSTAR_EXE=../../../../rockstar-galaxies

# Starting master process
$ROCKSTAR_EXE -c flamingo.cfg &

# If restarting use the following instead
#$rockstar -c "${outbase}restart.cfg" &

# Wait until master process is running
until [ -f "${outbase}/auto-rockstar.cfg" ]; do
    sleep 5
done

# Launch writer processes
# Reader processes will be spawned automatically
mpirun -np $SLURM_NTASKS $ROCKSTAR_EXE -c "${outbase}/auto-rockstar.cfg"

wait
