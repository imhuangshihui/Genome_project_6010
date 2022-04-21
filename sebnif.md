https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=1335429951_Xtb6AbuwvLurqgTUiSzYv0eO618t&clade=mammal&org=Rat&db=rn6&hgta_group=varRep&hgta_track=simpleRepeat&hgta_table=0&hgta_regionType=genome&position=chrX%3A79%2C608%2C246-79%2C610%2C824&hgta_outputType=bed&hgta_outFileName=rat_simple.bed

從這裏下載simple repeat track的bed文件

![图片](https://user-images.githubusercontent.com/76728625/164423394-718268d3-0976-4471-a28e-8f2b60218fe1.png)

等待hisat2比對完之後，用taco合并，再用cufflink得到從頭注釋基因組，作爲sebnif的輸入
