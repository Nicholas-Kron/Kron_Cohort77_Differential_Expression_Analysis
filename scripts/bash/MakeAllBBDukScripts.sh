#! /usr/bin/env bash
projdir="/scratch/projects/fieberlab/Batch77"
BBDUK="/nethome/n.kron/local/bbtools/37.90"
project="fieberlab"

if [ ! -d ${projdir}/bbduk_reads ]
  then
    mkdir ${projdir}/bbduk_reads
fi

###BBDuk trimming Scripts
for samp in `cat ${projdir}/samples.txt`
do

echo "making BBDuk script for ${samp}"
echo '#!/bin/bash' > ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -P '$project'' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -J '$samp'_clean' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -e '$samp'_clean_report.txt' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -o '$samp'_clean.out' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -W 12:00' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -n 8' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -R "span[ptile=8]"' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
#echo '#BSUB -R "rusage[mem=128]"' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -u n.kron@umiami.edu' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo '#BSUB -q general'  >> ${projdir}/bbduk_reads/${samp}_BBDuk.job

#load java
echo 'module load java/1.8.0_60' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job
echo 'export _JAVA_OPTIONS="-Xmx4g -Xms1g"' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job

echo ''${BBDUK}'/bbduk.sh -Xmx1g \
in1='${projdir}'/RawReads/'${samp}'_READ1.fastq.gz \
in2='${projdir}'/RawReads/'${samp}'_READ2.fastq.gz \
out1='${projdir}'/bbduk_reads/'${samp}'_READ1_clean.fastq.gz \
out2='${projdir}'/bbduk_reads/'${samp}'_READ2_clean.fastq.gz \
ref='${BBDUK}'/resources/adapters.fa \
ktrim=r \
k=23 \
mink=8 \
hdist=1 \
tpe \
tbo \
qtrim=lr \
trimq=10 \
minlen=50 \
maq=10

rm '${projdir}'/bbduk_reads/'${samp}'_BBDuk.job' >> ${projdir}/bbduk_reads/${samp}_BBDuk.job

bsub < ${projdir}/bbduk_reads/${samp}_BBDuk.job
done
