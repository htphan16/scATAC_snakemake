#!/bin/bash

# define working directories
projectDir=( $(pwd) )

sbatch --nodes 1 \
       --mem=100G --time=5-00:00:00 --partition=5days \
       --output=/zata/zippy/phanh/slurm_logs/call_peaks_sm_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/call_peaks_sm_%A_%a.error \
       $projectDir/scripts/call_peaks_sm.sh $1 $2
