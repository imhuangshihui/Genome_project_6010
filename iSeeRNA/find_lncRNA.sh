#!/bin/bash

source ~/.bashrc

cat lnc_RNA_ID.txt | while read id;
do
	grep $id GCF_000001895.5_Rnor_6.0_genomic.gff >> lncRNA.gff
done
