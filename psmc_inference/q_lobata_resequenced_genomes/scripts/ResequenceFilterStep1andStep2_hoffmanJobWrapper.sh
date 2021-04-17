#!/bin/bash
#$ -cwd
#$ -l h_rt=72:00:00,h_data=3G,highp
#$ -j y
#$ -t 1-12:1
. /u/local/Modules/default/init/modules.sh
module load gcc/4.9.3
module load R/3.5.0
module load vcftools
module load bedtools/2.26.0


R CMD BATCH --no-save --no-restore ResequenceFilterStep1andStep2_hoffmanHighpChr245.R ../../data/${SGE_TASK_ID}_FilteringHighpChr245.Rout
