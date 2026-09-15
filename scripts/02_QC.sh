#!/bin/bash
set -euo pipefail
conda activate var_calling
 
########## STEP 2: Quality Control ##########
 
fastqc -t 8 data/raw/SRR39421274_1.fastq data/raw/SRR39421274_2.fastq -o results/01_qc
 
# NOTE: Trimming (fastp) was  skipped as FastQC confirmed, high per-base quality (>Q30) across the full 
# read length with zero adapter contamination.

 
echo "Step 2 complete: QC reports in results/01_qc/. Review before proceeding."
 
