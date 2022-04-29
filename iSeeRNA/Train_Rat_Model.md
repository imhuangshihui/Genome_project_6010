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

    /home/huangsh/software/iSeeRNA-1.2.2/util/Wig2Array/auto_Wig2Array.sh /home/huangsh/software/iSeeRNA-1.2.2/wiggle /home/huangsh/software/iSeeRNA-1.2.2/consv/rn6 /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6/rn6.filter.info

## B. Prepare configure file
**a. GENOME:** split chr to chr1.fa, chr2.fa...   --- **get_fasta.py**

**b. CONSV:** chr1.array, chr2.array...

*/home/huangsh/software/iSeeRNA-1.2.2/conf/rn6.conf*

    GENOME  /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6
    CONSV   /home/huangsh/software/iSeeRNA-1.2.2/array
    SVMMODEL        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.model
    SVMPARAM        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.scale.param
## C. Train new SVM model

### a. prepare lincRNA.gff and mRNA.gff

*Download annotation file to extract lincRNA and mRNA*

Refseq non-coding RNA download from Ensemble http://asia.ensembl.org/Rattus_norvegicus/Info/Index -> Downloads -> FTP Download -> Ensemble FTP site -> [Index of /pub/current_gff3/rattus_norvegicus/]

**Rat的gff注释文件中（只含有染色体chr1 to chr20 以及 chrX, chrY, chrMT）第三列feature为lnc_RNA的有4622条，过滤之后，选出biotype=lincRNA的lincRNA为3304条; 第三列feature为mRNA的有28897条，过滤后剩28727条**

    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="lnc_RNA"{print}' | wc -l
    4622
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="lnc_RNA"{print}' | grep 'biotype=lincRNA' | wc -l
    3304
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="mRNA"{print}' | wc -l
    28897
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="mRNA"{print}' | grep 'biotype=protein_coding' | wc -l
    28727

#### 1) Extract the transcript ID of mRNA and lincRNA 提取每一条mRNA或lincRNA的转录本ID

    cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}lincRNA_id.txt 
    
    cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print $9}' | grep 'biotype=protein_coding' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}mRNA_id.txt
    
#### 2）根据每一条mRNA或lincRNA的transcript ID提取其对应的转录本:find_transcript.py

    python find_transcript.py mRNA_ID.txt Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 mRNA.proteincoding.gff
    
我们可以看到，得到的mRNA及其转录本的注释依然有不需要的feature存在

    cat mRNA.proteincoding.gff | cut -f3 | sort | uniq -c
    282948 exon
    27642 five_prime_UTR
    28727 mRNA
    21484 three_prime_UTR
    
去掉其中的five_prime_UTR & three_prime_UTR

    cat mRNA.proteincoding.gff | awk '($3=="mRNA") || ($3=="exon"){print}' > mRNA.gff
    
同理，提取lincRNA及其转录本

    python find_transcript.py lincRNA_ID.txt Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 lincRNA.gff
    

#### 3）从中选取前1000条作为模型训练输入的注释文件 1000.py

    python 1000.py
    
    output:"rna_num:  1001, line_num:  9424"
    
    cat mRNA.gff | head -n 9424 > mRNA_transcript.1000.onlychr1.gff
    
    out:"rna_num:  1001, line_num: 3517"
    
    cat lincRNA.gff | head -n 3517 > lincRNA_transcript.1000.chr1to15.gff

*需要注意的是，在mRNA.gff中，chr1共有3800条mRNA，所以提取前1000条只能选到位于1号染色体的mRNA及其转录本，不知道会不会对训练模型有影响*

*因为lincRNA比较少，所以提取前1000条时已经覆盖到了第15条染色体的lincRNA*
    
### b. trainModel.pl

*perl trainNewModel.pl -c configure_file -n lincRNA.gff -p mRNA.gff -o work_dir*

    perl util/trainNewModel.pl -c conf/rn6.conf -n lincRNA_transcript.1000.chr1to15.gff -p mRNA_transcript.1000.onlychr1.gff -o train_model_output_rn6_20220125_1843
    
    cd train_model_output_rn6_20220125_1843 && make
    
and output file like these:

![图片](https://user-images.githubusercontent.com/76728625/150964513-4cebd04f-7ba6-45b9-8aba-e1bb0305293a.png)

### f. Done. **

训练的屏幕输出结果在 train_model_output 文件夹下

After this command finishes, the output svm parameter file and svm model file are generated using the path
defined in your configuration file. This configuration file can be directly used by iSeeRNA without any
changes made.
