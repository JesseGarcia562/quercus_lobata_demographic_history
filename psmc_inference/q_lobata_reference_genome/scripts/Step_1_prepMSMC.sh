#! /bin/bash
#$ -cwd
#$ -l h_rt=1:00:00,h_data=1G,highp
#$ -N msmcPrep
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
grep chr${SGE_TASK_ID} all.masked.bed > negMask_chr${SGE_TASK_ID}.bed

#this file has indels,need to filter out using gatk first, so not doing this step.
#vcftools --gzvcf data_from_sorel/Qlobata.v3.0.filtered.vcf.gz --chr chr${SGE_TASK_ID} --max-missing 1 --remove-filtered-all --recode  --out Qlobata.v3.0.filtered.chr${SGE_TASK_ID}

#remove missing genotype sites and filtered sites, obtain final snp file to prepare for msmc
#cd obtain_callalbe_sites/
#vcftools --gzvcf snp.Qlobata.v3.0.filtered.vcf.gz --chr chr${SGE_TASK_ID} --max-missing 1 --remove-filtered-all --recode  --out snp.Qlobata.v3.0.filtered.chr${SGE_TASK_ID}
#gzip snp.Qlobata.v3.0.filtered.chr${SGE_TASK_ID}.recode.vcf

grep chr${SGE_TASK_ID} obtain_callalbe_sites/Qlobata.v3.0.allSites.callable.bed > obtain_callalbe_sites/Qlobata.v3.0.allSites.callable.chr${SGE_TASK_ID}.bed
~/bin/msmc-tools/generate_multihetsep.py --mask=obtain_callalbe_sites/Qlobata.v3.0.allSites.callable.chr${SGE_TASK_ID}.bed --negative_mask negMask_chr${SGE_TASK_ID}.bed obtain_callalbe_sites/snp.Qlobata.v3.0.filtered.chr${SGE_TASK_ID}.recode.vcf.gz > msmcAnalysis/inputFiles/chr${SGE_TASK_ID}_postMultiHetSep.txt
