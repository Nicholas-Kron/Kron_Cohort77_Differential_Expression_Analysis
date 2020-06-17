#! /usr/bin/env bash
projdir="/scratch/projects/fieberlab/Batch77"
bbdir="${projdir}/bbduk_reads"
tempdir="${projdir}/bbtemp"


if [ ! -d ${projdir}/bbtemp ]
  then
    mkdir ${projdir}/bbtemp
fi

echo "values" > ${tempdir}/rownames.txt
tail -n12 ${bbdir}/P01_clean_report.txt | head -n7 | awk -F"reads" '{print $1}' | awk -F"\t" '{print $1}' >> ${tempdir}/rownames.txt

touch ${tempdir}/files.txt

for samp in `cat ${projdir}/samples.txt`
do
	echo "${samp}" > ${tempdir}/${samp}_vals.txt
	tail -n12 ${bbdir}/${samp}_clean_report.txt | head -n7 | awk -F"reads" '{print $1}' | awk -F"\t" '{print $2}' >> ${tempdir}/${samp}_vals.txt
	echo "${tempdir}/${samp}_vals.txt" >> ${tempdir}/files.txt
done

paste ${tempdir}/rownames.txt `cat ${tempdir}/files.txt` > ${projdir}/BBDuk_summary.txt

rm -R ${projdir}/bbtemp
