#!/bin/bash
#$ -cwd
#$ -l h_rt=6:00:00,h_data=4G
#$ -j y
#$ -t 1-265:1
. /u/local/Modules/default/init/modules.sh
module load gcc/4.9.3
module load R/3.5.0
module load vcftools
module load bedtools/2.26.0


R CMD BATCH --no-save --no-restore ResequenceFilterStep3_hoffman.R ../../data/${SGE_TASK_ID}_Step3.Rout

