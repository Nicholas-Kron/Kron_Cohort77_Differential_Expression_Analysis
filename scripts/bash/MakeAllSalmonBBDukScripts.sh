#! /usr/bin/env bash
projdir="/scratch/projects/fieberlab/Batch77"
salmondir="/nethome/n.kron/local/salmon/0.11.2/bin"
project="fieberlab"
transcriptome="${projdir}/Genome/GCF_000002075.1_AplCal3.0_rna.fna.gz"
index="${projdir}/Genome/AplCal3.0_salmon_index"


if [ ! -d ${projdir}/salmon ]
  then
    mkdir ${projdir}/salmon
fi

for samp in `cat ${projdir}/samples.txt`
do
###salmon mapping Scripts

echo "making salmon script for ${samp}"
echo '#!/bin/bash' > ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -P '$project'' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -J '$samp'_quant' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -e '$samp'_quant.err' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -o '$samp'_quant.out' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -W 12:00' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -n 8' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -R "span[ptile=8]"' >> ${projdir}/salmon/${samp}_salmon.job
#echo '#BSUB -R "rusage[mem=128]"' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -u n.kron@umiami.edu' >> ${projdir}/salmon/${samp}_salmon.job
echo '#BSUB -q general'  >> ${projdir}/salmon/${samp}_salmon.job

echo ''${salmondir}'/salmon quant \
-i '${index}' \
-l ISR \
-1 '${projdir}'/bbduk_reads/'${samp}'_READ1_clean.fastq.gz \
-2 '${projdir}'/bbduk_reads/'${samp}'_READ2_clean.fastq.gz \
-p 8 \
--rangeFactorizationBins 4 \
--validateMappings \
--seqBias \
--gcBias \
-o '${projdir}'/salmon/'${samp}'_quant

rm '${projdir}'/salmon/'${samp}'_salmon.job' >> ${projdir}/salmon/${samp}_salmon.job

bsub < ${projdir}/salmon/${samp}_salmon.job
done
