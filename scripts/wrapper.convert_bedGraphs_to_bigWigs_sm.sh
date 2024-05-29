#!/bin/bash

# define working directories
projectDir=( $(pwd) )
cell_types_file=$projectDir/metadata/$2

num_cell_types=( $(wc -l $cell_types_file | cut -d " " -f 1) )
array_limit=( $( expr $num_cell_types - 1 ) )

# Submit array job, 1 per cell type
sbatch --nodes 1 --array=[0-$array_limit]%20 \
       --mem=100G --time=12:00:00 --partition=12hours \
       --output=/zata/zippy/phanh/slurm_logs/convert_bedGraphs_to_bigWigs_sm_%A_%a.output \
       --error=/zata/zippy/phanh/slurm_logs/convert_bedGraphs_to_bigWigs_sm_%A_%a.error \
       $projectDir/scripts/convert_bedGraphs_to_bigWigs_sm.sh $1 $2 $3
