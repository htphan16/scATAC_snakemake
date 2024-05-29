#!/bin/bash

# Shaimae Elhajjajy
# January 11, 2024
# Using cell barcode annotations, generate pseudobulk bams from sample bams.
# Adapted from Shaimae's script

# Set directories
projectDir=( $(pwd) )
metadataDir=$projectDir/metadata
sample_bamsDir=$projectDir/$1
out_bamsDir=$projectDir/$2
annotation=$3
cell_types_file=$4

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID
mkdir -p $tmp_dir
cd $tmp_dir

# Copy files over to /tmp
cp $metadataDir/$cell_types_file ./
cp $metadataDir/$annotation ./
cp $sample_bamsDir ./

# Get list of cell types
cell_types=( $( cat $cell_types_file ) )

# Get sample info from bam file name
sample_bam=( $(ls | grep ".bam") )
bam_base=${sample_bam%".bam"}

# Print status message
echo "Splitting $sample_bam by cell type..."
echo ""

# Create output destination in /tmp
mkdir -p ./$bam_base

# Split this sample bam by cell type
for cell_type in ${cell_types[@]}
do
  # Print status message
  # This message will automatically print to the log files
  # This is one way you can check the status of a job while it is running
  echo "Extracting reads belonging to the $cell_type cell type from sample $sample ..."
  echo ""
  # Get barcodes for this cell type
  awk -v sample=$bam_base -v cell_type=$cell_type '{if (($2 == sample) && ($3 == cell_type)) print $1}' $annotation > $cell_type.barcodes.txt
  ls
  # Define output file name prefix
  out_file=$bam_base.$cell_type
  # Get bam header
  samtools view -H $sample_bam > $out_file.sam
  # Extract all reads from the bam file that belong to the set of barcodes for this cell type
  samtools view -@ 8 $sample_bam | LC_ALL=C grep -F -f $cell_type.barcodes.txt >> $out_file.sam
  # Convert to bam format
  samtools view -bSh -@ 8 $out_file.sam | samtools sort > ./$bam_base/$out_file.bam
  # Remove the sam file - it takes up a lot of memory
  rm $out_file.sam
done

# Save output
mv ./$bam_base $out_bamsDir

# get out of tmp
cd

# remove tmp
rm -r $tmp_dir


