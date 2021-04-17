#! /bin/bash
#$ -cwd
#$ -l h_rt=1:00:00,h_data=4G,highp
#$ -N msmc
#$ -pe shared 4
#$ -m abe

# run MSMC with default settings (for now)

source /u/local/Modules/default/init/modules.sh
module load python/3.4 ## has to be 3.4! otherwise won't work. 



rundate=`date +%Y%m%d` # msmc rundate 
OUTDIR=msmcAnalysis/output_${rundate}
mkdir -p $OUTDIR

INPUTDIR=msmcAnalysis/inputFiles

~/bin/msmc/msmc -t 16 -o $OUTDIR/oak.msmc.out $INPUTDIR/chr*_postMultiHetSep.txt

