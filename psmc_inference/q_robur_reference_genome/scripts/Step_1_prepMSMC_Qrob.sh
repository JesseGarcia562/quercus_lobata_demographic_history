#! /bin/bash
#$ -cwd
#$ -l highp,h_rt=6:00:00,h_data=2G
#$ -N psmcPrep
#$ -m bae
#$ -t 1-12:1

source /u/local/Modules/default/init/modules.sh
module load java/1.8.0_111
module load python/3.4
module load perl
module load vcftools
module load samtools
module load bedtools

#negative-mask: gaps in genome fasta, Ns; missing genotypes; didn't pass filters; repeats
#mkdir -p msmcAnalysis/inputFiles
#grep Qrob_Chr0${SGE_TASK_ID} negMask.bed > negMask_chr${SGE_TASK_ID}.bed
#grep Qrob_Chr${SGE_TASK_ID} negMask.bed > negMask_chr${SGE_TASK_ID}.bed 

#obtain final snp file to prepare for msmc, separate by chrs
#vcftools --vcf biSNP.Qrob_PM1N.filtered.recode.vcf --chr Qrob_Chr0${SGE_TASK_ID} --recode --out biSNP.Qrob_PM1N.filtered.chr${SGE_TASK_ID}
#vcftools --vcf biSNP.Qrob_PM1N.filtered.recode.vcf --chr Qrob_Chr${SGE_TASK_ID} --recode --out biSNP.Qrob_PM1N.filtered.chr${SGE_TASK_ID} 
#gzip biSNP.Qrob_PM1N.filtered.chr${SGE_TASK_ID}.recode.vcf

##obtain callable sites
cd callable_sites/

#vcftools --vcf  Qrob_PM1N.allSites.rfmt.vcf --chr Qrob_Chr${SGE_TASK_ID} --remove-indels --min-meanDP 37 --max-meanDP 350 --max-missing 1 --kept-sites --out Qrob_PM1N.allSites.callable.chr${SGE_TASK_ID}
#vcftools --vcf  Qrob_PM1N.allSites.rfmt.vcf --chr Qrob_Chr0${SGE_TASK_ID} --remove-indels --min-meanDP 37 --max-meanDP 350 --max-missing 1 --kept-sites --out Qrob_PM1N.allSites.callable.chr${SGE_TASK_ID}
sed '1d' Qrob_PM1N.allSites.callable.chr${SGE_TASK_ID}.kept.sites | awk 'BEGIN{OFS="\t"} {print $1, $2-1, $2}' | sort -k1,1 -k2,2n | bedtools merge -i stdin > Qrob_PM1N.allSites.callable.chr${SGE_TASK_ID}.bed
bedtools subtract -a Qrob_PM1N.allSites.callable.chr${SGE_TASK_ID}.bed -b ../negMask_chr${SGE_TASK_ID}.bed > final.callable.good.chr${SGE_TASK_ID}.bed
#grep Qrob_Chr0${SGE_TASK_ID} callalbe_sites/final.callable.good.bed > callalbe_sites/final.callable.good.chr${SGE_TASK_ID}.bed
#grep Qrob_Chr${SGE_TASK_ID} callalbe_sites/final.callable.good.bed > callalbe_sites/final.callable.good.chr${SGE_TASK_ID}.bed

cd ..
~/bin/msmc-tools/generate_multihetsep.py --mask=callable_sites/final.callable.good.chr${SGE_TASK_ID}.bed --negative_mask negMask_chr${SGE_TASK_ID}.bed biSNP.Qrob_PM1N.filtered.chr${SGE_TASK_ID}.recode.vcf.gz > msmcAnalysis/inputFiles/chr${SGE_TASK_ID}_postMultiHetSep.txt
