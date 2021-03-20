library(data.table)
library(tidyverse)
library(glue)


##Step 5. Using Mask and VCFs with just SNPs to generate multihetsep files for msmc input

outputDir<-"/u/flashscratch/j/jessegar/FilteringResequenceHighP"
SGETaskID<-parse_integer(Sys.getenv("SGE_TASK_ID"))
generateMultiHetSep<-"generate_multihetsep.py"
python<-"/u/local/apps/python/3.4.3/bin/python3"

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
  individual=individuals
)
filters$chromosome<-filters$individual %>% map(~1:12)
filters<-filters %>% unnest(chromosome)
filters<-filters %>%
mutate(inputVCF=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.recode.nohomoref.vcf")) %>%
mutate(inputVCFGzipped=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.recode.nohomoref.vcf.gz")) %>%
mutate(gzipVCF=glue("gzip -fc {inputVCF} > {inputVCFGzipped}")) %>%
mutate(inputMask=glue("{outputDir}/{individual}.2018wgs3.ef.rmIndelRepeatsStar.chr{chromosome}.minDP12.bed.gz")) %>%
mutate(output=glue("{outputDir}/{individual}.2018wgs3.ef.chr{chromosome}_postMultiHetSep.txt")) %>%
mutate(command=glue("{python} {generateMultiHetSep} --mask {inputMask} {inputVCFGzipped} > {output}" ))

glue("Running: {filters$command[SGETaskID]}
     ")

#First gzip the vcf, then run generateMultiHetSep
system(filters$gzipVCF[SGETaskID])
system(filters$command[SGETaskID])

