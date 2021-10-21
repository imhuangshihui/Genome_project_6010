>UCSC Genome Browser assembly ID: rn6
Sequencing/Assembly provider ID: RGSC Rnor_6.0
Assembly date: Jul. 2014
Accession ID: GCA_000001895.4
NCBI Genome ID: 73 (Rattus norvegicus)
NCBI Assembly ID: 191871 (Rnor_6.0)
NCBI BioProject ID: 10629

# Target: Use iSeeRNA to train new species model, and put it to Sebnif to filter transcript gtf and predict new non-coding RNA
## A. Prepare conservation array directory
a. info file: The 1st col is the chromosome name, and 2nd is the length 

b. wiggle file: download from [UCSC](https://genome-asia.ucsc.edu/cgi-bin/hgTracks?db=rn6&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1%3A80607368%2D80638076&hgsid=758048143_f7VNKMTH3nKj2AgUIFwzgHbfYayO) -> Comparative Genomics -> Conservation -> [PhastCons conservation (WIG format)](http://hgdownload.soe.ucsc.edu/goldenPath/rn6/phastCons20way/) -> rn6.phastCons20way.wigFix.gz

slpit wiggle file to chr1..20..XYM (/home/huangsh/software/iSeeRNA-1.2.2/wiggle)

c. wig2ary: 

user@linux$ util/Wig2Array/auto_Wig2Array.sh  /path/to/wiggle/ /path/for/array/ /file/of/genome/info

/home/huangsh/software/iSeeRNA-1.2.2/util/Wig2Array/auto_Wig2Array.sh /home/huangsh/software/iSeeRNA-1.2.2/wiggle /home/huangsh/software/iSeeRNA-1.2.2/array /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6/rn6.filter.info

## B. Prepare configure file
a. GENOME: split chr to chr1.fa, chr2.fa...

b. CONSV: chr1.array, chr2.array...

  GENOME  /home/huangsh/software/iSeeRNA-1.2.2/genome/rn6
  CONSV   /home/huangsh/software/iSeeRNA-1.2.2/array
  SVMMODEL        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.model
  SVMPARAM        /home/huangsh/software/iSeeRNA-1.2.2/model/rn6.scale.param
## C. Train new SVM model
a. prepare lincRNA.gff and mRNA.gff

Refseq non-coding RNA download from Ensemble http://m.ensembl.org/Rattus_norvegicus/Info/Annotation
