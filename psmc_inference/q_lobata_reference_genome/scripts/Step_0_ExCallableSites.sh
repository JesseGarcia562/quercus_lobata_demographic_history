#!/bin/bash
#$ -cwd
#$ -l h_rt=12:00:00,h_data=2G,highp
#$ -N het
#$ -m abe

source /u/local/Modules/default/init/modules.sh
module load vcftools
module load bedtools

cd obtain_callalbe_sites/
#extract callable sites
vcftools --vcf Qlobata.v3.0.allSites.rfmt.vcf --remove-indels --min-meanDP 37 --max-meanDP 350 --recode --recode-INFO-all --max-missing 1 --out Qlobata.v3.0.allSites.callable
grep -v '#' Qlobata.v3.0.allSites.callable.recode.vcf | cut -f1-2 | awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' | sort -k1,1 -k2,2n |bedtools merge -i stdin > Qlobata.v3.0.allSites.callable.bed

