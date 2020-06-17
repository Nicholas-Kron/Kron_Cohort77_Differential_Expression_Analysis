#! /usr/bin/env bash

#BSUB -P fieberlab
#BSUB -q general

for samp in `cat ~/projspace/Batch77/samples.txt`
do
FILES=`ls ~/projects/Batch77/R352-L*/L*-${samp}-READ1.fastq.gz`
cat ${FILES} > ~/projspace/Batch77/RawReads/${samp}_READ1.fastq.gz
FILES=`ls ~/projects/Batch77/R352-L*/L*-${samp}-READ2.fastq.gz`
cat ${FILES} > ~/projspace/Batch77/RawReads/${samp}_READ2.fastq.gz
done
