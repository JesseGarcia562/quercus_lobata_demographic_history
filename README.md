# Demographic History Analysis for Quercus Lobata


## Filtering Resequenced Genomes (filtering_resequenced_genomes)

The workflow to filter the resequenced Q. lobata genomes and perform PSMC' on the genomes is contained in this folder. The workflow is split into 6 steps and split into 6 .R files and 6 .sh files. The .R files use string interpolation and the R package glue to create the bash commands to run on each file. Each command is shown in the 'command' columns of the resulting data.frame and is ran with the 'system()' function in R. 


### ResequenceFilterStep1andStep2.R 

Removes indels, multiallelics, removes repeats and removes upstream indels. This is done using vcftools version 0.1.14 and grep. 


### ResequenceFilterStep3_hoffman.R

Splits the GVCF by individual and only extracts sites with a mean DP of 12. Uses vcftools/0.1.14. 

### ResequenceFilterStep4AllSiteParser.R

Creates a bed file of callable sites using bedr for each indidividual and then uses vcfAllSiteParser.py to create an preliminary input for PSMC'.

### ResequenceFilterStep5_hoffman.R

Uses mask created in Step 4 and VCF created in Step 4 with just SNPs to generate multihetsep files for PSMC' input.

### ResequenceFilterStep6_hoffman.R

Run PSMC' (MSMC Version 1.1.0) on each invidual. 
