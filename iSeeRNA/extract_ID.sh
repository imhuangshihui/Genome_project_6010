#!/bin/bash

source ~/.bashrc

## 找到lincRNA和mRNA对应的transcript ID, 后续根据ID在gff3文件中找到对应的exon作为训练iSeeRNA的Input
for i in {1..20};
do
	cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}lincRNA_id.txt
done

cat Rattus_norvegicus.Rnor_6.0.104.chromosome.X.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > XlincRNA_id.txt
cat Rattus_norvegicus.Rnor_6.0.104.chromosome.Y.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > YlincRNA_id.txt
cat Rattus_norvegicus.Rnor_6.0.104.chromosome.MT.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > MlincRNA_id.txt

cat *lincRNA_id.txt > lincRNA_ID.txt


for i in {1..20};
do
	cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}mRNA_id.txt
done

cat Rattus_norvegicus.Rnor_6.0.104.chromosome.X.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 > XmRNA_id.txt
cat Rattus_norvegicus.Rnor_6.0.104.chromosome.Y.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 > YmRNA_id.txt
cat Rattus_norvegicus.Rnor_6.0.104.chromosome.MT.gff3 | awk '$3=="mRNA"{print $9}' | cut -d ';' -f1 | cut -d ':' -f2 > MmRNA_id.txt

cat *mRNA_id.txt > mRNA_ID.txt

rm *_id.txt
