#!/bin/bash

# define working directories
projectDir=( $(pwd) )
bigWigDir=$projectDir/$1
rDHSs_beds=$projectDir/rDHSs_beds
rDHSs_filtered=$projectDir/rDHSs_filtered
rDHSs_z_scores=$projectDir/rDHSs_z_scores
active_cCREs=$projectDir/active_cCREs
bigWigAverageOverBed=/data/common/tools/ucsc.v385/bigWigAverageOverBed
registryDir=/data/projects/encode/Registry/V4/GRCh38
rdhs=$registryDir/GRCh38-Anchors.bed
ccres=$registryDir/GRCh38-cCREs.bed
z_score_py=$projectDir/scripts/log.zscore.normalization.py
python3=/zata/zippy/phanh/bin/anaconda3/bin/python3

# make tmp directory and cd
tmp_dir=/tmp/phanh/$SLURM_JOBID
mkdir -p $tmp_dir
cd $tmp_dir

# make directories
mkdir -p $rDHSs_beds
mkdir -p $rDHSs_filtered
mkdir -p $rDHSs_z_scores
mkdir -p $active_cCREs

# copy data files to tmp
cp $bigWigDir ./
cp $rdhs ./
cp $ccres ./
cp $z_score_py ./

echo "copying data files into tmp done!"
ls

# extract cell type
bigWig=( $(ls | grep ".bigWig") )
cell_type=${bigWig%".bigWig"}

echo "run bigWigAverageOverBed to compute average signal over rDHSs"

# run bigWigAverageOverBed to compute average signal over rDHSs
$bigWigAverageOverBed $cell_type.bigWig GRCh38-Anchors.bed $cell_type.rDHSs.tab -bedOut=$cell_type.rDHSs.bed

echo "compute z-scores..."

# compute z-scores
#singularity exec /zata/zippy/phanh/bin/python3-r.simg python3 log.zscore.normalization.py $cell_type.rDHSs.bed > $cell_type.zscores.bed
$python3 log.zscore.normalization.py $cell_type.rDHSs.bed > $cell_type.zscores.bed

# keep rDHSs with z-score > 1.64
awk -v OFS='\t' '$2>1.64 {print $1,$2,$3}' $cell_type.zscores.bed > $cell_type.rDHSs_filtered.txt

echo "identify active_cCREs"

# identify active cCREs
awk -v FS='\t' -v OFS='\t' 'NR==FNR{a[$1] = $2 FS $3; next} ($4 in a) {print $0,a[$4]; next}' \
	$cell_type.rDHSs_filtered.txt GRCh38-cCREs.bed > $cell_type.cCREs.bed

echo "copying data files to output directories"

# copy data files to out directories
mv $cell_type.rDHSs.tab $rDHSs_beds
mv $cell_type.rDHSs.bed $rDHSs_beds
mv $cell_type.rDHSs_filtered.txt $rDHSs_filtered
mv $cell_type.zscores.bed $rDHSs_z_scores
cp $cell_type.cCREs.bed $projectDir/$2

echo "done"
# get out of tmp
cd

# remove tmp
rm -r $tmp_dir
