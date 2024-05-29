#!/bin/bash

projectDir=( $(pwd) )
fastqsDir=$projectDir/$1
CR_outDir=$projectDir/10X_CR_outs
genomeDir=/zata/zippy/phanh/genomes/GRCh38_ENCODE_for_ATAC_filtered_basic
sample_bamsDir=$projectDir/$2

mkdir -p $CR_outDir

# Create the /tmp directory
mkdir -p /tmp/phanh/$SLURM_JOBID
cd /tmp/phanh/$SLURM_JOBID

# Copy data files to tmp
cp -r $fastqsDir ./
cp -r $genomeDir ./

# Run Cell Ranger for ATAC
echo "running cellranger-atac count for ..."

cellranger-atac count --id=$1"_cr_out" \
                      --reference=GRCh38_ENCODE_for_ATAC_filtered_basic \
                      --fastqs=$fastqsDir

# copy bams into appropriate directory
cp $1"_cr_out"/outs/possorted_bam.bam $sample_bamsDir

# Move files to the appropriate directory
mv $1"_cr_out" $CR_outDir

# Clean up
cd
rm -r /tmp/phanh/$SLURM_JOBID
