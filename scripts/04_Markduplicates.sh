#!/bin/bash
set -euo pipefail
conda activate var_calling
 
########## STEP 4: SAM to BAM, Sort, Index, Mark Duplicates ##########
 
## A = Convert SAM to BAM
samtools view -@ 8 -Sb results/03_aligned/aligned.sam -o results/03_aligned/aligned.bam
 
## B = Coordinate-sort the BAM
samtools sort -@ 8 results/03_aligned/aligned.bam > results/03_aligned/sorted.bam
 
## C = Index the sorted BAM
samtools index results/03_aligned/sorted.bam
 
 ## D =Mark PCR duplicates (flagged, not removed = Mutect2 uses this info in its noise model)
gatk MarkDuplicates \
  -I results/03_aligned/sorted.bam \
  -O results/04_dedup/marked_duplicates.bam \
  -M results/04_dedup/marked_dup_metrics.txt \
  --REMOVE_DUPLICATES false
 
## E = Index the deduplicated BAM
samtools index results/04_dedup/marked_duplicates.bam
 
echo "Step 4 complete: results/04_dedup/marked_duplicates.bam"
 
