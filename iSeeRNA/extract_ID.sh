#!/bin/bash

source ~/.bashrc

#for i in {1..20};
#do
#	cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="lnc_RNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}lncrna_id.txt

#done

for i in {1..17};
do
	cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 | head -219 > ${i}mrna_id.txt
done

for i in {18..20};
do
	cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 | head -218 > ${i}mrna_id.txt
done

cat Rattus_norvegicus.Rnor_6.0.104.chromosome.X.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 | head -218 > Xmrna_id.txt

cat Rattus_norvegicus.Rnor_6.0.104.chromosome.Y.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 | head -14 > Ymrna_id.txt

cat Rattus_norvegicus.Rnor_6.0.104.chromosome.MT.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 | head -13 > Mmrna_id.txt

cat *mrna_id.txt > mRNA_ID.txt



