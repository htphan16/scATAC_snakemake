#!/bin/bash

#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --ntasks=8
#SBATCH --time=4:00:00
#SBATCH --partition=4hours
#SBATCH --output=/zata/zippy/phanh/slurm_logs/call_active_cCREs_%A_%a.output
#SBATCH --error=/zata/zippy/phanh/slurm_logs/call_active_cCREs_%A_%a.error
#SBATCH --array=[0-41]%20

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID-$SLURM_ARRAY_TASK_ID
mkdir -p $tmp_dir
cd $tmp_dir

# define working directories
projectDir=/data/projects/BICCN/snATAC
bigWigDir=$projectDir/bigWigs/broad
outDir=/zata/zippy/phanh/processed_BICCN
rDHSs_beds=$outDir/rDHSs_beds
rDHSs_filtered=$outDir/rDHSs_filtered
active_cCREs=$outDir/active_cCREs
active_bCREs=$outDir/active_bCREs
z_scores=$outDir/z_scores
bigWigAverageOverBed=/data/common/tools/ucsc.v385/bigWigAverageOverBed
registryDir=/data/projects/encode/Registry/V4/GRCh38
rdhs=$registryDir/GRCh38-Anchors.bed
ccres=$registryDir/GRCh38-cCREs.bed
bcres=$outDir/metadata/bCREs_all.bed
z_score_py=$outDir/scripts/log.zscore.normalization.py

# make directories
mkdir -p $rDHSs_beds
mkdir -p $active_cCREs
mkdir -p $rDHSs_filtered
mkdir -p $z_scores
mkdir -p $active_bCREs

# copy cell type file to tmp
cp $outDir/metadata/subclass.txt ./

# get broad cell types
cell_types_file=subclass.txt

# get cell type for each slurm job
cell_types=( $(cat $cell_types_file) )
cell_type=${cell_types[$SLURM_ARRAY_TASK_ID]}

# copy data files to tmp
cp $bigWigDir/$cell_type.bigWig ./
cp $rdhs ./
cp $ccres ./
cp $bcres ./
cp $z_score_py ./

echo "copying data files into tmp done!"
ls 

echo "run bigWigAverageOverBed to compute average signal over rDHSs for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."

# run bigWigAverageOverBed to compute average signal over rDHSs
$bigWigAverageOverBed $cell_type.bigWig GRCh38-Anchors.bed $cell_type.rDHSs.tab -bedOut=$cell_type.rDHSs.bed

echo "compute z-scores for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."
# compute z-scores
singularity exec /zata/zippy/phanh/bin/python3-R.simg python3 log.zscore.normalization.py $cell_type.rDHSs.bed > $cell_type.zscores.bed

# keep rDHSs with z-score > 1.64
awk '$2>1.64 {print $1}' $cell_type.zscores.bed > $cell_type.rDHSs_filtered.txt

echo "calling active cCREs for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."

# identify active cCREs
awk 'NR==FNR{a[$1]; next} $4 in a {print $0}' $cell_type.rDHSs_filtered.txt GRCh38-cCREs.bed > $cell_type.cCREs.bed 

echo "calling active bCREs for cell type ${cell_types[$SLURM_ARRAY_TASK_ID]}..."
# identify active bCREs
awk 'NR==FNR{a[$1]; next} $4 in a {print $0}' $cell_type.rDHSs_filtered.txt bCREs_all.bed > $cell_type.bCREs.bed 

echo "copying data files to output directories"

# copy data files to out directories
cp $cell_type.rDHSs.tab $rDHSs_beds
cp $cell_type.rDHSs.bed $rDHSs_beds
cp $cell_type.rDHSs_filtered.txt $rDHSs_filtered
cp $cell_type.zscores.bed $z_scores
cp $cell_type.cCREs.bed $active_cCREs
cp $cell_type.bCREs.bed $active_bCREs

echo "done"
# get out of tmp
cd

# remove tmp 
rm -r $tmp_dir
