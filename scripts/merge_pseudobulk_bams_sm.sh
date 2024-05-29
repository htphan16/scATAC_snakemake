#!/bin/bash

# Shaimae Elhajjajy
# January 11, 2024
# Using cell barcode annotations, generate pseudobulk bams from sample bams.
# Adapted from Shaimae's script

# Set directories
projectDir=( $(pwd) )
metadataDir=$projectDir/metadata
bamsDir=$projectDir/bams/bySamples.cellTypes
pseudobulk_bamsDir=$projectDir/$1

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID
mkdir -p $tmp_dir
cd $tmp_dir

# Get list of samples
samples=( $( ls $bamsDir ) )
cell_type_bam=( $(echo $pseudobulk_bamsDir | awk -F"/" '{print $NF}') )
cell_type=${cell_type_bam%".bam"}

# Copy cell type bams from each sample over to /tmp
for sample in ${samples[@]}
do
  cp $bamsDir/$sample/`ls $bamsDir/$sample | grep "\.$cell_type\.bam"` ./
done

# Print status message
echo "Merging $cell_type bams across all samples..."
echo ""

# Perform the merge
samtools merge --threads 8 $cell_type.bam *.$cell_type.bam

# Save output
cp $cell_type.bam $pseudobulk_bamsDir

# get out of tmp
cd

# remove tmp
rm -r $tmp_dir


