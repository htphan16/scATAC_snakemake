#!/bin/bash

# define working directories
projectDir=( $(pwd) )

# Submit array job, 1 per cell type
sbatch --nodes 1 \
       --mem=100G --time=5-00:00:00 --partition=5days \
       --output=/zata/zippy/phanh/slurm_logs/mapping_fastqs_cr_sm_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/mapping_fastqs_cr_sm_%A_%a.error \
       $projectDir/scripts/mapping_fastqs_cr_sm.sh $1 $2
