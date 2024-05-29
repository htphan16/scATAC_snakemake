#!/bin/bash

# Shaimae Elhajjajy
# January 11, 2024
# Using cell barcode annotations, generate pseudobulk bams from sample bams.

# Set directories
projectDir=( $(pwd) )

# Submit array job, 1 per cell type
sbatch --nodes 1 \
       --mem=100G --ntasks=8 --time=12:00:00 --partition=12hours \
       --output=/zata/zippy/phanh/slurm_logs/merge_pseudobulk_bams_sm.sh_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/merge_pseudobulk_bams_sm.sh_%A_%a.error \
       $projectDir/scripts/merge_pseudobulk_bams_sm.sh $1

