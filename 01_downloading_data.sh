#!/bin/bash
set -euo pipefail
########## STEP 1: Environment Setup & Data Downloading ##########
 
# Create and activate the conda environment
conda env create -f environment.yml
conda activate var_calling 


# A-Raw file
##Directory structure initialiation, set up organized folder structure to separate raw data, reference databases, and intermediate analysis outputs.
mkdir data data/reference data/raw results results/01_qc results/02_trimmed results/03_aligned results/04_dedup results/05_variants

## Navigate to raw data directory
cd data/raw

##Prefetch the packed SRA archive 
prefetch SRR39421274 --progress

##Extract into paired-end Fastq files
fasterq-dump --split-3 SRR39421274 --progress

#B- Reference file 
cd ..
cd reference 
wget -c https://hgdownload.gi.ucsc.edu/goldenPath/hg38/bigZips/analysisSet/hg38.analysisSet.fa.gz
gunzip -k hg38.analysisSet.fa.gz

# C — Mutect2 resources: germline population frequencies (gnomAD)
wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/somatic-hg38/af-only-gnomad.hg38.vcf.gz
wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/somatic-hg38/af-only-gnomad.hg38.vcf.gz.tbi
 
## D — Mutect2 resources: Panel of Normals 
wget -c https://storage.googleapis.com/gatk-best-practices/somatic-hg38/1000g_pon.hg38.vcf.gz
wget -c https://storage.googleapis.com/gatk-best-practices/somatic-hg38/1000g_pon.hg38.vcf.gz.tbi

cd ../..
 
echo "Step 1 complete: raw reads + reference + Mutect2 resources downloaded."