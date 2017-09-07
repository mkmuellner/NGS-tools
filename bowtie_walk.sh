#!/bin/sh
# this script steps through different bowtie values for 5 prime and 3 prime trimming and collects the alignment data
#bash bowtie_walk.sh filename.fasta
rm capture.txt

for q in {0..20}
do
for i in {0..20}
do
echo $q
echo $i

five=$[i*2]
three=$[q*2]

echo $five >> capture.txt
echo $three >> capture.txt
	bowtie2 -x /home/mmuellner/workdir/BOWTIE/E06/E06 -S dummy.sam -U PAR-1-1-RV.fasta -f -5 $five -3 $three --end-to-end 2>&1 | sed '/Warning/ d' | grep -oP '\(\K[^\)]+' | tail -n +2 >> capture.txt
done
done
