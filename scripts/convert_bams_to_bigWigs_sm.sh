#!/bin/bash

# define working directories
projectDir=( $(pwd) )
pseudobulk_bamDir=$projectDir/$1
pseudobulk_bigWigsDir=$projectDir/$2
bamCoverage=/zata/zippy/phanh/bin/anaconda3/bin/bamCoverage

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID
mkdir -p $tmp_dir
cd $tmp_dir

# make directories
# mkdir -p $pseudobulk_bigWigsDir

# copy data file to tmp
cp $pseudobulk_bamDir ./

echo "copying data files into tmp done!"
ls

# extract cell type
bam=( $(ls | grep ".bam") )
cell_type=${bam%".bam"}

# index bam files
samtools index $cell_type.bam $cell_type.bam.bai

echo "run bamCoverage to convert bam into bigWig for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."
# run bamCoverage to convert bam into bigWig for each cell type
$bamCoverage -b $cell_type.bam -o $cell_type.bigWig -bs 10 \
	--effectiveGenomeSize 2934876451 --minFragmentLength 40 --normalizeUsing RPGC --ignoreForNormalization chrX chrY -p 16

echo "copying data files to output directories"
# copy data files to out directories
cp $cell_type.bigWig $pseudobulk_bigWigsDir
echo "done"

# get out of tmp
cd

# remove tmp 
rm -r $tmp_dir
