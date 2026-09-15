#!/bin/bash
set -euo pipefail
conda activate var_calling

#STEP = 5 Create GATK Reference Companion Files

# A. Create the Fasta Index (.fai) and Sequence Dictionary (.dict) via GATK
samtools faidx data/reference/hg38.analysisSet.fa

gatk CreateSequenceDictionary -R data/reference/hg38.analysisSet.fa -O data/reference/hg38.analysisSet.dict


# B. variant calling with mutect2 

gatk Mutect2 \
-R data/reference/hg38.analysisSet.fa \
-I results/04_dedup/marked_duplicates.bam \
--germline-resource data/reference/af-only-gnomad.hg38.vcf.gz \
--panel-of-normals data/reference/1000g_pon.hg38.vcf.gz \
-O results/05_variants/raw_variants.vcf


 
# C. Statistical filtering of raw calls
gatk FilterMutectCalls \
  -R data/reference/hg38.analysisSet.fa \
  -V results/05_variants/raw_variants.vcf \
  -O results/05_variants/filtered_variants.vcf
 
echo "Step 5 complete: results/05_variants/filtered_variants.vcf"
