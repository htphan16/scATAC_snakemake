#!/bin/bash

# Call peaks for pseudobulk bams using different settings of macs2/macs3

# define working directories
projectDir=( $(pwd) )
pseudobulk_bamDir=$projectDir/$1
peaksDir=$projectDir/$2
macs3=/zata/zippy/phanh/bin/anaconda3/bin/macs3

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID-$SLURM_ARRAY_TASK_ID
mkdir -p $tmp_dir
cd $tmp_dir

# copy data files to tmp
cp $pseudobulk_bamDir ./

echo "copying data files into tmp done!"
ls

# extract cell type
bam=( $(ls | grep ".bam") )
cell_type=${bam%".bam"}

#mkdir -p $cell_type"_peaks_macs2_bampe"
#echo "run macs2 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}, -f BAMPE..."
# call peaks using macs2, -f BAMPE
#singularity exec /zata/zippy/phanh/bin/archr.sif macs2 callpeak -t $cell_type.bam -f BAMPE -g hs -n $cell_type -B --SPMR -q 0.01 \
#	--keep-dup all --call-summits --cutoff-analysis \
#	--outdir $cell_type"_peaks_macs2_bampe" 2>$cell_type"_peaks_macs2_bampe"/$cell_type.macs2.bampe.log

#mkdir -p $cell_type"_peaks_macs2_shift100"
#echo "run macs2 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]} with --shift and --extsize..."
#singularity exec /zata/zippy/phanh/bin/archr.sif macs2 callpeak -t $cell_type.bam -f BAM -g hs -n $cell_type -B --SPMR -q 0.01 \
#	--nomodel --shift 100 --extsize 200 --keep-dup all --call-summits --cutoff-analysis \
#	--outdir $cell_type"_peaks_macs2_shift100" 2>$cell_type"_peaks_macs2_shift100"/$cell_type.macs2.shift100.log

#mkdir -p $cell_type"_peaks_macs3_bampe"
#echo "run macs3 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}, -f BAMPE..."
# call peaks using macs3
#$macs3 callpeak -t $cell_type.bam -f BAMPE -g hs -n $cell_type -B --SPMR -q 0.01 --keep-dup all --call-summits --cutoff-analysis \
#	--outdir $cell_type"_peaks_macs3_bampe" 2>$cell_type"_peaks_macs3_bampe"/$cell_type.macs3.bampe.log

#mkdir -p $cell_type"_peaks_macs3_shift100"
#echo "run macs3 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]} with --shift and --extsize..."
#$macs3 callpeak -t $cell_type.bam -f BAM -g hs -n $cell_type -B --SPMR -q 0.01 \
#        --nomodel --shift 100 --extsize 200 --keep-dup all --call-summits --cutoff-analysis \
#        --outdir $cell_type"_peaks_macs3_shift100" 2>$cell_type"_peaks_macs3_shift100"/$cell_type.macs3.shift100.log

mkdir -p $cell_type"_peaks"
#echo "run macs2 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."
# call peaks using macs2
#singularity exec /zata/zippy/phanh/bin/archr.sif macs2 callpeak -t $cell_type.bam -f BAM -g 2934876451 -n $cell_type -B --SPMR -q 0.01 \
#        --nomodel --shift -100 --extsize 200 --keep-dup all --nolambda --cutoff-analysis \
#        --outdir $cell_type"_peaks" 2>$cell_type"_peaks"/$cell_type.macs2.log

echo "run macs3 to call peaks for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."

$macs3 callpeak -t $cell_type.bam -f BAM -g 2934876451 -n $cell_type -B --SPMR -q 0.01 \
        --nomodel --shift -100 --extsize 200 --keep-dup all --cutoff-analysis \
        --outdir $cell_type"_peaks" 2>$cell_type"_peaks"/$cell_type.macs3.log
echo "copying data files to output directories"

# copy data files to out directories
cp -r $cell_type"_peaks" $peaksDir
echo "done"

# get out of tmp
cd

# remove tmp
rm -r $tmp_dir
