#!/bin/bash

# define working directories
projectDir=( $(pwd) )

# Submit array job, 1 per cell type
sbatch --nodes 1 \
       --mem=32G --time=12:00:00 --partition=12hours \
       --output=/zata/zippy/phanh/slurm_logs/convert_bams_to_bigWigs_sm_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/convert_bams_to_bigWigs_sm_%A_%a.error \
       $projectDir/scripts/convert_bams_to_bigWigs_sm.sh $1 $2
