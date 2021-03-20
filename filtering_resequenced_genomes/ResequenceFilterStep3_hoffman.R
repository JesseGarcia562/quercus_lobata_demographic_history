#s R markdown focuses on creating a skeleton for Extracting Individuals and creating a mask of callable sites
library(data.table)
library(tidyverse)
library(glue)

(SGETaskID<-parse_integer(Sys.getenv("SGE_TASK_ID")))


folderOfFilteredChromosomes<-"/u/flashscratch/j/jessegar/FilteringResequenceHighP/"

files <- list.files(path=folderOfFilteredChromosomes, pattern="2018wgs3.ef.rmIndelRepeatsStar.chr[0-9]+.vcf", full.names = T)

df <- tibble(
       files=files,
       chromosome=parse_number(str_extract(files, pattern="chr[0-9]+"))
       )






## Step 3. Extracting individual and filter by min depth 12x


vcftools<-"/u/local/apps/vcftools/0.1.14/gcc-4.4.7/bin/vcftools"

qLobataRepeatsBed<-"/u/home/j/jessegar/project-klohmuel/reference_genome_project/Qlobata.v3.0.repeats.bed"
outputDir  <- folderOfFilteredChromosomes





individuals<-c("BER.1.00F",
"CHE.100X.00F",
"CHI.3b.00F",
"CLO.4.00F",
"CVD.8.00F",
"FHL.5.00F",
"GRV.2.00F",
"GRV.7.00F",
"HV.1.00F",
"JAS.5.00F",
"LAY.5.00F",
"LAY.6.00F",
"LYN.4.00F",
"MAR.B.00F",
"MCK.5.00F",
"MOH.3.00F",
"MTR.3.00F",
"PEN.5.00F",
"ROV.3.00F",
"SUN.5.00F",
"UKI.5.00F",
"WLT.2.00F")

filters<-tibble(
  vcftools=vcftools,
  individual=individuals
)


filters$chromosome<-filters$individual %>% map(~1:12)
filters<-filters %>% unnest(chromosome)

filters <- left_join(filters,df, by=c("chromosome"))
filters<-filters %>%
        mutate(output=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12"  )) %>%
        mutate(input=files)


filters<-filters %>%
  mutate(extractingIndividual=glue("{vcftools} --vcf {input} --indv {individual} --min-meanDP 12 --recode --recode-INFO-all --out {output}" )   )

#Works!
system(filters$extractingIndividual[SGETaskID])




