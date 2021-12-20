>UCSC Genome Browser assembly ID: rn6
>
>Sequencing/Assembly provider ID: RGSC Rnor_6.0
>
>Assembly date: Jul. 2014
>
>Accession ID: GCA_000001895.4
>
>NCBI Genome ID: 73 (Rattus norvegicus)
>
>NCBI Assembly ID: 191871 (Rnor_6.0)
>
>NCBI BioProject ID: 10629

# Target: Use iSeeRNA to train new species model, and put it to Sebnif to filter transcript gtf and predict new non-coding RNA
## A. Prepare conservation array directory
**a. info file:** The 1st col is the chromosome name, and 2nd is the length -- **cal_chr_length.pl**

**b. wiggle file:** download from [UCSC](https://genome-asia.ucsc.edu/cgi-bin/hgTracks?db=rn6&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1%3A80607368%2D80638076&hgsid=758048143_f7VNKMTH3nKj2AgUIFwzgHbfYayO) -> Comparative Genomics -> Conservation -> [PhastCons conservation (WIG format)](http://hgdownload.soe.ucsc.edu/goldenPath/rn6/phastCons20way/) -> rn6.phastCons20way.wigFix.gz

slpit wiggle file to chr1..20..XYM (/home/huangsh/software/iSeeRNA-1.2.2/wiggle)

**c. wig2ary:**

*user@linux$ util/Wig2Array/auto_Wig2Array.sh  /path/to/wiggle/ /path/for/array/ /file/of/genome/info*

    /home/huangsh/software/iSeeRNA-1.2.2/util/Wig2Array/auto_Wig2Array.sh /home/huangsh/software/iSeeRNA-1.2.2/wiggle /home/huangsh/software/iSeeRNA-1.2.2/array /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6/rn6.filter.info

## B. Prepare configure file
**a. GENOME:** split chr to chr1.fa, chr2.fa...   --- **get_fasta_jessie.py**

**b. CONSV:** chr1.array, chr2.array...

*/home/huangsh/software/iSeeRNA-1.2.2/conf/rn6.conf*

    GENOME  /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6
    CONSV   /home/huangsh/software/iSeeRNA-1.2.2/array
    SVMMODEL        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.model
    SVMPARAM        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.scale.param
## C. Train new SVM model
**a. prepare lncRNA.gff and mRNA.gff**

*Download annotation file to extract lncRNA and mRNA*

Refseq non-coding RNA download from Ensemble http://asia.ensembl.org/Rattus_norvegicus/Info/Index -> Downloads -> FTP Download -> Ensemble FTP site -> [Index of /pub/current_gff3/rattus_norvegicus/]

**染色体中的lnc_RNA总数为4622条，lincRNA为3304条（去掉了冗余部分），mRNA为28897条**

**(b)提前根据ID提取，而是用所有ID得到总的lncRNA.gff文件再从中提取1000条的话，可用**1000.py**

    python 1000.py
    
    output:"rna_num:  1001, line_num:  10927"
    
    cat mRNA.gff | head -n 10927 > 1000mRNA.gff
    
去掉mRNA.gff中的five_prime_UTR & three_prime_UTR

    cat 1000mRNA.gff | awk '{if($3!~"^five"){print $0}}' | awk '{if($3!~"^three"){print $0}}' > mRNA1000.gff

**b. extract gene ID of lnc_RNA： extract_ID.sh**

    cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}lincRNA_id.txt
    
**c. extract lncRNA and its exon based on ID: find_lncRNA.py(recommend)**

*another way is to use grep: find_lncRNA.sh(slow)*

**d. Due to the chromosome name is not identical with the genome, we need to change it: cn.py**

    1       ensembl lnc_RNA 396700  409676  .       +       .       ID=transcript:ENSRNOT00000044187;Parent=gene:ENSRNOG00000046319;Name=AABR07000046.1-202;biotype=processed_transcript;transcript_id=ENSRNOT00000044187;version=4
    
**to**

    chr1    ensembl lnc_RNA 396700  409676  .       +       .       ID=transcript:ENSRNOT00000044187;Parent=gene:ENSRNOG00000046319;Name=AABR07000046.1-202;biotype=processed_transcript;transcript_id=ENSRNOT00000044187;version=4
    
**e. trainModel.pl**

*perl trainNewModel.pl -c configure_file -n lincRNA.gff -p mRNA.gff -o work_dir*

    perl /home/huangsh/software/iSeeRNA-1.2.2/util/trainNewModel.pl -c /home/huangsh/software/iSeeRNA-1.2.2/conf/rn6.conf -n /home/huangsh/data/rat/ensemble/lncRNA.gff -p /home/huangsh/data/rat/ensemble/mRNA.gff -o /home/huangsh/software/iSeeRNA-1.2.2/3train_rn6/
    
    cd 3train_rn6 && make
    
and output file like these:

![图片](https://user-images.githubusercontent.com/76728625/138637817-83271c7f-9ac7-4df1-b7d0-76278e893234.png)

**f. Done. **
After this command finishes, the output svm parameter file and svm model file are generated using the path
defined in your configuration file. This configuration file can be directly used by iSeeRNA without any
changes made.
