#!/bin/bash

# define working directories
projectDir=( $(pwd) )
peaksDir=$projectDir/$1
peaks_bigWigs=$projectDir/$3
bedGraphToBigWig=/data/common/tools/ucsc.v385/bedGraphToBigWig
bedSort=/data/common/tools/ucsc.v385/bedSort
chrom_sizes=/zata/zippy/phanh/genomes/GRCh38_EBV.chrom.sizes.tsv

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID-$SLURM_ARRAY_TASK_ID
mkdir -p $tmp_dir
cd $tmp_dir

# make target directory
mkdir -p $peaks_bigWigs

# copy cell type file to tmp
cp $projectDir/metadata/$2 ./

# get broad cell types
cell_types_file=$2

# get cell type for each slurm job
cell_types=( $(cat $cell_types_file) )
cell_type=${cell_types[$SLURM_ARRAY_TASK_ID]}

#peaks_types=($cell_type"_peaks" $cell_type"_peaks_macs2_bampe" $cell_type"_peaks_macs3_bampe" \
#	$cell_type"_peaks_macs2_shift100" $cell_type"_peaks_macs3_shift100")

peaks_types=($cell_type"_peaks")
for peaks_type in ${peaks_types[@]}
do
  # copy data files to tmp
  cp $peaksDir/$peaks_type/$cell_type"_treat_pileup.bdg" $peaks_type"_treat_pileup.bdg"
  echo "copying data files into tmp done!"

  # sort the bedGraphs
  awk '/^chr/' $peaks_type"_treat_pileup.bdg" >> $peaks_type"_treat_pileup_filtered.bdg"
  $bedSort $peaks_type"_treat_pileup_filtered.bdg" $peaks_type"_treat_pileup.sorted.bdg"
  echo "running bedGraphToBigWig to convert bedGraph into bigWig for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."
  # convert bedGraph into bigWig
  $bedGraphToBigWig $peaks_type"_treat_pileup.sorted.bdg" $chrom_sizes $peaks_type"_treat_pileup.bigWig"

  echo "copying data files to output directories"
  # copy data files to out directories
  cp $peaks_type"_treat_pileup.bigWig" $peaks_bigWigs
  echo "done"
  rm *
done

# get out of tmp
cd

# remove tmp
rm -r $tmp_dir
