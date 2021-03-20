#!/bin/bash
#$ -cwd
#$ -l h_rt=2:30:00,h_data=25G
#$ -j y
#$ -t 1-265:1
. /u/local/Modules/default/init/modules.sh
module load gcc/4.9.3
module load R/3.5.0
module load python/2.7



R CMD BATCH --no-save --no-restore ResequenceFilterStep4AllSiteParser.R ../../data/${SGE_TASK_ID}_AllSiteParser.Rout

