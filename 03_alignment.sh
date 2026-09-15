#!/bin/bash
set -euo pipefail
conda activate var_calling

########## STEP 3: Genome Indexing & Alignment ##########
 
## A = Index the reference (one-time per reference genome)
bwa index data/reference/hg38.analysisSet.fa
 
## B = Align reads, injecting read-group metadata required by GATK downstream
bwa mem -t 8 \
  -R '@RG\tID:SRR39421274\tSM:BreastTumor\tPL:ILLUMINA' \
  data/reference/hg38.analysisSet.fa \
  data/raw/SRR39421274_1.fastq \
  data/raw/SRR39421274_2.fastq \
  > results/03_aligned/aligned.sam
 
echo "Step 3 complete: results/03_aligned/aligned.sam"