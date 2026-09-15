#!/bin/bash
set -euo pipefail
conda activate var_calling

########## STEP 6: Functional Annotation ##########

## A = snpEff: annotate gene/effect/impact for every variant
snpEff -Xmx8g hg38 results/05_variants/filtered_variants.vcf > results/05_variants/annotated_variants.vcf
 
## B = SnpSift filter: keep only statistically trustworthy (PASS) + functionally
##     severe (HIGH/MODERATE impact) variants
SnpSift filter "(FILTER = 'PASS') & ((ANN[*].IMPACT = 'HIGH') | (ANN[*].IMPACT = 'MODERATE'))" \
  results/05_variants/annotated_variants.vcf > results/05_variants/high_impact_somatic.vcf


## C = SnpSift extractFields: flatten to a tidy table
##     -s "," keeps multi-transcript values comma-joined within one cell (fixes ragged rows)
##     -e "." marks genuinely missing values instead of leaving them blank
##     GEN[*].AF included for downstream VAF/clonality analysis 

SnpSift extractFields -s "," -e "." results/05_variants/high_impact_somatic.vcf \
  CHROM POS REF ALT FILTER "ANN[*].GENE" "ANN[*].EFFECT" "ANN[*].IMPACT" "GEN[*].AF" \
  | grep -v "^chrY" | grep -v "_random" \
  > results/05_variants/final_variant_table_clean.txt
 
echo "Pipeline complete. Final table: results/05_variants/final_variant_table_clean.txt"
 
