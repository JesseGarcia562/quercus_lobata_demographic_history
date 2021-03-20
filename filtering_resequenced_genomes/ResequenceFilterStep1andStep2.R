library(data.table)
library(tidyverse)
library(glue)


## Step 1. Remove indels, multiallelics, remove repeats. Run on Hoffman

SGETaskID<-parse_integer(Sys.getenv("SGE_TASK_ID"))



vcftools<-"/u/local/apps/vcftools/0.1.14/gcc-4.4.7/bin/vcftools"
resequencedVCF<-"/u/home/j/jessegar/project-klohmuel/reference_genome_project/allSites"
qLobataRepeatsBed<-"/u/home/j/jessegar/project-klohmuel/reference_genome_project/Qlobata.v3.0.repeats.bed"
outputDir<-"/u/flashscratch/j/jessegar/FilteringResequenceHighP"

filters<-tibble(
  chromosome=1:12,
  vcftools=vcftools,
  resequencedVCF=glue("{resequencedVCF}/2018wgs3.allSites.chr{chromosome}.vcf.gz"),
  qLobataRepeatsBed=qLobataRepeatsBed
)


filters<-filters %>% 
  mutate(output=glue("{outputDir}/2018wgs3.ef.rmIndelRepeats.chr{chromosome}")) %>%
  mutate(command=glue("{vcftools} --gzvcf {resequencedVCF} --remove-indels --recode --recode-INFO-all --chr chr{chromosome} --exclude-bed {qLobataRepeatsBed} --min-alleles 1 --max-alleles 2 --out {output}"))
library(data.table)
library(tidyverse)
library(glue)


## Step 1. Remove indels, multiallelics, remove repeats. Run on Hoffman

SGETaskID<-parse_integer(Sys.getenv("SGE_TASK_ID"))



vcftools<-"/u/local/apps/vcftools/0.1.14/gcc-4.4.7/bin/vcftools"
resequencedVCF<-"/u/home/j/jessegar/project-klohmuel/reference_genome_project/allSites"
qLobataRepeatsBed<-"/u/home/j/jessegar/project-klohmuel/reference_genome_project/Qlobata.v3.0.repeats.bed"
outputDir<-"/u/flashscratch/j/jessegar/FilteringResequenceHighP"

filters<-tibble(
  chromosome=1:12,
  vcftools=vcftools,
  resequencedVCF=glue("{resequencedVCF}/2018wgs3.allSites.chr{chromosome}.vcf.gz"),
  qLobataRepeatsBed=qLobataRepeatsBed
)


filters<-filters %>% 
  mutate(output=glue("{outputDir}/2018wgs3.ef.rmIndelRepeats.chr{chromosome}")) %>%
  mutate(command=glue("{vcftools} --gzvcf {resequencedVCF} --remove-indels --recode --recode-INFO-all --chr chr{chromosome} --exclude-bed {qLobataRepeatsBed} --min-alleles 1 --max-alleles 2 --out {output}"))


glue("Running command: {filters$command[SGETaskID]}

	")


system(filters$command[SGETaskID])



## Step 2. Removing upstream Indels

filters<-filters %>% 
  mutate(commandToRemoveUpstreamIndels=glue("grep -vw '\\*' {output}.recode.vcf > {outputDir}/2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.vcf" )   ) 



glue("Running command: {filters$commandToRemoveUpstreamIndels[SGETaskID]}

	")

system(filters$commandToRemoveUpstreamIndels[SGETaskID])

