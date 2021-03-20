library(data.table)
library(tidyverse)
library(glue)
library(bedr)
## Step 4 Convert this vcf to bed file for the masks
vcftools<-"/u/home/j/jessegar/vcftools-vcftools-2543f81/src/cpp/vcftools"
outputDir<-"/u/flashscratch/j/jessegar/FilteringResequenceHighP"
SGETaskID<-parse_integer(Sys.getenv("SGE_TASK_ID"))
vcfAllSiteParser<-"vcfAllSiteParser.py"

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
filters<-filters %>%
mutate(inputVCF=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.recode.vcf")) %>%
mutate(outputBed=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.bed.gz")) %>%
mutate(outputVCF=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.recode.nohomoref.vcf")) %>%
mutate(command=glue("cat {inputVCF} | python {vcfAllSiteParser} chr{chromosome} {outputBed} > {outputVCF}" ))

glue("Running: {filters$command[SGETaskID]}
     ")
system(filters$command[SGETaskID])
