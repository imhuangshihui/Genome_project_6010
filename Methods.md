**(1 Raw reads processing

fastp -i ${sample_name}_1.fq.gz -I ${sample_name}_2.fq.gz -o ${sample_name}.clean1.fq.gz -O ${sample_name}.clean2.fq.gz

**(2 Mapping

hisat2 –p 6 –dta-cufflinks –rna-strandness RF –x index -1 G941_1.fq.gz -2 G942_2.fq.gz –S G941.hisat2.sam

samtools sort -@ 6 –o G941.hisat2.bam G941.hisat2.sam

**(3 Assembly

cufflinks –p 12 –u –library-type fr-firststrand –o ./G941 G941.hisat2.bam

**(4 training new species model by using iSeeRNA 

See more details in iSeeRNA directory

**(5 Predict lincRNA by using sebnif

sebnif -g rn6 -r RefSeq -X gamma -o sebnif_G942_1_20220428 /home/huangsh/3_Assembly/cufflink_all/G942/G942_transcript.only_chr.gtf


