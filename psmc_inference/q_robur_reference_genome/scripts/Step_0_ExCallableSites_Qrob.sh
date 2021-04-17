#!/bin/bash
#$ -cwd
#$ -l h_rt=12:00:00,h_data=2G,highp
#$ -N callable
#$ -m abe

source /u/local/Modules/default/init/modules.sh
module load vcftools
module load bedtools

cd callalbe_sites/
sed 's/<NON_REF>/\./g' Qrob_PM1N.allSites.vcf > Qrob_PM1N.allSites.rfmt.vcf
vcftools --vcf  Qrob_PM1N.allSites.rfmt.vcf --remove-indels --min-meanDP 37 --max-meanDP 350 --recode --recode-INFO-all --max-missing 1 --out  Qrob_PM1N.allSites.callable
grep -v '#' Qrob_PM1N.allSites.callable.recode.vcf | cut -f1-2 | awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' | sort -k1,1 -k2,2n | bedtools merge -i stdin > Qrob_PM1N.allSites.callable.bed
