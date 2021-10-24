'''
Change name if you want to find mRNA
Author: Shihui HUANG
2021.10.24
'''

with open('lncRNA_ID.txt', 'r') as file1:
    # create an empty list to store ID
    ID = []
    for line in file1:
        line = line.strip('\n')
        ID.append(line)
        # print(ID)
with open('Rattus_norvegicus.Rnor_6.0.104.chr.gff3', 'r') as file2:
    output = open('lncRNA.gff', 'w')
    for line in file2:
        line = line.split('\t')
        t1 = line[-1].split(';')
        t2 = t1[0].split(':')
        t3 = t2[-1]
        #print(t3)
        line_str = '\t'.join(line)
        for _id in ID:
            if _id in t3:
            # line_str = '\t'.join(line)
                output.write(line_str)
    output.close()
