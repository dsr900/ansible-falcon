#!/usr/bin/env bash

#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28
#SBATCH --time=1:00:00

unset SBATCH_EXPORT
module load nextflow

which conda

nextflow run falcon/main.nf -profile conda
