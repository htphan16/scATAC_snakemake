#!/bin/bash

# define working directory
outDir=( $(pwd) )

# Submit jobs
sbatch --nodes 1 \
       --mem=32G --time=4:00:00 --partition=4hours \
       --output=/zata/zippy/phanh/slurm_logs/call_active_peaks_published_sm_%A.output \
       --error=/zata/zippy/phanh/slurm_logs/call_active_peaks_published_sm_%A.error \
       $outDir/scripts/call_active_peaks_published_sm.sh $1 $2 $3
