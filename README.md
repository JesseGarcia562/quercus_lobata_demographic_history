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

## Recreating figures in manuscript (figures/demographic_history_figures.Rmd)

In this Rmarkdown all of the code to recreate Figure 2C, 2D and Supplementary Figures S4-S10 exists. Each figure exists in its own code block. The data needed for each figure can be found in the data folder.


## Data (data)

Here the data for Figure 2C, 2D and Supplementary Figures S4-S10 are contained.


###  PSMC' Inferred Demographies On Simulations (data/msmcDemographies/200)

The multiHetSep_.txt for our simulated genomes exist in this directory. Files starting with qlobataBootstrap, qroburBootstrap, and resequenced refer to the simulations under the Q. lobata reference genome, the Q. robur reference genome, and a Q. lobata resequenced genome demography respectively. The .tsv files and .final.out refer to the final demographies inferred for these simulations. 


## PSMC' Demographies on Empirical Data

"SouthernQlobataResequenced_Nov26_2018.rds" refers to the PSMC' demography on the Q. lobata resequenced genomes and  the inference on the whole reference genome and their bootstraps exists at "bootstraps200IterationsEmpirical_Nov8.rds".


## Tajima's Pi

"pi_diversity_january_9_2020.rds" contains Tajima's Pi per 500kb windows per chromosome for the 19 resequenced genomes. 

## Heterozygosity rate

"PiPerSiteResequencedGenomes_November262019.rds" contains the amount of heterozygous sites in 500kb windows. 

## Heterozygosity per generation simulated

"../data/demographies200IterationsPi_Jan2_2018.rds" contains the predicted heterozgyosity for 1Mb regions for all 40 models for each genome type.

## Heterozygosity of best trimmed models

"../data/qlobataBootstrap200Iterations_row32_120iterations.rds", "../data/resequenced200Iterations_row28_120iterations.rds", and "../data/qroburBootstrap200Iterations_row32_120iterations.rds" contain the heterozygosity of 1Mb regions of best trimmed models.


# More information

More information and methods for each data set can be found at "High quality genome and methylomes illustrate features underlying evolutionary success of oaks" Sork et. al 2021.





