#!/bin/bash

# Shaimae Elhajjajy
# January 11, 2024
# Using cell barcode annotations, generate pseudobulk bams from sample bams.
# Adapted from Shaimae's script

# Set directories
projectDir=( $(pwd) )

# Submit array job, 1 per cell type
sbatch --nodes 1 \
       --mem=100G --ntasks=8 --time=12:00:00 --partition=12hours \
       --output=/zata/zippy/phanh/slurm_logs/split_sample_bams_by_cellType_sm_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/split_sample_bams_by_cellType_sm_%A_%a.error \
       $projectDir/scripts/split_sample_bams_by_cellType_sm.sh $1 $2 $3 $4


