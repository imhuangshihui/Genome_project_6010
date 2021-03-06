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

**Rat???gff????????????????????????????????????chr1 to chr20 ?????? chrX, chrY, chrMT????????????feature???lnc_RNA??????4622???????????????????????????biotype=lincRNA???lincRNA???3304???; ?????????feature???mRNA??????28897??????????????????28727???**

    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="lnc_RNA"{print}' | wc -l
    4622
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="lnc_RNA"{print}' | grep 'biotype=lincRNA' | wc -l
    3304
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="mRNA"{print}' | wc -l
    28897
    
    cat Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 | awk '$3=="mRNA"{print}' | grep 'biotype=protein_coding' | wc -l
    28727

#### 1) Extract the transcript ID of mRNA and lincRNA ???????????????mRNA???lincRNA????????????ID

    cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="lnc_RNA"{print $9}' | grep 'lincRNA' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}lincRNA_id.txt 
    
    cat Rattus_norvegicus.Rnor_6.0.104.chromosome.${i}.gff3 | awk '$3=="mRNA"{print $9}' | grep 'biotype=protein_coding' | cut -d ';' -f1 | cut -d ':' -f2 > ${i}mRNA_id.txt
    
#### 2??????????????????mRNA???lincRNA???transcript ID???????????????????????????:find_transcript.py

    python find_transcript.py mRNA_ID.txt Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 mRNA.proteincoding.gff
    
??????????????????????????????mRNA?????????????????????????????????????????????feature??????

    cat mRNA.proteincoding.gff | cut -f3 | sort | uniq -c
    282948 exon
    27642 five_prime_UTR
    28727 mRNA
    21484 three_prime_UTR
    
???????????????five_prime_UTR & three_prime_UTR

    cat mRNA.proteincoding.gff | awk '($3=="mRNA") || ($3=="exon"){print}' > mRNA.gff
    
???????????????lincRNA???????????????

    python find_transcript.py lincRNA_ID.txt Rattus_norvegicus.Rnor_6.0.104.chr.chr_ver.gff3 lincRNA.gff
    

#### 3??????????????????1000?????????????????????????????????????????? 1000.py

    python 1000.py
    
    output:"rna_num:  1001, line_num:  9424"
    
    cat mRNA.gff | head -n 9424 > mRNA_transcript.1000.onlychr1.gff
    
    out:"rna_num:  1001, line_num: 3517"
    
    cat lincRNA.gff | head -n 3517 > lincRNA_transcript.1000.chr1to15.gff

*????????????????????????mRNA.gff??????chr1??????3800???mRNA??????????????????1000?????????????????????1???????????????mRNA????????????????????????????????????????????????????????????*

*??????lincRNA???????????????????????????1000???????????????????????????15???????????????lincRNA*
    
### b. trainModel.pl

*perl trainNewModel.pl -c configure_file -n lincRNA.gff -p mRNA.gff -o work_dir*

    perl util/trainNewModel.pl -c conf/rn6.conf -n lincRNA_transcript.1000.chr1to15.gff -p mRNA_transcript.1000.onlychr1.gff -o train_model_output_rn6_20220125_1843
    
    cd train_model_output_rn6_20220125_1843 && make
    
and output file like these:

![??????](https://user-images.githubusercontent.com/76728625/150964513-4cebd04f-7ba6-45b9-8aba-e1bb0305293a.png)

?????????????????????????????? train_model_output ????????????

After this command finishes, the output svm parameter file and svm model file are generated using the path
defined in your configuration file. This configuration file can be directly used by iSeeRNA without any
changes made.

## D. Use one of the samples(G941) to test the rat model

*user@linux$ perl iSeeRNA -c CONFIGURATION_FILE -i INPUT_ANNOTATION -o OUTPUT_DIRECTORY*

This command will instruct iSeeRNA to load the file CONFIGURATION_FILE as
configuration file (-c option), to use INPUT_ANNOTATION as input annotation
file (-i option) and to create sub-directories, makefile and other required
files in the OUTPUT_DIRECTORY (-o option).The input GTF/GFF files for iSeeRNA 
can be generated from the output file of
de novo transcript assembly program such as Cufflinks.

    perl ./iSeeRNA -c conf/rn6.conf -i /home/huangsh/3_Assembly/cufflink_all/G941/transcript.only_chr.gtf -o iseerna_test_G941_1_20220423/
    
The main output of the prediction is "example.result" which has three
fields separated by tab. The first field is the transcript ID, the second
is the predicted types of the transcripts (noncoding or coding), and the third
field is the probability of the predicted category of transcripts specified
in the field two. The score is a number ranging from 0 to 1 and if the
prediction is 'coding', the score should be less than 0.5 and noncoding otherwise.
If the prediction is 'noncoding', a higher (close to 1) score means higher confidence
But if the prediction is 'coding', a lower (close to 0) score means higher confidence.

Here is the testing example output :

    #id     type    score
    CUFF.28053.1    coding  0.0411714
    CUFF.22215.2    noncoding       0.999991
    CUFF.370.2      coding  0.0379181
    CUFF.20080.1    noncoding       0.948769
    CUFF.4811.1     noncoding       0.999783
    CUFF.34724.1    coding  0.0221727
    CUFF.3197.1     coding  0.0383758
    CUFF.18196.1    coding  0.082468
    CUFF.7735.1     noncoding       0.962556
