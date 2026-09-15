rm(list = ls())
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
setwd("D:/Project/DNA_seq2/results/05_variants") #set according to your system 
data = read_delim("final_variant_table_clean.txt", 
                  delim = "\t")
       

colnames(data) = c("Chrom", "Pos", "Ref", "Alt", "Filter", "Gene", "Effect", "Impact","VAF")

datalong = separate_rows(data, Gene, sep = ",")

gene_count = datalong %>%
  filter(!is.na(Gene)) %>%
  count(Gene, sort = T) %>%
  head(10)



my_plot = ggplot(gene_count, aes(x=reorder(Gene , n ),y=n) ) +
  geom_bar(stat = "identity", fill="red", width = 0.7) +
  labs(
    title = "Top 10 Mutated Genes by Variant Count",
    subtitle = "Somatic variants identified via GATK Mutect2 pipeline",
    x = "Gene Name",
    y = "Number of Identified Somatic Variants"
  ) +
  coord_flip()+
  theme_minimal()
my_plot

ggsave("D:/Project/DNA_seq2/results/figures/top_mutated_genes.png", width = 8, height = 6, dpi = 300)
